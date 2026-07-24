Class {
	#name : 'ImmutableEqualityTest',
	#superclass : 'TestCase',
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'tests' }
ImmutableEqualityTest >> testEqualImmutableCollectionsWorkAsDictionaryKeys [

		| dictionary vector list map sortedMap set sortedSet |
      dictionary := Dictionary new.

      vector := ImmutableVector fromArray: #(1 2 3).
      list := ImmutableList fromArray: #(1 2 3).

      map := ImmutableMap fromAssociations: {
                #a -> 1.
                #b -> 2 }.

      sortedMap := ImmutableSortedMap fromArray: {
                      #b -> 2.
                      #a -> 1 }.

      set := ImmutableSet fromArray: #(3 1 2).
      sortedSet := ImmutableSortedSet fromArray: #(2 3 1).

      dictionary at: vector put: #sequence.
      dictionary at: map put: #map.
      dictionary at: set put: #set.

      self assert: (dictionary at: list) equals: #sequence.
      self assert: (dictionary at: sortedMap) equals: #map.
      self assert: (dictionary at: sortedSet) equals: #set
]

{ #category : 'tests' }
ImmutableEqualityTest >> testImmutableSequenceDoesNotEqualBuiltInSequence [

	| vector array |
	vector := ImmutableVector fromArray: #( 1 2 3 ).
	array := #( 1 2 3 ).
	self deny: vector equals: array.
	self deny: array equals: vector
]

{ #category : 'tests' }
ImmutableEqualityTest >> testMapEqualityIgnoresInsertionAndTraversalOrder [

	| map sortedMap |
	map := ImmutableMap empty.
	map := map put: #b value: 2.
	map := map put: #a value: nil.
	map := map put: #c value: 3.

	sortedMap := ImmutableSortedMap fromArray: {
			             (#c -> 3).
			             (#a -> nil).
			             (#b -> 2) }.
	self assert: map equals: sortedMap.
	self assert: sortedMap equals: map.
	self assert: map hash equals: sortedMap hash
]

{ #category : 'tests' }
ImmutableEqualityTest >> testMapsWithDifferentMappingsAreNotEqual [

	| first second |
	first := ImmutableMap fromAssociations: {
			         (#a -> 1).
			         (#b -> 2) }.

	second := ImmutableMap fromAssociations: {
			          (#a -> 1).
			          (#b -> 99) }.
	self deny: first equals: second
]

{ #category : 'tests' }
ImmutableEqualityTest >> testQueueEqualityIsOrderedAndQueueSpecific [

	| first second reversed vector |
	first := ImmutableQueue fromArray: #( 1 2 3 ).
	second := ImmutableQueue fromArray: #( 1 2 3 ).
	reversed := ImmutableQueue fromArray: #( 3 2 1 ).
	vector := ImmutableVector fromArray: #( 1 2 3 ).
	self assert: first equals: second.
	self assert: first hash equals: second hash.
	self deny: first equals: reversed.
	self deny: first equals: vector.
	self deny: vector equals: first
]

{ #category : 'tests' }
ImmutableEqualityTest >> testSequenceEqualityAcrossImplementations [

	| list vector source subVector mapped filtered memoized sequences |
	list := ImmutableList fromArray: { 1. nil. 3 }.
	vector := ImmutableVector fromArray: { 1. nil. 3 }.

	source := ImmutableVector fromArray: { 0. 1. nil. 3. 4 }.
	subVector := (source drop: 1) take: 3.
	mapped := subVector collect: [ :each | each ].
	filtered := subVector select: [ :each | true ].
	memoized := filtered memoize.

	sequences := {
		             list.
		             vector.
		             subVector.
		             mapped.
		             filtered.
		             memoized }.

	sequences do: [ :left |
			sequences do: [ :right |
					self assert: left equals: right.
					self assert: right equals: left.
					self assert: left hash equals: right hash ] ]
]

{ #category : 'tests' }
ImmutableEqualityTest >> testSequenceEqualityIsOrderSensitive [

	| forward reversed different |
	forward := ImmutableVector fromArray: #( 1 2 3 ).
	reversed := ImmutableList fromArray: #( 3 2 1 ).
	different := ImmutableList fromArray: #( 1 2 4 ).
	self deny: forward equals: reversed.
	self deny: forward equals: different
]

{ #category : 'tests' }
ImmutableEqualityTest >> testSetEqualityIgnoresOrderAndConcreteType [

	| set sortedSet |
	set := ImmutableSet fromArray: { 3. 1. 2 }.
	sortedSet := ImmutableSortedSet fromArray: { 2. 3. 1. }.
	self assert: set equals: sortedSet.
	self assert: sortedSet equals: set.
	self assert: (set hash) equals: (sortedSet hash).
]

{ #category : 'tests' }
ImmutableEqualityTest >> testSetEqualitySupportsNil [

	| first second |
	first := ImmutableSet fromArray: { 3. nil. 1 }.
	second := ImmutableSet fromArray: { nil. 1. 3 }.
	self assert: first equals: second.
	self assert: second equals: first.
	self assert: first hash equals: second hash
]
