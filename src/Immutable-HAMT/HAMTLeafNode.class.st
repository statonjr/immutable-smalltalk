"
I am a leaf node in a HAMT, storing a single key-value pair.
 
See HAMTNode.
"
Class {
	#name : 'HAMTLeafNode',
	#superclass : 'HAMTNode',
	#instVars : [
		'hash',
		'key',
		'value'
	],
	#category : 'Immutable-HAMT',
	#package : 'Immutable-HAMT'
}

{ #category : 'as yet unclassified' }
HAMTLeafNode >> bitForHash: aHash shift: shift [
    | index |
    index := ((aHash >> shift) bitAnd: 31) + 1.
    ^ 1 << (index - 1)
]

{ #category : 'initialization' }
HAMTLeafNode >> do: aBlock [
    aBlock value: key -> value
]

{ #category : 'evaluating' }
HAMTLeafNode >> hash [
	^ hash
]

{ #category : 'initialization' }
HAMTLeafNode >> initializeWithHash: aHash key: aKey value: aValue [
    hash := aHash.
    key := aKey.
    value := aValue.
    self makeImmutable
]

{ #category : 'initialization' }
HAMTLeafNode >> insert: aKey value: aValue hash: aHash shift: shift added: addedBlock [
		| existingBit newBit combinedBitmap existingIndex newIndex newChildren nestedNode |

      "Same key: replace its value."
      (hash = aHash and: [ key = aKey ]) ifTrue: [
         addedBlock value: false.
         ^ HAMTLeafNode new
              initializeWithHash: hash
              key: aKey
              value: aValue ].

      "Different keys with the same complete hash require a collision node."
      hash = aHash ifTrue: [
         addedBlock value: true.
         ^ HAMTCollisionNode new
              initializeWithHash: hash
              leaves: {
                    self.
                    (HAMTLeafNode new
                        initializeWithHash: aHash
                        key: aKey
                        value: aValue) } ].

      existingBit := self bitForHash: hash shift: shift.
      newBit := self bitForHash: aHash shift: shift.

      "The hashes differ, but this 5-bit chunk is the same.
      Add another trie level and continue until they diverge."
      existingBit = newBit ifTrue: [
         nestedNode := self
                          insert: aKey
                          value: aValue
                          hash: aHash
                          shift: shift + 5
                          added: addedBlock.

         ^ HAMTBitmapNode new
              initializeWithBitmap: existingBit
              children: { nestedNode } ].

      "The current chunks differ, so both leaves can occupy this level."
      combinedBitmap := existingBit bitOr: newBit.
      existingIndex := (combinedBitmap bitAnd: existingBit - 1) bitCount.
      newIndex := (combinedBitmap bitAnd: newBit - 1) bitCount.

      newChildren := Array new: 2.
      newChildren at: existingIndex + 1 put: self.
      newChildren
         at: newIndex + 1
         put: (HAMTLeafNode new
                initializeWithHash: aHash
                key: aKey
                value: aValue).

      addedBlock value: true.

      ^ HAMTBitmapNode new
           initializeWithBitmap: combinedBitmap
           children: newChildren
]

{ #category : 'accessing' }
HAMTLeafNode >> key [
	^ key
]

{ #category : 'initialization' }
HAMTLeafNode >> keysAndValuesDo: aBlock [
    aBlock value: key value: value
]

{ #category : 'initialization' }
HAMTLeafNode >> lookup: aKey hash: aHash shift: shift [
    hash = aHash ifFalse: [^ nil].
    key = aKey ifTrue: [^ self].
    ^ nil
]

{ #category : 'initialization' }
HAMTLeafNode >> remove: aKey hash: aHash shift: shift [
    (hash = aHash and: [key = aKey]) ifTrue: [^ nil].
    ^ self
]

{ #category : 'evaluating' }
HAMTLeafNode >> value [
	^ value
]
