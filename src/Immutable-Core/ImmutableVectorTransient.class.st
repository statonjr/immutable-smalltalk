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
    tail size < 32 ifTrue: [
        tail := tail copyWith: anObject.
        size := size + 1.
        ^ self].
    
    "Promote tail and start new one"
    root := self promoteTailIntoRoot.
    tail := Array with: anObject.
    size := size + 1
]

{ #category : 'initialization' }
ImmutableVectorTransient >> initializeFrom: aVector [
    size := aVector size.
    shift := aVector instVarNamed: 'shift'.
    root := (aVector instVarNamed: 'root') copy.
    tail := (aVector instVarNamed: 'tail') copy
]

{ #category : 'initialization' }
ImmutableVectorTransient >> insertNode: node intoRoot: aRoot atIndex: index shift: currentShift [
    | subIndex child |
    currentShift = 0 ifTrue: [^ node].
    
    subIndex := ((index >> currentShift) bitAnd: 31) + 1.
    child := aRoot at: subIndex ifAbsent: [nil].
    child ifNil: [child := Array new: 32. aRoot at: subIndex put: child].
    
    child
        at: ((index >> (currentShift - 5)) bitAnd: 31) + 1
        put: (self 
            insertNode: node 
            intoRoot: child 
            atIndex: index 
            shift: currentShift - 5).
    ^ aRoot
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
    | nodeCount |
    nodeCount := size >> 5.
    ^ self insertNode: tail intoRoot: root atIndex: nodeCount shift: shift
]
