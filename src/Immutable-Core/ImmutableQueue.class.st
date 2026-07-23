"
I am an immutable persistent queue with O(1) amortized enqueue and dequeue.

Implemented using two lists: 'in' holds recently enqueued elements in reverse order,
'out' holds elements ready for dequeue in correct order. When 'out' is empty and
a dequeue is requested, 'in' is reversed into 'out'.

This classic two-stack queue (Okasaki 1995) is both simple and efficient, with
structural sharing ensuring persistence.

Inspired by Clojure's PersistentQueue and Okasaki's Purely Functional Data Structures.
"
Class {
	#name : 'ImmutableQueue',
	#superclass : 'ImmutableObject',
	#traits : 'TImmutableEnumerable + TImmutableAddable',
	#classTraits : 'TImmutableEnumerable classTrait + TImmutableAddable classTrait',
	#instVars : [
		'in',
		'out'
	],
	#classVars : [
		'EmptyQueue'
	],
	#category : 'Immutable-Core',
	#package : 'Immutable-Core'
}

{ #category : 'requirements' }
ImmutableQueue class >> empty [
    EmptyQueue ifNil: [EmptyQueue := self basicNew initializeEmpty].
    ^ EmptyQueue
]

{ #category : 'instance creation' }
ImmutableQueue class >> fromArray: anArray [
    | queue |
    queue := self empty.
    anArray do: [:each | queue := queue enqueue: each].
    ^ queue
]

{ #category : 'adding' }
ImmutableQueue >> add: anObject [
    ^ self enqueue: anObject
]

{ #category : 'actions' }
ImmutableQueue >> dequeue [
    "O(1) amortized. Returns array {element. newQueue} or nil if empty."
    self isEmpty ifTrue: [^ nil].
    out isEmpty ifTrue: [
        | reversed |
        reversed := in reverse.
        ^ {reversed first. self class basicNew initializeWithIn: ImmutableList empty out: reversed rest}].
    ^ {out first. self class basicNew initializeWithIn: in out: out rest}
]

{ #category : 'enumerating' }
ImmutableQueue >> do: aBlock [
    out do: aBlock.
    in reverse do: aBlock
]

{ #category : 'actions' }
ImmutableQueue >> enqueue: anObject [
    "O(1) amortized"
    ^ self class basicNew initializeWithIn: (in cons: anObject) out: out
]

{ #category : 'initialization' }
ImmutableQueue >> initializeEmpty [
    in := ImmutableList empty.
    out := ImmutableList empty.
    self makeImmutable
]

{ #category : 'initialization' }
ImmutableQueue >> initializeWithIn: inList out: outList [
    in := inList.
    out := outList.
    self makeImmutable
]

{ #category : 'testing' }
ImmutableQueue >> isEmpty [
    ^ in isEmpty and: [out isEmpty]
]

{ #category : 'accessing' }
ImmutableQueue >> peek [
    "O(1) amortized"
    self isEmpty ifTrue: [^ nil].
    out isEmpty ifTrue: [
        | reversed |
        reversed := in reverse.
        ^ reversed first].
    ^ out first
]

{ #category : 'printing' }
ImmutableQueue >> printOn: aStream [
	| first |
    aStream nextPutAll: 'ImmutableQueue('.
    first := true.
    self do: [:each |
        first ifTrue: [first := false] ifFalse: [aStream space].
        each printOn: aStream].
    aStream nextPut: $)
]

{ #category : 'accessing' }
ImmutableQueue >> size [
    ^ in size + out size
]
