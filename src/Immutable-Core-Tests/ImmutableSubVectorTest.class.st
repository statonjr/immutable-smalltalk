Class {
	#name : 'ImmutableSubVectorTest',
	#superclass : 'TestCase',
	#instVars : [
		'vec'
	],
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'running' }
ImmutableSubVectorTest >> setUp [
	super setUp.

	vec := ImmutableVector fromArray: #(11 22 33 44 55 66 77 88 99 111)
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testAddRealizes [
    | sub result |
    sub := vec take: 3.
    result := sub add: 999.
    self assert: result size equals: 4.
    self assert: (result at: 0) equals: 11.
    self assert: (result at: 3) equals: 999.
    self deny: (result isKindOf: ImmutableSubVector).
    self assert: (result isKindOf: ImmutableVector).
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testAtRejectsIndexesOutsideViewBounds [

		| sub |
      sub := (vec drop: 2) take: 3.

      self assert: (sub at: 0) equals: 33.
      self assert: (sub at: 2) equals: 55.

      "Must not expose the preceding parent element."
      self
         should: [ sub at: -1 ]
         raise: Error.

      "Index equal to the view size is out of bounds."
      self
         should: [ sub at: 3 ]
         raise: Error.

      "Must not expose later parent elements."
      self
         should: [ sub at: 5 ]
         raise: Error
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testCarCdrCadr [
    | result |
    result := vec drop: 4.
    self assert: result car equals: 55.
    self assert: result cadr equals: 66.
    self assert: result caddr equals: 77
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testChainedViews [
    | result |
    result := vec take: 9.
    result := result drop: 2.
    result := result take: 5.
    result := result drop: 1.
    self assert: result size equals: 4.
    result := result asImmutableVector.
    self assert: (result at: 0) equals: 44.
    self assert: (result at: 3) equals: 77
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testCollect [
    | result |
    result := vec take: 3.
    result := result collect: [:n | n * 10].
    self assert: result size equals: 3.
    result := result asImmutableVector.
    self assert: (result at: 0) equals: 110.
    self assert: (result at: 1) equals: 220.
    self assert: (result at: 2) equals: 330
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testConsRealizes [
    | sub result |
    sub := vec drop: 5.
    result := sub cons: 0.
    self assert: result size equals: 6.
    self assert: (result at: 0) equals: 0.
    self assert: (result at: 1) equals: 66.
    self deny: (result isKindOf: ImmutableSubVector).
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testDo [
    | result items |
    result := vec drop: 6.
	 result := result take: 3.
    items := OrderedCollection new.
    result do: [:each | items add: each].
    self assert: items asArray equals: #(77 88 99)
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testDrop [
    | result |
    result := vec drop: 7.
    self assert: result size equals: 3.
    self assert: (result at: 0) equals: 88.
    self assert: (result at: 1) equals: 99.
    self assert: (result at: 2) equals: 111
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testDropAll [
    | result |
    result := vec drop: 10.
    self assert: result isEmpty
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testDropMore [
    | result |
    result := vec drop: 100.
    self assert: result isEmpty
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testDropThenTake [
    | result |
    result := vec drop: 3.
	 result := result take: 4.
    self assert: result size equals: 4.
	 result := result asImmutableVector.
    self assert: (result at: 0) equals: 44.
    self assert: (result at: 3) equals: 77.
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testDropZero [
    | result |
    result := vec drop: 0.
    self assert: result equals: vec
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testFirst [
    | result |
    result := vec drop: 5.
    self assert: result first equals: 66
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testImmutability [
    | sub |
    sub := vec take: 5.
    self assert: sub isImmutable.
    self should: [sub instVarAt: 1 put: 99] raise: ModificationForbidden
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testLargeFilteredViewTakeRealization [
		| source view realized |
      source := ImmutableVector fromArray: (1 to: 100) asArray.
      view := (source drop: 1) select: [ :each | each even ].

      realized := view take: 40.

      self assert: realized size equals: 40.
      self assert: (realized isKindOf: ImmutableVector).

      1 to: 40 do: [ :i |
         self assert: (realized at: i - 1) equals: i * 2 ]
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testLargeSubVectorRealization [
		| source subVector realized |
      source := ImmutableVector fromArray: (1 to: 100) asArray.
      subVector := (source drop: 10) take: 70.

      realized := subVector asImmutableVector.

      self assert: realized size equals: 70.
      self assert: (realized isKindOf: ImmutableVector).

      1 to: 70 do: [ :i |
         self assert: (realized at: i - 1) equals: i + 10 ]
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testOriginalUnchanged [
    | sub |
    sub := vec drop: 3; take: 2.
    self assert: vec size equals: 10.
    self assert: (vec at: 0) equals: 11.
    self assert: (vec at: 9) equals: 111
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testRest [
    | result rest |
    result := vec drop: 5.
    rest := result rest.
    self assert: rest size equals: 4.
    self assert: rest first equals: 77
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testSelect [
    | result |
    result := vec drop: 1.
    result := result take: 6.
    result := result select: [:n | n even].
    self assert: result size equals: 3.
    result := result asImmutableVector.
    self assert: (result at: 0) equals: 22.
    self assert: (result at: 1) equals: 44.
    self assert: (result at: 2) equals: 66
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testTake [
    | result |
    result := vec take: 3.
    self assert: result size equals: 3.
    self assert: (result at: 0) equals: 11.
    self assert: (result at: 1) equals: 22.
    self assert: (result at: 2) equals: 33
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testTakeAll [
    | result |
    result := vec take: 10.
    self assert: result equals: vec
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testTakeMore [
    | result |
    result := vec take: 100.
    self assert: result equals: vec
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testTakeThenDrop [
    | result |
    result := vec take: 8.
	 result := result drop: 3.
    self assert: result size equals: 5.
	 result := result asImmutableVector.
    self assert: (result at: 0) equals: 44.
    self assert: (result at: 4) equals: 88
]

{ #category : 'tests' }
ImmutableSubVectorTest >> testTakeZero [
    | result |
    result := vec take: 0.
    self assert: result isEmpty
]
