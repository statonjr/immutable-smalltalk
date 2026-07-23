"
I am a collision node in a HAMT, storing multiple entries that share the same hash value.
 
See HAMTNode.
"
Class {
	#name : 'HAMTCollisionNode',
	#superclass : 'HAMTNode',
	#instVars : [
		'hash',
		'leaves'
	],
	#category : 'Immutable-HAMT',
	#package : 'Immutable-HAMT'
}

{ #category : 'as yet unclassified' }
HAMTCollisionNode >> bitForHash: aHash shift: shift [
    | index |
    index := ((aHash >> shift) bitAnd: 31) + 1.
    ^ 1 << (index - 1)
]

{ #category : 'initialization' }
HAMTCollisionNode >> do: aBlock [
    leaves do: [:leaf | leaf do: aBlock]
]

{ #category : 'initialization' }
HAMTCollisionNode >> initializeWithHash: aHash leaves: aLeaves [
    hash := aHash.
    leaves := aLeaves.
    self makeImmutable
]

{ #category : 'initialization' }
HAMTCollisionNode >> insert: aKey value: aValue hash: aHash shift: shift added: addedBlock [
	| existingIndex newLeaves |
    hash = aHash ifFalse: [
        "Different hash - promote to bitmap node"
        | bitmapNode |
        bitmapNode := HAMTBitmapNode new 
            initializeWithBitmap: (self bitForHash: hash shift: shift)
            children: {self}.
        ^ bitmapNode insert: aKey value: aValue hash: aHash shift: shift added: addedBlock].
    
    "Same hash - update or add to collision list"
    existingIndex := leaves findFirst: [:leaf | leaf key = aKey].
    existingIndex > 0 ifTrue: [
        addedBlock value: false.
        newLeaves := leaves copy.
        newLeaves at: existingIndex put: (HAMTLeafNode new 
            initializeWithHash: hash key: aKey value: aValue).
        ^ HAMTCollisionNode new initializeWithHash: hash leaves: newLeaves].
    
    addedBlock value: true.
    ^ HAMTCollisionNode new 
        initializeWithHash: hash 
        leaves: (leaves copyWith: (HAMTLeafNode new 
            initializeWithHash: hash key: aKey value: aValue))
]

{ #category : 'initialization' }
HAMTCollisionNode >> keysAndValuesDo: aBlock [
    leaves do: [:leaf | leaf keysAndValuesDo: aBlock]
]

{ #category : 'initialization' }
HAMTCollisionNode >> lookup: aKey hash: aHash shift: shift [
    hash = aHash ifFalse: [^ nil].
    ^ leaves detect: [:leaf | leaf key = aKey] ifNone: [nil]
]

{ #category : 'initialization' }
HAMTCollisionNode >> remove: aKey hash: aHash shift: shift [
    (hash = aHash and: [leaves size > 1]) ifTrue: [
        | newLeaves |
        newLeaves := leaves reject: [:leaf | leaf key = aKey].
        newLeaves size = leaves size ifTrue: [^ self].
        newLeaves size = 1 ifTrue: [^ newLeaves first].
        ^ HAMTCollisionNode new initializeWithHash: hash leaves: newLeaves].
    hash = aHash ifTrue: [^ nil].
    ^ self
]
