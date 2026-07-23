"
I am an immutable sorted map backed by ImmutableMap and an ImmutableList of sorted keys.

Keys are maintained in natural sort order (< comparison). Lookup is delegated
to the underlying HAMT map for O(log₃₂ n) access. Insert and remove maintain
sorted key order in O(n) time.

Useful when ordered key traversal is needed alongside persistent map semantics.
"
Class {
	#name : 'ImmutableSortedMap',
	#superclass : 'ImmutableObject',
	#traits : 'TImmutableEnumerable - {#select:. #collect:. #reject:} + TImmutableAddable',
	#classTraits : 'TImmutableEnumerable classTrait + TImmutableAddable classTrait',
	#instVars : [
		'map',
		'sortedKeys'
	],
	#classVars : [
		'EmptySortedMap'
	],
	#category : 'Immutable-Core',
	#package : 'Immutable-Core'
}

{ #category : 'requirements' }
ImmutableSortedMap class >> empty [
    EmptySortedMap ifNil: [EmptySortedMap := self basicNew initializeEmpty].
    ^ EmptySortedMap
]

{ #category : 'instance creation' }
ImmutableSortedMap class >> fromAssociations: aCollection [
    | map |
    map := self empty.
    aCollection do: [:assoc | map := map put: assoc key value: assoc value].
    ^ map
]

{ #category : 'sorting' }
ImmutableSortedMap class >> sortBlock: aBlock [
    "Create empty sorted map with custom sort order"
    ^ self basicNew initializeWithSortBlock: aBlock
]

{ #category : 'adding' }
ImmutableSortedMap >> add: anAssociation [
    ^ self put: anAssociation key value: anAssociation value
]

{ #category : 'accessing' }
ImmutableSortedMap >> at: key [
    ^ map at: key
]

{ #category : 'accessing' }
ImmutableSortedMap >> at: key ifAbsent: aBlock [
    ^ map at: key ifAbsent: aBlock
]

{ #category : 'enumerating' }
ImmutableSortedMap >> collect: aBlock [
    | newMap |
    newMap := ImmutableSortedMap empty.
    self keysAndValuesDo: [:key :value |
        newMap := newMap put: key value: (aBlock value: key value: value)].
    ^ newMap
]

{ #category : 'enumerating' }
ImmutableSortedMap >> do: aBlock [
    sortedKeys do: [:key | aBlock value: key -> (map at: key)]
]

{ #category : 'accessing' }
ImmutableSortedMap >> first [
    sortedKeys isEmpty ifTrue: [^ nil].
    ^ sortedKeys first -> (map at: sortedKeys first)
]

{ #category : 'testing' }
ImmutableSortedMap >> includesKey: key [
    ^ map includesKey: key
]

{ #category : 'initialization' }
ImmutableSortedMap >> initializeEmpty [
    map := ImmutableMap empty.
    sortedKeys := ImmutableList empty.
    self makeImmutable
]

{ #category : 'initialization' }
ImmutableSortedMap >> initializeWithMap: aMap sortedKeys: aList [
    map := aMap.
    sortedKeys := aList.
    self makeImmutable
]

{ #category : 'initialization' }
ImmutableSortedMap >> initializeWithSortBlock: aBlock [
    map := ImmutableMap empty.
    "sortedKeys will be an ordered list using the sort block"
    self makeImmutable
]

{ #category : 'adding' }
ImmutableSortedMap >> insertKey: key intoSorted: aList [
    | rest |
    aList isEmpty ifTrue: [^ ImmutableList empty cons: key].
    key < aList first ifTrue: [^ aList cons: key].
    rest := self insertKey: key intoSorted: aList rest.
    ^ rest cons: aList first
]

{ #category : 'testing' }
ImmutableSortedMap >> isEmpty [
    ^ map isEmpty

]

{ #category : 'accessing' }
ImmutableSortedMap >> keys [
    ^ sortedKeys asArray
]

{ #category : 'enumerating' }
ImmutableSortedMap >> keysAndValuesDo: aBlock [
    sortedKeys do: [:key | aBlock value: key value: (map at: key)]
]

{ #category : 'accessing' }
ImmutableSortedMap >> last [
    sortedKeys isEmpty ifTrue: [^ nil].
    ^ sortedKeys last -> (map at: sortedKeys last)
]

{ #category : 'printing' }
ImmutableSortedMap >> printOn: aStream [
	 | first |
    aStream nextPutAll: 'ImmutableSortedMap{'.
    first := true.
    self keysAndValuesDo: [:key :value |
        first ifTrue: [first := false] ifFalse: [aStream nextPutAll: ', '].
        key printOn: aStream.
        aStream nextPutAll: ' -> '.
        value printOn: aStream].
    aStream nextPut: $}
]

{ #category : 'initialization' }
ImmutableSortedMap >> put: key value: value [
    | newMap newKeys |
    newMap := map put: key value: value.
    newKeys := (map includesKey: key)
        ifTrue: [sortedKeys]  "Key already present, order unchanged"
        ifFalse: [self insertKey: key intoSorted: sortedKeys].
    ^ self class basicNew initializeWithMap: newMap sortedKeys: newKeys
]

{ #category : 'enumerating' }
ImmutableSortedMap >> reject: aBlock [
    ^ self select: [:key :value | (aBlock value: key value: value) not]
]

{ #category : 'removing' }
ImmutableSortedMap >> removeKey: key [
    (map includesKey: key) ifFalse: [^ self].
    ^ self class basicNew 
        initializeWithMap: (map removeKey: key) 
        sortedKeys: (self removeKey: key fromSorted: sortedKeys)
]

{ #category : 'removing' }
ImmutableSortedMap >> removeKey: key fromSorted: aList [
    aList isEmpty ifTrue: [^ aList].
    aList first = key ifTrue: [^ aList rest].
    ^ (self removeKey: key fromSorted: aList rest) cons: aList first
]

{ #category : 'enumerating' }
ImmutableSortedMap >> select: aBlock [
    | newMap |
    newMap := ImmutableSortedMap empty.
    self keysAndValuesDo: [:key :value |
        (aBlock value: key value: value) ifTrue: [
            newMap := newMap put: key value: value]].
    ^ newMap
]

{ #category : 'accessing' }
ImmutableSortedMap >> size [
    ^ map size
]
