Class {
	#name : 'ImmutableSequenceBenchmarks',
	#superclass : 'ImmutableBenchmarks',
	#instVars : [
		'immutableList',
		'immutableVector',
		'array',
		'expectedResult',
		'validationBlock',
		'lastResult'
	],
	#category : 'Immutable-Benchmarks',
	#package : 'Immutable-Benchmarks'
}

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks class >> benchmarkMetadata [

	^ {
		  (#ArrayReverse -> {
			   self reverseRepetitions.
			   'reversals' }).
		  (#ImmutableListCdrChain -> {
			   self cdrTraversalRepetitions.
			   'traversals' }).
		  (#ImmutableListReverse -> {
			   self reverseRepetitions.
			   'reversals' }).
		  (#ImmutableListTenPrepends -> {
			   (self prependRepetitions * 10).
			   'prepends' }).
		  (#OrderedCollectionCopyAndTenPrepends -> {
			   (self prependRepetitions * 10).
			   'prepends' }).
		  (#ArrayDropHalf -> {
			   self sliceRepetitions.
			   'operations' }).
		  (#ArrayTakeHalf -> {
			   self sliceRepetitions.
			   'operations' }).
		  (#ImmutableListDropHalf -> {
			   self sliceRepetitions.
			   'operations' }).
		  (#ImmutableListTakeHalf -> {
			   self sliceRepetitions.
			   'operations' }).
		  (#ImmutableVectorDropHalf -> {
			   self sliceRepetitions.
			   'operations' }).
		  (#ImmutableVectorTakeHalf -> {
			   self sliceRepetitions.
			   'operations' }) } asDictionary
]

