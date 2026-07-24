Class {
	#name : 'ImmutableVectorTest',
	#superclass : 'TestCase',
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'tests' }
ImmutableVectorTest >> testAdd [
    | vec |
    vec := ImmutableVector empty.
    vec := vec add: 1.
    self assert: vec size equals: 1.
    self assert: (vec at: 0) equals: 1
]

{ #category : 'tests' }
ImmutableVectorTest >> testAddMultiple [
    | vec |
    vec := ImmutableVector empty.
    vec := vec add: 1.
    vec := vec add: 2.
    vec := vec add: 3.
    self assert: vec size equals: 3.
    self assert: (vec at: 0) equals: 1.
    self assert: (vec at: 1) equals: 2.
    self assert: (vec at: 2) equals: 3
]

{ #category : 'tests' }
ImmutableVectorTest >> testCarCdrCadr [
    | vec |
    vec := ImmutableVector fromArray: #(1 2 3 4 5).
    self assert: vec car equals: 1.
    self assert: vec cadr equals: 2.
    self assert: vec caddr equals: 3.
    self assert: vec cadddr equals: 4
]

{ #category : 'tests' }
ImmutableVectorTest >> testCollect [
    | vec result |
    vec := ImmutableVector fromArray: #(1 2 3).
    result := vec collect: [:n | n * 10].
    self assert: result size equals: 3.
    self assert: (result at: 0) equals: 10.
    self assert: (result at: 1) equals: 20.
    self assert: (result at: 2) equals: 30
]

{ #category : 'tests' }
ImmutableVectorTest >> testCons [
    | vec result |
    vec := ImmutableVector fromArray: #(1 2 3).
    result := vec cons: 0.
    self assert: result size equals: 4.
    self assert: (result at: 0) equals: 0.
    self assert: (result at: 1) equals: 1.
    self assert: (result at: 2) equals: 2.
    self assert: (result at: 3) equals: 3
]

{ #category : 'tests' }
ImmutableVectorTest >> testDo [
    | vec results |
    vec := ImmutableVector fromArray: #(1 2 3).
    results := OrderedCollection new.
    vec do: [:each | results add: each].
    self assert: results asArray equals: #(1 2 3)
]

{ #category : 'tests' }
ImmutableVectorTest >> testDrop [
    | vec result |
    vec := ImmutableVector fromArray: #(1 2 3 4 5).
    result := vec drop: 2.
    self assert: result size equals: 3.
    self assert: (result at: 0) equals: 3.
    self assert: (result at: 1) equals: 4.
    self assert: (result at: 2) equals: 5
]

{ #category : 'tests' }
ImmutableVectorTest >> testEmpty [
    | vec |
    vec := ImmutableVector empty.
    self assert: vec isEmpty.
    self assert: vec size equals: 0.
    self assert: vec first isNil
]

{ #category : 'tests' }
ImmutableVectorTest >> testFirst [
    | vec |
    vec := ImmutableVector fromArray: #(1 2 3).
    self assert: vec first equals: 1
]

{ #category : 'tests' }
ImmutableVectorTest >> testFromArray [
    | vec |
    vec := ImmutableVector fromArray: #(10 20 30 40 50).
    self assert: vec size equals: 5.
    self assert: (vec at: 0) equals: 10.
    self assert: (vec at: 4) equals: 50
]

{ #category : 'tests' }
ImmutableVectorTest >> testImmutability [
    | vec |
    vec := ImmutableVector fromArray: #(1 2 3).
    self assert: vec isImmutable.
    self should: [vec instVarAt: 1 put: 99] raise: ModificationForbidden
]

{ #category : 'tests' }
ImmutableVectorTest >> testInjectInto [
    | vec sum |
    vec := ImmutableVector fromArray: #(1 2 3 4 5).
    sum := vec inject: 0 into: [:a :b | a + b].
    self assert: sum equals: 15
]

{ #category : 'tests' }
ImmutableVectorTest >> testLargeVector [
    | vec |
    vec := ImmutableVector empty.
    1 to: 100 do: [:i | vec := vec add: i].
    self assert: vec size equals: 100.
    self assert: (vec at: 0) equals: 1.
    self assert: (vec at: 49) equals: 50.
    self assert: (vec at: 99) equals: 100
]

{ #category : 'tests' }
ImmutableVectorTest >> testMultipleRootGrowthLevels [

	| vec |
      vec := ImmutableVector empty.

      1 to: 100000 do: [ :i | vec := vec add: i ].

      self assert: vec size equals: 100000.

      #(1 32 33 1024 1025 1056 1057 32768 32800 32801 100000)
         do: [ :i |
            self assert: (vec at: i - 1) equals: i ]
]

{ #category : 'tests' }
ImmutableVectorTest >> testRest [
    | vec rest |
    vec := ImmutableVector fromArray: #(1 2 3).
    rest := vec rest.
    self assert: rest size equals: 2.
    self assert: (rest at: 0) equals: 2.
    self assert: (rest at: 1) equals: 3
]

{ #category : 'accessing' }
ImmutableVectorTest >> testRootGrowthPreservesValues [

	| vec |
      vec := ImmutableVector empty.

      1 to: 1057 do: [ :i | vec := vec add: i ].

      self assert: vec size equals: 1057.

      1 to: 1057 do: [ :i |
         self assert: (vec at: i - 1) equals: i ].
]

{ #category : 'tests' }
ImmutableVectorTest >> testSelect [
    | vec result |
    vec := ImmutableVector fromArray: #(1 2 3 4 5 6).
    result := vec select: [:n | n even].
    self assert: result size equals: 3.
    self assert: (result at: 0) equals: 2.
    self assert: (result at: 1) equals: 4.
    self assert: (result at: 2) equals: 6
]

{ #category : 'tests' }
ImmutableVectorTest >> testStructuralSharing [
    | original modified |
    original := ImmutableVector fromArray: #(1 2 3 4 5).
    modified := original add: 6.
    self assert: original size equals: 5.
    self assert: modified size equals: 6.
    self assert: (original at: 0) equals: 1.
    self assert: (modified at: 0) equals: 1
]

{ #category : 'tests' }
ImmutableVectorTest >> testTailPromotion [
    | vec |
    "Adding 33 elements forces a tail promotion"
    vec := ImmutableVector empty.
    1 to: 33 do: [:i | vec := vec add: i].
    self assert: vec size equals: 33.
    self assert: (vec at: 0) equals: 1.
    self assert: (vec at: 31) equals: 32.
    self assert: (vec at: 32) equals: 33
]

{ #category : 'tests' }
ImmutableVectorTest >> testTake [
    | vec result |
    vec := ImmutableVector fromArray: #(1 2 3 4 5).
    result := vec take: 3.
    self assert: result size equals: 3.
    self assert: (result at: 0) equals: 1.
    self assert: (result at: 1) equals: 2.
    self assert: (result at: 2) equals: 3
]

{ #category : 'tests' }
ImmutableVectorTest >> testTransientBatchOperations [
    | vec result |
    vec := ImmutableVector fromArray: #(1 2 3).
    result := vec addAll: #(4 5 6 7 8 9 10).
    self assert: result size equals: 10.
    self assert: (result at: 0) equals: 1.
    self assert: (result at: 9) equals: 10
]

{ #category : 'tests' }
ImmutableVectorTest >> testTransientPromotesFirstTailCorrectly [
	| transient vec |
      transient := ImmutableVectorTransient from: ImmutableVector empty.

      1 to: 33 do: [ :i |
         transient add: i ].

      vec := transient persistent.

      self assert: vec size equals: 33.

      1 to: 33 do: [ :i |
         self assert: (vec at: i - 1) equals: i ]
]

{ #category : 'tests' }
ImmutableVectorTest >> testTransientSupportsMultipleRootLevels [
	| transient vec |
      transient := ImmutableVectorTransient from: ImmutableVector empty.

      1 to: 100000 do: [ :i |
         transient add: i ].

      vec := transient persistent.

      self assert: vec size equals: 100000.

      #(1 32 33 1024 1025 1056 1057 32768 32800 32801 100000)
         do: [ :i |
            self assert: (vec at: i - 1) equals: i ]
]
