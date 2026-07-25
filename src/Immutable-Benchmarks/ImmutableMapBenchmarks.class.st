Class {
	#name : 'ImmutableMapBenchmarks',
	#superclass : 'ImmutableBenchmarks',
	#instVars : [
		'immutableMap',
		'dictionary',
		'keys',
		'lastResult'
	],
	#category : 'Immutable-Benchmarks',
	#package : 'Immutable-Benchmarks'
}

{ #category : 'benchmarking' }
ImmutableMapBenchmarks class >> benchmarkMetadata [

      ^ {
           #DictionaryLookupLarge
              -> { 4000000. 'lookups' }.
           #DictionaryLookupSmall
              -> { 3000000. 'lookups' }.
           #ImmutableMapLookupLarge
              -> { 4000000. 'lookups' }.
           #ImmutableMapLookupSmall
              -> { 3000000. 'lookups' }
        } asDictionary
]

{ #category : 'benchmarking' }
ImmutableMapBenchmarks class >> isAbstractClass [

	^ false
]

{ #category : 'benchmarking' }
ImmutableMapBenchmarks >> benchDictionaryLookupLarge [

      4000 timesRepeat: [
         keys do: [ :key |
            lastResult := dictionary at: key ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableMapBenchmarks >> benchDictionaryLookupSmall [

      30000 timesRepeat: [
         keys do: [ :key |
            lastResult := dictionary at: key ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableMapBenchmarks >> benchImmutableMapLookupLarge [

      4000 timesRepeat: [
         keys do: [ :key |
            lastResult := immutableMap at: key ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableMapBenchmarks >> benchImmutableMapLookupSmall [

      30000 timesRepeat: [
         keys do: [ :key |
            lastResult := immutableMap at: key ] ].

      ^ lastResult
]

{ #category : 'initialization' }
ImmutableMapBenchmarks >> setUpBenchDictionaryLookupLarge [

      dictionary := Dictionary new.

      1 to: 100000 do: [ :i |
         dictionary at: i put: i * 2 ].

      keys := ((1 to: 1000) collect: [ :i |
                  (i * 97) % 100000 + 1 ]) asArray.

      (keys allSatisfy: [ :key |
         (dictionary at: key) = (key * 2) ]) ifFalse: [
         self error: 'Invalid large Dictionary benchmark fixture' ]
]

{ #category : 'initialization' }
ImmutableMapBenchmarks >> setUpBenchDictionaryLookupSmall [

      dictionary := Dictionary new.

      1 to: 100 do: [ :i |
         dictionary at: i put: i * 2 ].

      keys := (1 to: 100) asArray.

      (keys allSatisfy: [ :key |
         (dictionary at: key) = (key * 2) ]) ifFalse: [
         self error: 'Invalid small Dictionary benchmark fixture' ]
]

{ #category : 'initialization' }
ImmutableMapBenchmarks >> setUpBenchImmutableMapLookupLarge [

      immutableMap := ImmutableMap empty.

      1 to: 100000 do: [ :i |
         immutableMap := immutableMap put: i value: i * 2 ].

      keys := ((1 to: 1000) collect: [ :i |
                  (i * 97) % 100000 + 1 ]) asArray.

      (keys allSatisfy: [ :key |
         (immutableMap at: key) = (key * 2) ]) ifFalse: [
         self error: 'Invalid large ImmutableMap benchmark fixture' ]
]

{ #category : 'initialization' }
ImmutableMapBenchmarks >> setUpBenchImmutableMapLookupSmall [

	immutableMap := ImmutableMap empty.

      1 to: 100 do: [ :i |
         immutableMap := immutableMap put: i value: i * 2 ].

      keys := (1 to: 100) asArray.

      (keys allSatisfy: [ :key |
         (immutableMap at: key) = (key * 2) ]) ifFalse: [
         self error: 'Invalid small ImmutableMap benchmark fixture' ]
]
