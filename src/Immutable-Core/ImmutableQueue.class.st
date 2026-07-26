"
I am an immutable persistent FIFO queue implemented as a normalized batched two-list queue.

I maintain two immutable lists:

	- `out` contains elements ready to be read in FIFO order.
   - `in` contains recently enqueued elements in reverse order.

I maintain the invariant that `out` is nonempty whenever the queue is nonempty.
The first element enqueued into an empty queue is therefore placed directly in
`out`. Subsequent elements are prepended to `in`.

When dequeue removes the last element from `out`, I reverse `in` and promote it
to the new `out`. This strict rotation keeps peek O(1) for every nonempty queue,
including a queue built entirely through enqueue operations.

Operation complexity:

   - enqueue: O(1)
   - peek: O(1)
   - dequeue: O(1) amortized along a linear sequence of queue versions
   - enumeration: O(n)

A rotation costs O(n). Because I am persistent, separate branches that dequeue
from the same pre-rotation version can repeat that cost; the amortized dequeue
bound therefore applies to linear use rather than arbitrary branching.

`dequeue` answers `{element. newQueue}`, or nil when empty. `peek` answers the
next element without changing the queue, or nil when empty. Every modifying
operation returns a new queue and leaves previous versions unchanged.

My representation is based on the batched functional queue described by Chris
Okasaki in _Purely Functional Data Structures_ (Cambridge University Press,
1998).
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

{ #category : 'comparing' }
ImmutableQueue >> = anObject [

		self == anObject ifTrue: [
         ^ true ].

      (anObject isKindOf: ImmutableObject) ifFalse: [
         ^ false ].

      anObject isImmutableQueue ifFalse: [
         ^ false ].

      ^ self asArray = anObject asArray
]

{ #category : 'adding' }
ImmutableQueue >> add: anObject [
    ^ self enqueue: anObject
]

{ #category : 'actions' }
ImmutableQueue >> dequeue [

       | element nextIn nextOut |
       self isEmpty ifTrue: [ ^ nil ].

       element := out first.
       nextIn := in.
       nextOut := out rest.

       nextOut isEmpty ifTrue: [
           nextOut := in reverse.
           nextIn := ImmutableList empty ].

       ^ {
           element.
           self class basicNew
               initializeWithIn: nextIn
               out: nextOut
       }
]

{ #category : 'enumerating' }
ImmutableQueue >> do: aBlock [
    out do: aBlock.
    in reverse do: aBlock
]

{ #category : 'actions' }
ImmutableQueue >> enqueue: anObject [

       out isEmpty ifTrue: [
           ^ self class basicNew
               initializeWithIn: in
               out: (out cons: anObject) ].

       ^ self class basicNew
           initializeWithIn: (in cons: anObject)
           out: out
]

{ #category : 'comparing' }
ImmutableQueue >> hash [

      | result |
      result := 16r515545.

      self do: [ :each |
         result := (result + each hash) hashMultiply ].

      ^ result
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

{ #category : 'testing' }
ImmutableQueue >> isImmutableQueue [

	^ true
]

{ #category : 'accessing' }
ImmutableQueue >> peek [

       self isEmpty ifTrue: [ ^ nil ].
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
