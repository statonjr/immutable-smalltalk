"
I am an immutable sorted set backed by ImmutableSortedMap.

Elements are maintained in natural sort order. All set operations are O(log₃₂ n)
via the underlying HAMT map. Supports first and last for accessing min/max elements.

Useful when ordered iteration or range queries are needed.
"
Class {
	#name : 'ImmutableSortedSet',
	#superclass : 'ImmutableObject',
	#traits : 'TImmutableEnumerable + TImmutableAddable',
	#classTraits : 'TImmutableEnumerable classTrait + TImmutableAddable classTrait',
	#instVars : [
		'sortedMap'
	],
	#classVars : [
		'EmptySortedSet'
	],
	#category : 'Immutable-Core',
	#package : 'Immutable-Core'
}

{ #category : 'requirements' }
ImmutableSortedSet class >> empty [
    EmptySortedSet ifNil: [EmptySortedSet := self basicNew initializeEmpty].
    ^ EmptySortedSet
]

{ #category : 'instance creation' }
ImmutableSortedSet class >> fromArray: anArray [
    | set |
    set := self empty.
    anArray do: [:each | set := set add: each].
    ^ set
]

{ #category : 'adding' }
ImmutableSortedSet >> add: anObject [
    ^ self class basicNew 
        initializeWithSortedMap: (sortedMap put: anObject value: true)
]

{ #category : 'converting' }
ImmutableSortedSet >> asArray [
    ^ sortedMap keys
]

{ #category : 'enumerating' }
ImmutableSortedSet >> do: aBlock [
    sortedMap keysAndValuesDo: [:key :value | aBlock value: key]

]

{ #category : 'accessing' }
ImmutableSortedSet >> first [
    | pair |
    pair := sortedMap first.
    ^ pair ifNotNil: [pair key]
]

{ #category : 'testing' }
ImmutableSortedSet >> includes: anObject [
    ^ sortedMap includesKey: anObject
]

{ #category : 'initialization' }
ImmutableSortedSet >> initializeEmpty [
    sortedMap := ImmutableSortedMap empty.
    self makeImmutable
]

{ #category : 'initialization' }
ImmutableSortedSet >> initializeWithSortedMap: aSortedMap [
    sortedMap := aSortedMap.
    self makeImmutable
]

{ #category : 'testing' }
ImmutableSortedSet >> isEmpty [
    ^ sortedMap isEmpty
]

{ #category : 'accessing' }
ImmutableSortedSet >> last [
    | pair |
    pair := sortedMap last.
    ^ pair ifNotNil: [pair key]
]

{ #category : 'printing' }
ImmutableSortedSet >> printOn: aStream [
	 | first |
    aStream nextPutAll: 'ImmutableSortedSet{'.
    first := true.
    self do: [:each |
        first ifTrue: [first := false] ifFalse: [aStream nextPutAll: ', '].
        each printOn: aStream].
    aStream nextPut: $}
]

{ #category : 'removing' }
ImmutableSortedSet >> remove: anObject [
    (sortedMap includesKey: anObject) ifFalse: [^ self].
    ^ self class basicNew 
        initializeWithSortedMap: (sortedMap removeKey: anObject)
]

{ #category : 'accessing' }
ImmutableSortedSet >> size [
    ^ sortedMap size
]
