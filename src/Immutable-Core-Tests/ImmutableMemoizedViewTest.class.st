Class {
	#name : 'ImmutableMemoizedViewTest',
	#superclass : 'TestCase',
	#instVars : [
		'vec'
	],
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'running' }
ImmutableMemoizedViewTest >> setUp [
	super setUp.

	vec := ImmutableVector fromArray: #(11 22 33 44 55 66 77 88 99 111)
]

{ #category : 'tests' }
ImmutableMemoizedViewTest >> testDo [
    | view results |
    view := ImmutableMemoizedView on: vec.
    results := OrderedCollection new.
    view do: [:each | results add: each].
    self assert: results size equals: 10.
    results := OrderedCollection new.
    view do: [:each | results add: each].  "Second traversal uses cache"
    self assert: results size equals: 10
]

{ #category : 'tests' }
ImmutableMemoizedViewTest >> testDrop [
    | view result |
    view := ImmutableMemoizedView on: vec.
    result := view drop: 3.
    self assert: result size equals: 7.
    self assert: result first equals: 44
]

{ #category : 'tests' }
ImmutableMemoizedViewTest >> testFirst [
    | view |
    view := ImmutableMemoizedView on: vec.
    self assert: view first equals: 11.
    self assert: view first equals: 11  "Second call uses cache"
]

{ #category : 'tests' }
ImmutableMemoizedViewTest >> testImmutability [
    | view |
    view := ImmutableMemoizedView on: vec.
    self assert: view isImmutable.
    self should: [view instVarAt: 1 put: 99] raise: ModificationForbidden
]

{ #category : 'tests' }
ImmutableMemoizedViewTest >> testMemoize [
    | lazy result |
    lazy := vec select: [:n | n even].
    result := lazy memoize.
    result do: [:each | ].  "Realize"
    result do: [:each | ].  "Cached"
    self assert: result size equals: 4
]

{ #category : 'tests' }
ImmutableMemoizedViewTest >> testMemoizeRealizesImmediately [

		| evaluations lazy memoized |
      evaluations := 0.

      lazy := (vec drop: 1) collect: [ :each |
                 evaluations := evaluations + 1.
                 each * 10 ].

      self assert: evaluations equals: 0.

      memoized := lazy memoize.

      "memoize traverses and caches immediately."
      self assert: evaluations equals: 9.

      memoized do: [ :each | each yourself ].
      memoized do: [ :each | each yourself ].

      "Cached traversals do not reevaluate the transformation."
      self assert: evaluations equals: 9
]

{ #category : 'tests' }
ImmutableMemoizedViewTest >> testRest [
    | view rest |
    view := ImmutableMemoizedView on: vec.
    rest := view rest.
    self assert: rest first equals: 22.
    self assert: view first equals: 11  "Original still works"
]

{ #category : 'tests' }
ImmutableMemoizedViewTest >> testTake [
    | view result |
    view := ImmutableMemoizedView on: vec.
    result := view take: 3.
    self assert: result size equals: 3.
    self assert: result first equals: 11
]