{ #category : 'defaults' }
ImmutableSequenceBenchmarks class >> cdrTraversalRepetitions [

	^ 7000000
]

{ #category : 'defaults' }
ImmutableSequenceBenchmarks class >> inputSize [

      ^ 100
]

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks class >> isAbstractClass [

	^ false
]

{ #category : 'defaults' }
ImmutableSequenceBenchmarks class >> prependRepetitions [

	^ 2000000
]

{ #category : 'defaults' }
ImmutableSequenceBenchmarks class >> reverseRepetitions [

	^ 700000
]

{ #category : 'defaults' }
ImmutableSequenceBenchmarks class >> sliceRepetitions [

      ^ 2000000
]

{ #category : 'defaults' }
ImmutableSequenceBenchmarks class >> sliceSize [

      ^ 50
]

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks >> benchArrayDropHalf [

      self class sliceRepetitions timesRepeat: [
         lastResult := array
                          copyFrom: self class sliceSize + 1
                          to: self class inputSize ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks >> benchArrayReverse [

      self class reverseRepetitions timesRepeat: [
         lastResult := array reverse ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks >> benchArrayTakeHalf [

      self class sliceRepetitions timesRepeat: [
         lastResult := array
                          copyFrom: 1
                          to: self class sliceSize ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks >> benchImmutableListCdrChain [

      self class cdrTraversalRepetitions timesRepeat: [
         | result |
         result := immutableList.

         10 timesRepeat: [
            result := result cdr ].

         lastResult := result car ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks >> benchImmutableListDropHalf [

      self class sliceRepetitions timesRepeat: [
         lastResult := immutableList drop: self class sliceSize ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks >> benchImmutableListReverse [

      self class reverseRepetitions timesRepeat: [
         lastResult := immutableList reverse ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks >> benchImmutableListTakeHalf [

      self class sliceRepetitions timesRepeat: [
         lastResult := immutableList take: self class sliceSize ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks >> benchImmutableListTenPrepends [

      self class prependRepetitions timesRepeat: [
         | result |
         result := immutableList.

         1 to: 10 do: [ :i |
            result := result cons: i ].

         lastResult := result ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks >> benchImmutableVectorDropHalf [

      self class sliceRepetitions timesRepeat: [
         lastResult := immutableVector drop: self class sliceSize ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks >> benchImmutableVectorTakeHalf [

      self class sliceRepetitions timesRepeat: [
         lastResult := immutableVector take: self class sliceSize ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks >> benchOrderedCollectionCopyAndTenPrepends [

      self class prependRepetitions timesRepeat: [
         | result |
         result := array asOrderedCollection.

         1 to: 10 do: [ :i |
            result addFirst: i ].

         lastResult := result ].

      ^ lastResult
]

{ #category : 'running' }
ImmutableSequenceBenchmarks >> prepareSequences [

      array := (1 to: self class inputSize) asArray.
      immutableList := ImmutableList fromArray: array.
      immutableVector := ImmutableVector fromArray: array
]

{ #category : 'benchmarking' }
ImmutableSequenceBenchmarks >> processResult: result withTimer: timer [

      result ifNil: [
         self error: 'Sequence benchmark returned nil' ].

      (validationBlock value: result) ifFalse: [
         self error: 'Sequence benchmark produced an invalid result' ]
]

{ #category : 'running' }
ImmutableSequenceBenchmarks >> setUp [

      self prepareSequences
]

{ #category : 'initialization' }
ImmutableSequenceBenchmarks >> setUpBenchArrayDropHalf [

	self
		validateBeforeTiming: (array copyFrom: self class sliceSize + 1 to: self class inputSize)
		expected: (self class sliceSize + 1 to: self class inputSize) asArray
]

{ #category : 'initialization' }
ImmutableSequenceBenchmarks >> setUpBenchArrayReverse [

      self
         validateBeforeTiming: array reverse
         expected: array reverse
]

{ #category : 'initialization' }
ImmutableSequenceBenchmarks >> setUpBenchArrayTakeHalf [

	self validateBeforeTiming: (array copyFrom: 1 to: self class sliceSize) expected: (1 to: self class sliceSize) asArray
]

{ #category : 'initialization' }
ImmutableSequenceBenchmarks >> setUpBenchImmutableListCdrChain [

      | result |
      result := immutableList.

      10 timesRepeat: [
         result := result cdr ].

      result car = 11 ifFalse: [
         self error: 'List cdr-chain produced the wrong value' ].

      validationBlock := [ :timedResult |
         timedResult = 11 ]
]

{ #category : 'initialization' }
ImmutableSequenceBenchmarks >> setUpBenchImmutableListDropHalf [

      self
         validateBeforeTiming:
            (immutableList drop: self class sliceSize)
         expected:
            (self class sliceSize + 1 to: self class inputSize) asArray
]

{ #category : 'initialization' }
ImmutableSequenceBenchmarks >> setUpBenchImmutableListReverse [

      self
         validateBeforeTiming: immutableList reverse
         expected: array reverse
]

{ #category : 'initialization' }
ImmutableSequenceBenchmarks >> setUpBenchImmutableListTakeHalf [

	self validateBeforeTiming: (immutableList take: self class sliceSize) expected: (1 to: self class sliceSize) asArray
]

{ #category : 'initialization' }
ImmutableSequenceBenchmarks >> setUpBenchImmutableListTenPrepends [

      | result expected |
      result := immutableList.

      1 to: 10 do: [ :i |
         result := result cons: i ].

      expected := array asOrderedCollection.
      1 to: 10 do: [ :i |
         expected addFirst: i ].

      self
         validateBeforeTiming: result
         expected: expected asArray
]

{ #category : 'initialization' }
ImmutableSequenceBenchmarks >> setUpBenchImmutableVectorDropHalf [

	self
		validateBeforeTiming: (immutableVector drop: self class sliceSize)
		expected: (self class sliceSize + 1 to: self class inputSize) asArray
]

{ #category : 'initialization' }
ImmutableSequenceBenchmarks >> setUpBenchImmutableVectorTakeHalf [

	self validateBeforeTiming: (immutableVector take: self class sliceSize) expected: (1 to: self class sliceSize) asArray
]

{ #category : 'initialization' }
ImmutableSequenceBenchmarks >> setUpBenchOrderedCollectionCopyAndTenPrepends [

      | result expected |
      result := array asOrderedCollection.

      1 to: 10 do: [ :i |
         result addFirst: i ].

      expected := array asOrderedCollection.
      1 to: 10 do: [ :i |
         expected addFirst: i ].

      self
         validateBeforeTiming: result
         expected: expected asArray
]

{ #category : 'private' }
ImmutableSequenceBenchmarks >> validateBeforeTiming: result expected: expected [

      result asArray = expected ifFalse: [
         self error: 'Sequence operation produced an invalid result' ].

      expectedResult := expected.

      validationBlock := [ :timedResult |
         timedResult asArray = expectedResult ]
]
