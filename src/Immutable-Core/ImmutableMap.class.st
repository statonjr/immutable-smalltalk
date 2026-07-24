"
I am an immutable persistent hash map using a Hash Array Mapped Trie (HAMT).
 
O(log₃₂ n) operations for at:, put:value:, removeKey:, includesKey:. Structural sharing ensures efficient immutable updates.
 
Inspired by Clojure's PersistentHashMap, immutable-ruby's Immutable::Map, and Bagwell's HAMT (2001).
"
Class {
	#name : 'ImmutableMap',
	#superclass : 'ImmutableObject',
	#traits : 'TImmutableEnumerable + TImmutableAddable',
	#classTraits : 'TImmutableEnumerable classTrait + TImmutableAddable classTrait',
	#instVars : [
		'size',
		'root'
	],
	#classVars : [
		'EmptyMap'
	],
	#category : 'Immutable-Core',
	#package : 'Immutable-Core'
}

{ #category : 'requirements' }
ImmutableMap class >> empty [
    EmptyMap ifNil: [EmptyMap := self basicNew initializeEmpty].
    ^ EmptyMap
]

{ #category : 'requirements' }
ImmutableMap class >> fromAssociations: aCollection [
    | map |
    map := self empty.
    aCollection do: [:assoc | map := map put: assoc key value: assoc value].
    ^ map
]

{ #category : 'requirements' }
ImmutableMap class >> fromDictionary: aDictionary [
    | map |
    map := self empty.
    aDictionary keysAndValuesDo: [:key :value | map := map put: key value: value].
    ^ map
]

{ #category : 'initialization' }
ImmutableMap >> add: anAssociation [
    ^ self put: anAssociation key value: anAssociation value
]

{ #category : 'initialization' }
ImmutableMap >> at: key [
    ^ self at: key ifAbsent: [self error: 'Key not found: ', key printString]
]

{ #category : 'initialization' }
ImmutableMap >> at: key ifAbsent: aBlock [
    | hash result |
    hash := key hash.
    root ifNil: [^ aBlock value].
    result := root lookup: key hash: hash shift: 0.
    ^ result ifNil: [aBlock value] ifNotNil: [:node | node value]
]

{ #category : 'initialization' }
ImmutableMap >> at: key put: value [
    ^ self put: key value: value
]

{ #category : 'initialization' }
ImmutableMap >> collect: aBlock [
    | result |
    result := self class empty.
    self keysAndValuesDo: [:key :value | result := result put: key value: (aBlock value: key value: value)].
    ^ result
]

{ #category : 'initialization' }
ImmutableMap >> do: aBlock [
    root ifNotNil: [root do: aBlock]
]

{ #category : 'requirements' }
ImmutableMap >> fromAssociations: aCollection [
    | map |
    map := self empty.
    aCollection do: [:assoc | map := map put: assoc key value: assoc value].
    ^ map
]

{ #category : 'initialization' }
ImmutableMap >> includesKey: key [
    | hash |
    root ifNil: [^ false].
    hash := key hash.
    ^ (root lookup: key hash: hash shift: 0) notNil
]

{ #category : 'initialization' }
ImmutableMap >> initializeEmpty [
    size := 0.
    root := nil.
    self makeImmutable
]

{ #category : 'initialization' }
ImmutableMap >> initializeWithSize: aSize root: aRoot [
    size := aSize.
    root := aRoot.
    self makeImmutable
]

{ #category : 'initialization' }
ImmutableMap >> isEmpty [
    ^ size = 0
]

{ #category : 'initialization' }
ImmutableMap >> keys [
    | keys |
    keys := OrderedCollection new.
    self keysAndValuesDo: [:key :value | keys add: key].
    ^ keys
]

{ #category : 'initialization' }
ImmutableMap >> keysAndValuesDo: aBlock [
    root ifNotNil: [root keysAndValuesDo: aBlock]
]

{ #category : 'initialization' }
ImmutableMap >> merge: otherMap [
    | result |
    result := self.
    otherMap keysAndValuesDo: [:key :value | result := result put: key value: value].
    ^ result
]

{ #category : 'printing' }
ImmutableMap >> printOn: aStream [
	 | first |
    aStream nextPutAll: 'ImmutableMap{'.
    first := true.
    self keysAndValuesDo: [:key :value |
        first ifTrue: [first := false] ifFalse: [aStream nextPutAll: ', '].
        key printOn: aStream.
        aStream nextPutAll: ' -> '.
        value printOn: aStream].
    aStream nextPut: $}
]

{ #category : 'initialization' }
ImmutableMap >> put: key value: value [
    | hash newRoot added |
    hash := key hash.
    root ifNil: [
        newRoot := HAMTLeafNode new 
            initializeWithHash: hash key: key value: value.
        ^ self class basicNew initializeWithSize: 1 root: newRoot].
    
    added := false.
    newRoot := root insert: key value: value hash: hash shift: 0 added: [:b | added := b].
    ^ self class basicNew 
        initializeWithSize: (added ifTrue: [size + 1] ifFalse: [size]) 
        root: newRoot
]

{ #category : 'initialization' }
ImmutableMap >> removeKey: key [
		| hash newRoot |
      root ifNil: [ ^ self ].

      hash := key hash.
      newRoot := root
                    remove: key
                    hash: hash
                    shift: 0.

      "The HAMT removal protocol returns the original node when nothing
      changed. Preserve both the map's size and its identity."
      newRoot == root ifTrue: [ ^ self ].

      newRoot ifNil: [ ^ self class empty ].

      ^ self class basicNew
           initializeWithSize: size - 1
           root: newRoot
]

{ #category : 'initialization' }
ImmutableMap >> select: aBlock [
    | result |
    result := self class empty.
    self keysAndValuesDo: [:key :value | 
        (aBlock value: key value: value) ifTrue: [result := result put: key value: value]].
    ^ result
]

{ #category : 'initialization' }
ImmutableMap >> size [
    ^ size
]

{ #category : 'initialization' }
ImmutableMap >> values [
    | values |
    values := OrderedCollection new.
    self keysAndValuesDo: [:key :value | values add: value].
    ^ values
]
