"
I am a mutable helper for efficiently building ImmutableVectors in batch.
 
Created via ImmutableVectorTransient from: aVector. Call persistent to obtain the final ImmutableVector and invalidate the transient.
 
Inspired by Clojure's transient collections.
"
Class {
	#name : 'ImmutableVectorTransient',
	#superclass : 'ImmutableObject',
	#instVars : [
		'shift',
		'size',
		'root',
		'tail'
	],
	#classVars : [
		'EmptyVector'
	],
	#category : 'Immutable-Core',
	#package : 'Immutable-Core'
}

{ #category : 'instance creation' }
ImmutableVectorTransient class >> from: anImmutableVector [
    ^ self basicNew initializeFrom: anImmutableVector
]

{ #category : 'initialization' }
ImmutableVectorTransient >> add: anObject [

      tail ifNil: [
         self error: 'Cannot modify a transient after persistent was sent' ].

      tail size < 32 ifTrue: [
         tail := tail copyWith: anObject.
         size := size + 1.
         ^ self ].

      root := self promoteTailIntoRoot.
      tail := Array with: anObject.
      size := size + 1.

      ^ self
]

{ #category : 'initialization' }
ImmutableVectorTransient >> initializeFrom: aVector [
    size := aVector size.
    shift := aVector instVarNamed: 'shift'.
    root := (aVector instVarNamed: 'root') copy.
    tail := (aVector instVarNamed: 'tail') copy
]

{ #category : 'initialization' }
ImmutableVectorTransient >> insertTail: aTail intoRoot: aRoot atIndex: index shift: currentShift [
		| subIndex newRoot child newChild |
      subIndex := ((index >> currentShift) bitAnd: 31) + 1.
      newRoot := aRoot copy.

      currentShift = 5 ifTrue: [
         newRoot at: subIndex put: aTail.
         ^ newRoot ].

      child := aRoot
                  at: subIndex
                  ifAbsent: [ nil ].

      child ifNil: [
         child := Array new: 32 ].

      newChild := self
                     insertTail: aTail
                     intoRoot: child
                     atIndex: index
                     shift: currentShift - 5.

      newRoot at: subIndex put: newChild.

      ^ newRoot
]

{ #category : 'initialization' }
ImmutableVectorTransient >> persistent [
    | result |
    result := ImmutableVector basicNew
        initializeWithSize: size 
        shift: shift 
        root: root 
        tail: tail.
    "Invalidate self"
    size := 0.
    root := nil.
    tail := nil.
    ^ result
]

{ #category : 'initialization' }
ImmutableVectorTransient >> promoteTailIntoRoot [
		| newRoot tailStart |
      newRoot := root.

      "The current tree is full. Add a new root above it."
      ((size >> 5) > (1 << shift)) ifTrue: [
         newRoot := Array new: 32.
         newRoot at: 1 put: root.
         shift := shift + 5 ].

      tailStart := size - tail size.

      ^ self
           insertTail: tail
           intoRoot: newRoot
           atIndex: tailStart
           shift: shift
]
