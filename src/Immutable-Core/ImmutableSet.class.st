"
I am an immutable persistent hash set backed by ImmutableMap.
 
O(log₃₂ n) operations for add:, remove:, includes:. Supports set-theoretic operations: union:, intersection:, difference:.
 
Inspired by Clojure's PersistentHashSet and immutable-ruby's Immutable::Set.
"
Class {
	#name : 'ImmutableSet',
	#superclass : 'ImmutableObject',
	#traits : 'TImmutableAddable + TImmutableEnumerable',
	#classTraits : 'TImmutableAddable classTrait + TImmutableEnumerable classTrait',
	#instVars : [
		'map'
	],
	#classVars : [
		'EmptySet'
	],
	#category : 'Immutable-Core',
	#package : 'Immutable-Core'
}

{ #category : 'requirements' }
ImmutableSet class >> empty [
    EmptySet ifNil: [EmptySet := self basicNew initializeEmpty].
    ^ EmptySet
]

{ #category : 'requirements' }
ImmutableSet class >> fromArray: anArray [
    | set |
    set := self empty.
    anArray do: [:each | set := set add: each].
    ^ set
]

{ #category : 'requirements' }
ImmutableSet class >> withAll: aCollection [
    ^ self fromArray: aCollection asArray
]

{ #category : 'comparing' }
ImmutableSet >> = anObject [

	self == anObject ifTrue: [ ^ true ].
	(anObject isKindOf: ImmutableObject) ifFalse: [ ^ false ].
	anObject isImmutableSet ifFalse: [ ^ false ].
	self size = anObject size ifFalse: [ ^ false ].
	^ self allSatisfy: [ :each | anObject includes: each ]
]

{ #category : 'adding' }
ImmutableSet >> add: anObject [
    ^ self class basicNew initializeWithMap: (map put: anObject value: true)
]

{ #category : 'transforming' }
ImmutableSet >> asArray [
    | result |
    result := OrderedCollection new.
    self do: [:each | result add: each].
    ^ result asArray
]

{ #category : 'operations' }
ImmutableSet >> difference: otherSet [
    ^ self reject: [:each | otherSet includes: each]
]

{ #category : 'enumerating' }
ImmutableSet >> do: aBlock [
    map keysAndValuesDo: [:key :value | aBlock value: key]

]

{ #category : 'comparing' }
ImmutableSet >> hash [

      | result |
      result := 16r534554 bitXor: self size hash.

      self do: [ :each |
         result := result bitXor: each hash hashMultiply ].

      ^ result
]

{ #category : 'testing' }
ImmutableSet >> includes: anObject [
    ^ map includesKey: anObject
]

{ #category : 'initialization' }
ImmutableSet >> initializeEmpty [
    map := ImmutableMap empty.
    self makeImmutable
]

{ #category : 'initialization' }
ImmutableSet >> initializeWithMap: aMap [
    map := aMap.
    self makeImmutable
]

{ #category : 'operations' }
ImmutableSet >> intersection: otherSet [
    ^ self select: [:each | otherSet includes: each]
]

{ #category : 'testing' }
ImmutableSet >> isEmpty [
    ^ map isEmpty
]

{ #category : 'testing' }
ImmutableSet >> isImmutableSet [ 

	^ true.
]

{ #category : 'printing' }
ImmutableSet >> printOn: aStream [
	 | first |
    aStream nextPutAll: 'ImmutableSet{'.
    first := true.
    self do: [:each |
        first ifTrue: [first := false] ifFalse: [aStream nextPutAll: ', '].
        each printOn: aStream].
    aStream nextPut: $}
]

{ #category : 'removing' }
ImmutableSet >> remove: anObject [
    (map includesKey: anObject) ifFalse: [^ self].
    ^ self class basicNew initializeWithMap: (map removeKey: anObject)
]

{ #category : 'accessing' }
ImmutableSet >> size [
    ^ map size

]

{ #category : 'operations' }
ImmutableSet >> union: otherSet [
    | result |
    result := self.
    otherSet do: [:each | result := result add: each].
    ^ result
]
