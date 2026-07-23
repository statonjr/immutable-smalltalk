"
I am an immutable persistent list using cons cells with structural sharing.
 
O(1) prepend via cons:, O(n) append via add:.
 
I implement the TImmutableSequence trait providing Lisp-style accessors:  car, cdr, cadr, caddr, take:, drop:, reverse, etc.
 
Inspired by Clojure's PersistentList and immutable-ruby's Immutable::List.""
"
Class {
	#name : 'ImmutableList',
	#superclass : 'ImmutableObject',
	#traits : 'TImmutableSequence + TImmutableEnumerable + TImmutableAddable',
	#classTraits : 'TImmutableSequence classTrait + TImmutableEnumerable classTrait + TImmutableAddable classTrait',
	#instVars : [
		'head',
		'tail',
		'size'
	],
	#classVars : [
		'EmptyList'
	],
	#category : 'Immutable-Core',
	#package : 'Immutable-Core'
}

{ #category : 'requirements' }
ImmutableList class >> empty [
    EmptyList ifNil: [EmptyList := self basicNew initializeEmpty].
    ^ EmptyList
]

{ #category : 'requirements' }
ImmutableList class >> fromArray: anArray [
    | result |
    result := self empty.
    anArray reverseDo: [:each | result := result cons: each].
    ^ result
]

{ #category : 'requirements' }
ImmutableList class >> with: anObject [
    ^ self empty cons: anObject
]

{ #category : 'requirements' }
ImmutableList class >> with: first with: second [
    ^ (self empty cons: second) cons: first
]

{ #category : 'requirements' }
ImmutableList class >> with: first with: second with: third [
    ^ ((self empty cons: third) cons: second) cons: first
]

{ #category : 'requirements' }
ImmutableList class >> withAll: aCollection [
    ^ self fromArray: aCollection asArray
]

{ #category : 'accessing' }
ImmutableList >> add: anObject [
    ^ self cons: anObject
]

{ #category : 'accessing' }
ImmutableList >> append: otherList [
    | result |
    result := otherList.
    self reverseDo: [:each | result := result cons: each].
    ^ result
]

{ #category : 'accessing' }
ImmutableList >> asArray [
    | result current i |
    result := Array new: size.
    current := self.
    i := 1.
    [current isEmpty] whileFalse: [
        result at: i put: current first.
        current := current rest.
        i := i + 1].
    ^ result
]

{ #category : 'accessing' }
ImmutableList >> at: index [
    | current i |
    (index < 0 or: [index >= size]) ifTrue: [^ nil].
    current := self.
    i := index.
    [i > 0] whileTrue: [
        current := current rest.
        i := i - 1].
    ^ current first
]

{ #category : 'initialization' }
ImmutableList >> car [
    self isEmpty ifTrue: [^ nil].
    ^ head
]

{ #category : 'initialization' }
ImmutableList >> cons: anObject [
    ^ self class basicNew initializeWithHead: anObject tail: self
]

{ #category : 'accessing' }
ImmutableList >> do: aBlock [
    | current |
    current := self.
    [current isEmpty] whileFalse: [
        aBlock value: current first.
        current := current rest]
]

{ #category : 'initialization' }
ImmutableList >> first [
    self isEmpty ifTrue: [^ nil].
    ^ head
]

{ #category : 'initialization' }
ImmutableList >> initializeEmpty [
    head := nil.
    tail := nil.
    size := 0.
    self makeImmutable
]

{ #category : 'initialization' }
ImmutableList >> initializeWithHead: anObject tail: aList [
    head := anObject.
    tail := aList.
    size := aList size + 1.
    self makeImmutable
]

{ #category : 'testing' }
ImmutableList >> isEmpty [
    ^ size = 0
]

{ #category : 'accessing' }
ImmutableList >> last [
    | current |
    self isEmpty ifTrue: [^ nil].
    current := self.
    [current rest isEmpty] whileFalse: [current := current rest].
    ^ current first
]

{ #category : 'printing' }
ImmutableList >> printOn: aStream [
	| current first |
    aStream nextPutAll: 'ImmutableList('.
    current := self.
    first := true.
    [current isEmpty] whileFalse: [
        first ifTrue: [first := false] ifFalse: [aStream space].
        current first printOn: aStream.
        current := current rest].
    aStream nextPut: $)
]

{ #category : 'accessing' }
ImmutableList >> rest [
    self isEmpty ifTrue: [self error: 'Cannot take rest of empty list'].
    ^ tail
]

{ #category : 'accessing' }
ImmutableList >> reverse [
    | result current |
    result := ImmutableList empty.
    current := self.
    [current isEmpty] whileFalse: [
        result := result cons: current first.
        current := current rest].
    ^ result
]

{ #category : 'accessing' }
ImmutableList >> reverseDo: aBlock [
    self isEmpty ifTrue: [^ self].
    self rest reverseDo: aBlock.
    aBlock value: self first
]

{ #category : 'accessing' }
ImmutableList >> size [
    ^ size
]

{ #category : 'private' }
ImmutableList >> species [
    ^ ImmutableList
]
