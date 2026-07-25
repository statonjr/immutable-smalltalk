Class {
	#name : 'ImmutableViewBenchmarks',
	#superclass : 'ImmutableBenchmarks',
	#instVars : [
		'vector',
		'validationBlock',
		'lazyView',
		'memoizedView',
		'lastResult'
	],
	#category : 'Immutable-Benchmarks',
	#package : 'Immutable-Benchmarks'
}

{ #category : 'benchmarking' }
ImmutableViewBenchmarks class >> benchmarkMetadata [

	^ {
		  (#EagerVectorRealization -> {
			   self realizationRepetitions.
			   'realizations' }).
		  (#LazyRecomputedTraversal -> {
			   self memoizedTraversalRepetitions.
			   'traversals' }).
		  (#MemoizedCachedTraversal -> {
			   self memoizedTraversalRepetitions.
			   'traversals' }).
		  (#MemoizedViewRealization -> {
			   self realizationRepetitions.
			   'realizations' }).
		  (#EagerChainFirst -> {
			   self firstAccessRepetitions.
			   'pipelines' }).
		  (#EagerChainFullTraversal -> {
			   self fullTraversalRepetitions.
			   'pipelines' }).
		  (#LazyChainFirst -> {
			   self firstAccessRepetitions.
			   'pipelines' }).
		  (#LazyChainFullTraversal -> {
			   self fullTraversalRepetitions.
			   'pipelines' }) } asDictionary
]

