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
		'cache'
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

	^ cache add: anObject
]

{ #category : 'converting' }
ImmutableMemoizedView >> asImmutableVector [

	^ cache asImmutableVector
]

{ #category : 'adding' }
ImmutableMemoizedView >> cons: anObject [

	^ cache cons: anObject
]

{ #category : 'enumerating' }
ImmutableMemoizedView >> do: aBlock [

	cache do: aBlock
]

{ #category : 'accessing' }
ImmutableMemoizedView >> drop: n [

	^ cache drop: n
]

{ #category : 'accessing' }
ImmutableMemoizedView >> first [

	^ cache first
]

{ #category : 'initialization' }
ImmutableMemoizedView >> initializeWithCache: aList [

       cache := aList.
       self makeImmutable
]

{ #category : 'testing' }
ImmutableMemoizedView >> isEmpty [

	^ cache isEmpty
]

{ #category : 'accessing' }
ImmutableMemoizedView >> rest [

	cache rest isEmpty ifTrue: [ ^ ImmutableVector empty ].
	^ ImmutableMemoizedView onCache: cache rest
]

{ #category : 'accessing' }
ImmutableMemoizedView >> size [

	^ cache size
]

{ #category : 'private' }
ImmutableMemoizedView >> species [
    ^ ImmutableVector
]

{ #category : 'accessing' }
ImmutableMemoizedView >> take: n [

	^ cache take: n
]
