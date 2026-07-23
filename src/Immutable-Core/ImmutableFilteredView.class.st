Class {
	#name : 'ImmutableFilteredView',
	#superclass : 'ImmutableObject',
	#traits : 'TImmutableLazySequence + TImmutableAddable + (TImmutableEnumerable - {#select:. #collect:. #reject:})',
	#classTraits : 'TImmutableLazySequence classTrait + TImmutableAddable classTrait + TImmutableEnumerable classTrait',
	#instVars : [
		'source',
		'predicate'
	],
	#category : 'Immutable-Core',
	#package : 'Immutable-Core'
}

{ #category : 'as yet unclassified' }
ImmutableFilteredView class >> on: aSequence predicate: aBlock [
    ^ self basicNew initializeWithSource: aSequence predicate: aBlock

]

{ #category : 'initialization' }
ImmutableFilteredView >> add: anObject [
    ^ self asImmutableVector add: anObject
]

{ #category : 'initialization' }
ImmutableFilteredView >> asImmutableVector [
    | t |
    t := ImmutableVectorTransient from: ImmutableVector empty.
    self do: [:each | t add: each].
    ^ t persistent
]

{ #category : 'initialization' }
ImmutableFilteredView >> cons: anObject [
    ^ self asImmutableVector cons: anObject
]

{ #category : 'initialization' }
ImmutableFilteredView >> do: aBlock [
    source do: [:each | (predicate value: each) ifTrue: [aBlock value: each]]
]

{ #category : 'initialization' }
ImmutableFilteredView >> drop: n [
    | count current |
    count := 0.
    current := source.
    [count < n and: [current isNotEmpty]] whileTrue: [
        (predicate value: current first) ifTrue: [count := count + 1].
        current := current rest].
    ^ ImmutableFilteredView on: current predicate: predicate
]

{ #category : 'initialization' }
ImmutableFilteredView >> first [
    source do: [:each | (predicate value: each) ifTrue: [^ each]].
    ^ nil
]

{ #category : 'initialization' }
ImmutableFilteredView >> initializeWithSource: aSequence predicate: aBlock [
    source := aSequence.
    predicate := aBlock.
    self makeImmutable
]

{ #category : 'initialization' }
ImmutableFilteredView >> isEmpty [
    self first ifNil: [^ true].
    ^ false
]

{ #category : 'initialization' }
ImmutableFilteredView >> rest [
    | skipped |
    skipped := source.
    [skipped isNotEmpty and: [(predicate value: skipped first) not]] 
        whileTrue: [skipped := skipped rest].
    skipped isEmpty ifTrue: [^ ImmutableVector empty].
    ^ ImmutableFilteredView on: skipped rest predicate: predicate
]

{ #category : 'initialization' }
ImmutableFilteredView >> species [
    ^ ImmutableVector
]

{ #category : 'initialization' }
ImmutableFilteredView >> take: n [
    | result count |
    result := ImmutableVectorTransient from: ImmutableVector empty.
    count := 0.
    self do: [:each |
        count >= n ifTrue: [^ result persistent].
        result add: each.
        count := count + 1].
    ^ result persistent
]