{ #category : 'defaults' }
ImmutableViewBenchmarks class >> expectedFirst [

      ^ 1020
]

{ #category : 'defaults' }
ImmutableViewBenchmarks class >> expectedSum [

      ^ 65025000
]

{ #category : 'accessing' }
ImmutableViewBenchmarks class >> firstAccessRepetitions [

      ^ 1000
]

{ #category : 'defaults' }
ImmutableViewBenchmarks class >> fullTraversalRepetitions [

      ^ 2000
]

{ #category : 'defaults' }
ImmutableViewBenchmarks class >> inputSize [

      ^ 10000
]

{ #category : 'benchmarking' }
ImmutableViewBenchmarks class >> isAbstractClass [ 

	^ false
]

{ #category : 'defaults' }
ImmutableViewBenchmarks class >> memoizedFirst [

      ^ 20
]

{ #category : 'defaults' }
ImmutableViewBenchmarks class >> memoizedSize [

      ^ 5000
]

{ #category : 'defaults' }
ImmutableViewBenchmarks class >> memoizedSum [

      ^ 250050000
]

{ #category : 'defaults' }
ImmutableViewBenchmarks class >> memoizedTraversalRepetitions [

	^ 7000
]

{ #category : 'defaults' }
ImmutableViewBenchmarks class >> realizationRepetitions [

      ^ 1000
]

{ #category : 'benchmarking' }
ImmutableViewBenchmarks >> benchEagerChainFirst [

      self class firstAccessRepetitions timesRepeat: [
         lastResult := self newEagerChain first ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableViewBenchmarks >> benchEagerChainFullTraversal [

      self class fullTraversalRepetitions timesRepeat: [
         lastResult := self sumOf: self newEagerChain ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableViewBenchmarks >> benchEagerVectorRealization [

      self class realizationRepetitions timesRepeat: [
         lastResult := lazyView asImmutableVector ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableViewBenchmarks >> benchLazyChainFirst [

      self class firstAccessRepetitions timesRepeat: [
         lastResult := self newLazyChain first ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableViewBenchmarks >> benchLazyChainFullTraversal [

      self class fullTraversalRepetitions timesRepeat: [
         lastResult := self sumOf: self newLazyChain ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableViewBenchmarks >> benchLazyRecomputedTraversal [

      self class memoizedTraversalRepetitions timesRepeat: [
         lastResult := self sumOf: lazyView ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableViewBenchmarks >> benchMemoizedCachedTraversal [

      self class memoizedTraversalRepetitions timesRepeat: [
         lastResult := self sumOf: memoizedView ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableViewBenchmarks >> benchMemoizedViewRealization [

      self class realizationRepetitions timesRepeat: [
         lastResult := lazyView memoize ].

      ^ lastResult
]

{ #category : 'instance creation' }
ImmutableViewBenchmarks >> newEagerChain [

      | result |
      result := (vector drop: 100) asImmutableVector.
      result := (result take: 5000) asImmutableVector.
      result := (result select: [ :number | number even ]).
      result := (result collect: [ :number | number * 10 ]).

      ^ result
]

{ #category : 'instance creation' }
ImmutableViewBenchmarks >> newLazyChain [

      | result |
      result := vector drop: 100.
      result := result take: 5000.
      result := result select: [ :number | number even ].
      result := result collect: [ :number | number * 10 ].

      ^ result
]

{ #category : 'instance creation' }
ImmutableViewBenchmarks >> newMemoizationChain [

      | result |
      result := vector drop: 1.
      result := result select: [ :number | number even ].
      result := result collect: [ :number | number * 10 ].

      ^ result
]

{ #category : 'running' }
ImmutableViewBenchmarks >> prepareVector [

      vector := ImmutableVector
                   fromArray: (1 to: self class inputSize) asArray
]

{ #category : 'benchmarking' }
ImmutableViewBenchmarks >> processResult: result withTimer: timer [

      result ifNil: [
         self error: 'View benchmark returned nil' ].

      (validationBlock value: result) ifFalse: [
         self error: 'View benchmark produced an invalid result' ]
]

{ #category : 'initialization' }
ImmutableViewBenchmarks >> setUpBenchEagerChainFirst [

      self prepareVector.

      self newEagerChain first = self class expectedFirst ifFalse: [
         self error: 'Eager first-access pipeline produced the wrong value' ].

      validationBlock := [ :result |
         result = self class expectedFirst ]
]

{ #category : 'initialization' }
ImmutableViewBenchmarks >> setUpBenchEagerChainFullTraversal [

      self prepareVector.

      (self sumOf: self newEagerChain) = self class expectedSum ifFalse: [
         self error: 'Eager traversal pipeline produced the wrong sum' ].

      validationBlock := [ :result |
         result = self class expectedSum ]
]

{ #category : 'initialization' }
ImmutableViewBenchmarks >> setUpBenchEagerVectorRealization [

      | realized |
      self prepareVector.
      lazyView := self newMemoizationChain.
      realized := lazyView asImmutableVector.

      (realized size = self class memoizedSize and: [
         realized first = self class memoizedFirst ]) ifFalse: [
         self error: 'Eager Vector realization produced invalid output' ].

      validationBlock := [ :result |
         result size = self class memoizedSize and: [
            result first = self class memoizedFirst ] ]
]

{ #category : 'initialization' }
ImmutableViewBenchmarks >> setUpBenchLazyChainFirst [

      self prepareVector.

      self newLazyChain first = self class expectedFirst ifFalse: [
         self error: 'Lazy first-access pipeline produced the wrong value' ].

      validationBlock := [ :result |
         result = self class expectedFirst ]
]

{ #category : 'initialization' }
ImmutableViewBenchmarks >> setUpBenchLazyChainFullTraversal [

      self prepareVector.

      (self sumOf: self newLazyChain) = self class expectedSum ifFalse: [
         self error: 'Lazy traversal pipeline produced the wrong sum' ].

      validationBlock := [ :result |
         result = self class expectedSum ]
]

{ #category : 'initialization' }
ImmutableViewBenchmarks >> setUpBenchLazyRecomputedTraversal [

      self prepareVector.
      lazyView := self newMemoizationChain.

      (self sumOf: lazyView) = self class memoizedSum ifFalse: [
         self error: 'Lazy memoization pipeline produced the wrong sum' ].

      validationBlock := [ :result |
         result = self class memoizedSum ]
]

{ #category : 'initialization' }
ImmutableViewBenchmarks >> setUpBenchMemoizedCachedTraversal [

      self prepareVector.
      lazyView := self newMemoizationChain.
      memoizedView := lazyView memoize.

      (self sumOf: memoizedView) = self class memoizedSum ifFalse: [
         self error: 'Memoized traversal produced the wrong sum' ].

      validationBlock := [ :result |
         result = self class memoizedSum ]
]

{ #category : 'initialization' }
ImmutableViewBenchmarks >> setUpBenchMemoizedViewRealization [

		| realized |
      self prepareVector.
      lazyView := self newMemoizationChain.

      realized := lazyView memoize.

      (realized size = self class memoizedSize and: [
         realized first = self class memoizedFirst ]) ifFalse: [
         self error: 'Memoized realization produced an invalid cache' ].

      validationBlock := [ :result |
         result size = self class memoizedSize and: [
            result first = self class memoizedFirst ] ]
]

{ #category : 'running' }
ImmutableViewBenchmarks >> sumOf: sequence [

      | sum |
      sum := 0.

      sequence do: [ :each |
         sum := sum + each ].

      ^ sum
]
