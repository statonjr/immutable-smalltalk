Class {
	#name : 'ImmutableMappedView',
	#superclass : 'ImmutableObject',
	#traits : 'TImmutableLazySequence + TImmutableAddable + (TImmutableEnumerable - {#select:. #collect:. #reject:})',
	#classTraits : 'TImmutableLazySequence classTrait + TImmutableAddable classTrait + TImmutableEnumerable classTrait',
	#instVars : [
		'source',
		'transform'
	],
	#category : 'Immutable-Core',
	#package : 'Immutable-Core'
}

{ #category : 'as yet unclassified' }
ImmutableMappedView class >> on: aSequence transform: aBlock [
    ^ self basicNew initializeWithSource: aSequence transform: aBlock
]

{ #category : 'accessing' }
ImmutableMappedView >> add: anObject [
    ^ self asImmutableVector add: anObject
]

{ #category : 'accessing' }
ImmutableMappedView >> asImmutableVector [
    | t |
    t := ImmutableVectorTransient from: ImmutableVector empty.
    self do: [:each | t add: each].
    ^ t persistent
]

{ #category : 'accessing' }
ImmutableMappedView >> cons: anObject [
    ^ self asImmutableVector cons: anObject
]

{ #category : 'accessing' }
ImmutableMappedView >> do: aBlock [
    source do: [:each | aBlock value: (transform value: each)]
]

{ #category : 'accessing' }
ImmutableMappedView >> drop: n [
    ^ ImmutableMappedView on: (source drop: n) transform: transform
]

{ #category : 'accessing' }
ImmutableMappedView >> first [
    source isEmpty ifTrue: [^ nil].
    ^ transform value: source first
]

{ #category : 'initialization' }
ImmutableMappedView >> initializeWithSource: aSequence transform: aBlock [
    source := aSequence.
    transform := aBlock.
    self makeImmutable
]

{ #category : 'accessing' }
ImmutableMappedView >> isEmpty [
    ^ source isEmpty
]

{ #category : 'accessing' }
ImmutableMappedView >> rest [
    source rest isEmpty ifTrue: [^ ImmutableVector empty].
    ^ ImmutableMappedView on: source rest transform: transform
]

{ #category : 'accessing' }
ImmutableMappedView >> species [
    ^ ImmutableVector
]

{ #category : 'accessing' }
ImmutableMappedView >> take: n [
    ^ ImmutableMappedView on: (source take: n) transform: transform
]
