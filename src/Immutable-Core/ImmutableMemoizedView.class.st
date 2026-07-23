"
I cache the result of a sequence traversal for reuse.

Created via 'aSequence memoize' or 'ImmutableMemoizedView on: aSequence'.
The source sequence is traversed once on creation and stored as an ImmutableList.
Subsequent traversals hit the cache, avoiding recomputation of expensive chains.

Useful when a lazy chain (select:, collect:, etc.) will be traversed multiple times.

Inspired by Clojure's LazySeq memoization and Clojure's doall.
"
Class {
	#name : 'ImmutableMemoizedView',
	#superclass : 'ImmutableObject',
	#traits : 'TImmutableLazySequence + TImmutableAddable + (TImmutableEnumerable - {#select:. #collect:. #reject:})',
	#classTraits : 'TImmutableLazySequence classTrait + TImmutableAddable classTrait + TImmutableEnumerable classTrait',
	#instVars : [
		'source',
		'cache',
		'realized'
	],
	#category : 'Immutable-Core',
	#package : 'Immutable-Core'
}

{ #category : 'instance creation' }
ImmutableMemoizedView class >> on: aSequence [
    | cache |
    cache := ImmutableList empty.
    aSequence do: [:each | cache := cache cons: each].
    ^ self basicNew initializeWithCache: cache reverse
]

{ #category : 'accessing' }
ImmutableMemoizedView class >> onCache: aList [
    ^ self basicNew initializeWithCache: aList
]

{ #category : 'adding' }
ImmutableMemoizedView >> add: anObject [
    self realizeIfNeeded.
    ^ cache add: anObject
]

{ #category : 'converting' }
ImmutableMemoizedView >> asImmutableVector [
    self realizeIfNeeded.
    ^ cache asImmutableVector
]

{ #category : 'initialization' }
ImmutableMemoizedView >> cons: anObject [
    self realizeIfNeeded.
    ^ cache cons: anObject
]

{ #category : 'enumerating' }
ImmutableMemoizedView >> do: aBlock [
    self realizeIfNeeded.
    cache do: aBlock
]

{ #category : 'accessing' }
ImmutableMemoizedView >> drop: n [
    self realizeIfNeeded.
    ^ cache drop: n
]

{ #category : 'accessing' }
ImmutableMemoizedView >> first [
    self realizeIfNeeded.
    ^ cache first
]

{ #category : 'initialization' }
ImmutableMemoizedView >> initializeWithCache: aList [
    cache := aList.
    realized := true.
    source := nil.
    self makeImmutable
]

{ #category : 'initialization' }
ImmutableMemoizedView >> initializeWithSource: aSequence [
    source := aSequence.
    cache := ImmutableList empty.
    realized := false.
    self makeImmutable
]

{ #category : 'testing' }
ImmutableMemoizedView >> isEmpty [
    self realizeIfNeeded.
    ^ cache isEmpty
]

{ #category : 'accessing' }
ImmutableMemoizedView >> realizeIfNeeded [
	 | result |
    realized ifTrue: [^ self].
    result := ImmutableList empty.
    source do: [:each | result := result cons: each].
    cache := result reverse.
    source := nil.  "Release source, cache holds everything"
    realized := true
]

{ #category : 'accessing' }
ImmutableMemoizedView >> rest [
    self realizeIfNeeded.
    cache rest isEmpty ifTrue: [^ ImmutableVector empty].
    ^ ImmutableMemoizedView onCache: cache rest
]

{ #category : 'accessing' }
ImmutableMemoizedView >> size [
    self realizeIfNeeded.
    ^ cache size
]

{ #category : 'private' }
ImmutableMemoizedView >> species [
    ^ ImmutableVector
]

{ #category : 'accessing' }
ImmutableMemoizedView >> take: n [
    self realizeIfNeeded.
    ^ cache take: n
]
