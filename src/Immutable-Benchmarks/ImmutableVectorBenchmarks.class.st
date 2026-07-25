Class {
	#name : 'ImmutableVectorBenchmarks',
	#superclass : 'ImmutableBenchmarks',
	#instVars : [
		'vector',
		'array',
		'indexes',
		'lastResult'
	],
	#category : 'Immutable-Benchmarks',
	#package : 'Immutable-Benchmarks'
}

{ #category : 'benchmarking' }
ImmutableVectorBenchmarks class >> benchmarkMetadata [

      | smallOperations largeOperations |
      smallOperations := self smallLookupRepetitions * 100.
      largeOperations := self largeLookupRepetitions * 1000.

      ^ {
           #ArrayLookupLarge
              -> { largeOperations. 'lookups' }.
           #ArrayLookupSmall
              -> { smallOperations. 'lookups' }.
           #ImmutableVectorLookupLarge
              -> { largeOperations. 'lookups' }.
           #ImmutableVectorLookupSmall
              -> { smallOperations. 'lookups' }
        } asDictionary
]

{ #category : 'benchmarking' }
ImmutableVectorBenchmarks class >> isAbstractClass [

	^ false
]

{ #category : 'as yet unclassified' }
ImmutableVectorBenchmarks class >> largeLookupRepetitions [

      ^ 50000
]

{ #category : 'as yet unclassified' }
ImmutableVectorBenchmarks class >> smallLookupRepetitions [

      ^ 500000
]

{ #category : 'benchmarking' }
ImmutableVectorBenchmarks >> benchArrayLookupLarge [

      self class largeLookupRepetitions timesRepeat: [
         indexes do: [ :index |
            lastResult := array at: index + 1 ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableVectorBenchmarks >> benchArrayLookupSmall [

      self class smallLookupRepetitions timesRepeat: [
         indexes do: [ :index |
            lastResult := array at: index + 1 ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableVectorBenchmarks >> benchImmutableVectorLookupLarge [

      self class largeLookupRepetitions timesRepeat: [
         indexes do: [ :index |
            lastResult := vector at: index ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableVectorBenchmarks >> benchImmutableVectorLookupSmall [

      self class smallLookupRepetitions timesRepeat: [
         indexes do: [ :index |
            lastResult := vector at: index ] ].

      ^ lastResult
]

{ #category : 'initialization' }
ImmutableVectorBenchmarks >> setUpBenchArrayLookupLarge [

      array := (1 to: 100000) asArray.

      indexes := ((1 to: 1000) collect: [ :i |
                  (i * 97) % 100000 ]) asArray.

      (indexes allSatisfy: [ :index |
         (array at: index + 1) = (index + 1) ]) ifFalse: [
         self error: 'Invalid large Array fixture' ]
]

{ #category : 'initialization' }
ImmutableVectorBenchmarks >> setUpBenchArrayLookupSmall [

      array := (1 to: 100) asArray.
      indexes := (0 to: 99) asArray.

      (indexes allSatisfy: [ :index |
         (array at: index + 1) = (index + 1) ]) ifFalse: [
         self error: 'Invalid small Array fixture' ]
]

{ #category : 'initialization' }
ImmutableVectorBenchmarks >> setUpBenchImmutableVectorLookupLarge [

      vector := ImmutableVector fromArray: (1 to: 100000) asArray.

      indexes := ((1 to: 1000) collect: [ :i |
                  (i * 97) % 100000 ]) asArray.

      (indexes allSatisfy: [ :index |
         (vector at: index) = (index + 1) ]) ifFalse: [
         self error: 'Invalid large ImmutableVector fixture' ]
]

{ #category : 'initialization' }
ImmutableVectorBenchmarks >> setUpBenchImmutableVectorLookupSmall [

      vector := ImmutableVector fromArray: (1 to: 100) asArray.
      indexes := (0 to: 99) asArray.

      (indexes allSatisfy: [ :index |
         (vector at: index) = (index + 1) ]) ifFalse: [
         self error: 'Invalid small ImmutableVector fixture' ]
]
