"
I am a lazy filtered view over a sequence, created by select: and reject:.

I hold a source sequence and a predicate block. Iteration applies the predicate,
skipping elements that don't match. First access walks the source until a match
is found. Take and drop operations stay lazy.

Realization happens via add:, cons:, or asImmutableVector.

Inspired by Clojure's lazy sequence filtering (filter).
"
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

{ #category : 'adding' }
ImmutableFilteredView >> add: anObject [
    ^ self asImmutableVector add: anObject
]

{ #category : 'transforming' }
ImmutableFilteredView >> asImmutableVector [
    | t |
    t := ImmutableVectorTransient from: ImmutableVector empty.
    self do: [:each | t add: each].
    ^ t persistent
]

{ #category : 'adding' }
ImmutableFilteredView >> cons: anObject [
    ^ self asImmutableVector cons: anObject
]

{ #category : 'enumerating' }
ImmutableFilteredView >> do: aBlock [
    source do: [:each | (predicate value: each) ifTrue: [aBlock value: each]]
]

{ #category : 'enumerating' }
ImmutableFilteredView >> drop: n [
    | count current |
    count := 0.
    current := source.
    [count < n and: [current isNotEmpty]] whileTrue: [
        (predicate value: current first) ifTrue: [count := count + 1].
        current := current rest].
    ^ ImmutableFilteredView on: current predicate: predicate
]

{ #category : 'accessing' }
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

{ #category : 'testing' }
ImmutableFilteredView >> isEmpty [

	^ source noneSatisfy: [ :each | predicate value: each ]
]

{ #category : 'accessing' }
ImmutableFilteredView >> rest [
    | skipped |
    skipped := source.
    [skipped isNotEmpty and: [(predicate value: skipped first) not]] 
        whileTrue: [skipped := skipped rest].
    skipped isEmpty ifTrue: [^ ImmutableVector empty].
    ^ ImmutableFilteredView on: skipped rest predicate: predicate
]

{ #category : 'private' }
ImmutableFilteredView >> species [
    ^ ImmutableVector
]

{ #category : 'enumerating' }
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
