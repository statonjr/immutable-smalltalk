"
I extend TImmutableSequence with lazy evaluation for select:, collect:, and reject:.

Instead of realizing intermediate collections, these methods return lazy views
(ImmutableFilteredView, ImmutableMappedView) that defer computation until iteration.
Chained operations stack views without copying.

Realization happens when calling add:, cons:, asImmutableVector, or iterating via do:.

Inspired by Clojure's LazySeq.
"
Trait {
	#name : 'TImmutableLazySequence',
	#traits : 'TImmutableSequence',
	#classTraits : 'TImmutableSequence classTrait',
	#category : 'Immutable-Collections',
	#package : 'Immutable-Collections'
}

{ #category : 'enumerating' }
TImmutableLazySequence >> collect: aBlock [
    ^ ImmutableMappedView on: self transform: aBlock
]

{ #category : 'enumerating' }
TImmutableLazySequence >> reject: aBlock [
    ^ ImmutableFilteredView on: self predicate: [:each | (aBlock value: each) not]
]

{ #category : 'enumerating' }
TImmutableLazySequence >> select: aBlock [
    ^ ImmutableFilteredView on: self predicate: aBlock
]
