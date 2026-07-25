Class {
	#name : 'ImmutableConstructionBenchmarks',
	#superclass : 'ImmutableBenchmarks',
	#instVars : [
		'items',
		'lastResult'
	],
	#category : 'Immutable-Benchmarks',
	#package : 'Immutable-Benchmarks'
}

{ #category : 'benchmarking' }
ImmutableConstructionBenchmarks class >> benchmarkMetadata [

      | mapOperations vectorOperations setOperations |
      mapOperations := self mapBuildRepetitions * 1000.
      vectorOperations := self vectorBuildRepetitions * 1000.
      setOperations := self setBuildRepetitions * 1000.

      ^ {
           #DictionaryBuild
              -> { mapOperations. 'inserted elements' }.
           #ImmutableMapBuild
              -> { mapOperations. 'inserted elements' }.

           #ImmutableSetBuild
              -> { setOperations. 'inserted elements' }.
           #SetBuild
              -> { setOperations. 'inserted elements' }.

           #ImmutableVectorBuild
              -> { vectorOperations. 'inserted elements' }.
           #ImmutableVectorTransientBuild
              -> { vectorOperations. 'inserted elements' }.
           #OrderedCollectionBuild
              -> { vectorOperations. 'inserted elements' }
        } asDictionary
]

{ #category : 'benchmarking' }
ImmutableConstructionBenchmarks class >> isAbstractClass [

	^ false
]

{ #category : 'building' }
ImmutableConstructionBenchmarks class >> mapBuildRepetitions [

      ^ 4000
]

{ #category : 'building' }
ImmutableConstructionBenchmarks class >> setBuildRepetitions [

      ^ 4000
]

{ #category : 'building' }
ImmutableConstructionBenchmarks class >> vectorBuildRepetitions [

      ^ 40000
]

{ #category : 'benchmarking' }
ImmutableConstructionBenchmarks >> benchDictionaryBuild [

      self class mapBuildRepetitions timesRepeat: [
         | result |
         result := Dictionary new: items size.

         items do: [ :item |
            result at: item put: item * 2 ].

         lastResult := result ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableConstructionBenchmarks >> benchImmutableMapBuild [

      self class mapBuildRepetitions timesRepeat: [
         | map |
         map := ImmutableMap empty.

         items do: [ :item |
            map := map put: item value: item * 2 ].

         lastResult := map ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableConstructionBenchmarks >> benchImmutableSetBuild [

      self class setBuildRepetitions timesRepeat: [
         | result |
         result := ImmutableSet empty.

         items do: [ :item |
            result := result add: item ].

         lastResult := result ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableConstructionBenchmarks >> benchImmutableVectorBuild [

      self class vectorBuildRepetitions timesRepeat: [
         | result |
         result := ImmutableVector empty.

         items do: [ :item |
            result := result add: item ].

         lastResult := result ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableConstructionBenchmarks >> benchImmutableVectorTransientBuild [

      self class vectorBuildRepetitions timesRepeat: [
         | transient |
         transient := ImmutableVectorTransient from: ImmutableVector empty.

         items do: [ :item |
            transient add: item ].

         lastResult := transient persistent ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableConstructionBenchmarks >> benchOrderedCollectionBuild [

      self class vectorBuildRepetitions timesRepeat: [
         | result |
         result := OrderedCollection new: items size.

         items do: [ :item |
            result add: item ].

         lastResult := result ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableConstructionBenchmarks >> benchSetBuild [

      self class setBuildRepetitions timesRepeat: [
         | result |
         result := Set new: items size.

         items do: [ :item |
            result add: item ].

         lastResult := result ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableConstructionBenchmarks >> processResult: result withTimer: timer [

      result ifNil: [
         self error: 'Construction benchmark returned nil' ].

      result size = items size ifFalse: [
         self error: 'Construction benchmark produced the wrong size' ]
]

{ #category : 'running' }
ImmutableConstructionBenchmarks >> setUp [

      items := (1 to: 1000) asArray
]
