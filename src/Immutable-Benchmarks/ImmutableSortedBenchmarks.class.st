Class {
	#name : 'ImmutableSortedBenchmarks',
	#superclass : 'ImmutableBenchmarks',
	#instVars : [
		'sortedMap',
		'dictionary',
		'sortedSet',
		'mutableSet',
		'buildKeys',
		'buildAssociations',
		'expectedKeys',
		'lookupItems',
		'validationBlock',
		'lastResult'
	],
	#category : 'Immutable-Benchmarks',
	#package : 'Immutable-Benchmarks'
}

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks class >> benchmarkMetadata [

	| lookupOperations buildOperations |
	lookupOperations := self lookupRepetitions * self lookupBatchSize.

	buildOperations := self buildRepetitions * self collectionSize.

	^ {
		  (#DictionarySortedKeys -> {
			   self orderedConversionRepetitions.
			   'conversions' }).
		  (#DictionarySortedKeysAndValues -> {
			   self orderedTraversalRepetitions.
			   'traversals' }).
		  (#ImmutableSortedMapKeys -> {
			   self orderedConversionRepetitions.
			   'conversions' }).
		  (#ImmutableSortedMapKeysAndValues -> {
			   self orderedTraversalRepetitions.
			   'traversals' }).
		  (#ImmutableSortedSetAsArray -> {
			   self orderedConversionRepetitions.
			   'conversions' }).
		  (#ImmutableSortedSetFirstLast -> {
			   self extremaRepetitions.
			   'extrema queries' }).
		  (#SetMinMax -> {
			   self extremaRepetitions.
			   'extrema queries' }).
		  (#SetSortedArray -> {
			   self orderedConversionRepetitions.
			   'conversions' }).
		  (#DictionaryLookup -> {
			   lookupOperations.
			   'lookups' }).
		  (#ImmutableSortedMapLookup -> {
			   lookupOperations.
			   'lookups' }).
		  (#ImmutableSortedSetLookup -> {
			   lookupOperations.
			   'lookups' }).
		  (#SetLookup -> {
			   lookupOperations.
			   'lookups' }).
		  (#SortedMapBulkBuild -> {
			   buildOperations.
			   'inserted elements' }).
		  (#SortedMapIncrementalBuild -> {
			   buildOperations.
			   'inserted elements' }).
		  (#SortedSetBulkBuild -> {
			   buildOperations.
			   'inserted elements' }).
		  (#SortedSetIncrementalBuild -> {
			   buildOperations.
			   'inserted elements' }) } asDictionary
]

{ #category : 'defaults' }
ImmutableSortedBenchmarks class >> buildRepetitions [

	^ 1500
]

{ #category : 'defaults' }
ImmutableSortedBenchmarks class >> collectionSize [

      ^ 500
]

{ #category : 'defaults' }
ImmutableSortedBenchmarks class >> extremaRepetitions [

	^ 40000
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks class >> isAbstractClass [ 
	
	^ false
]

{ #category : 'defaults' }
ImmutableSortedBenchmarks class >> lookupBatchSize [

      ^ 100
]

{ #category : 'defaults' }
ImmutableSortedBenchmarks class >> lookupRepetitions [

      ^ 60000
]

{ #category : 'defaults' }
ImmutableSortedBenchmarks class >> orderedConversionRepetitions [

	^ 60000
]

{ #category : 'defaults' }
ImmutableSortedBenchmarks class >> orderedTraversalRepetitions [

      ^ 10000
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks >> benchDictionaryLookup [

      self class lookupRepetitions timesRepeat: [
         lookupItems do: [ :key |
            lastResult := dictionary at: key ] ].

      ^ lastResult
]

{ #category : 'accessing' }
ImmutableSortedBenchmarks >> benchDictionarySortedKeys [

      self class orderedConversionRepetitions timesRepeat: [
         lastResult := dictionary keys sorted ].

      ^ lastResult
]

{ #category : 'accessing' }
ImmutableSortedBenchmarks >> benchDictionarySortedKeysAndValues [

      self class orderedTraversalRepetitions timesRepeat: [
         lastResult := self dictionarySortedTraversalSum ].

      ^ lastResult
]

{ #category : 'accessing' }
ImmutableSortedBenchmarks >> benchImmutableSortedMapKeys [

      self class orderedConversionRepetitions timesRepeat: [
         lastResult := sortedMap keys ].

      ^ lastResult
]

{ #category : 'accessing' }
ImmutableSortedBenchmarks >> benchImmutableSortedMapKeysAndValues [

      self class orderedTraversalRepetitions timesRepeat: [
         lastResult := self sortedMapTraversalSum ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks >> benchImmutableSortedMapLookup [

      self class lookupRepetitions timesRepeat: [
         lookupItems do: [ :key |
            lastResult := sortedMap at: key ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks >> benchImmutableSortedSetAsArray [

      self class orderedConversionRepetitions timesRepeat: [
         lastResult := sortedSet asArray ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks >> benchImmutableSortedSetFirstLast [

      self class extremaRepetitions timesRepeat: [
         lastResult := { sortedSet first. sortedSet last } ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks >> benchImmutableSortedSetLookup [

      self class lookupRepetitions timesRepeat: [
         lookupItems do: [ :key |
            lastResult := sortedSet includes: key ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks >> benchSetLookup [

      self class lookupRepetitions timesRepeat: [
         lookupItems do: [ :key |
            lastResult := mutableSet includes: key ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks >> benchSetMinMax [

      self class extremaRepetitions timesRepeat: [
         lastResult := self mutableSetMinMax ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks >> benchSetSortedArray [

      self class orderedConversionRepetitions timesRepeat: [
         lastResult := mutableSet asArray sort ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks >> benchSortedMapBulkBuild [

      self class buildRepetitions timesRepeat: [
         lastResult := self newBulkSortedMap ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks >> benchSortedMapIncrementalBuild [

      self class buildRepetitions timesRepeat: [
         lastResult := self newIncrementalSortedMap ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks >> benchSortedSetBulkBuild [

      self class buildRepetitions timesRepeat: [
         lastResult := self newBulkSortedSet ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks >> benchSortedSetIncrementalBuild [

      self class buildRepetitions timesRepeat: [
         lastResult := self newIncrementalSortedSet ].

      ^ lastResult
]

{ #category : 'as yet unclassified' }
ImmutableSortedBenchmarks >> dictionarySortedTraversalSum [

      | sum |
      sum := 0.

      dictionary keys sorted do: [ :key |
         sum := sum + key + (dictionary at: key) ].

      ^ sum
]

{ #category : 'as yet unclassified' }
ImmutableSortedBenchmarks >> expectedTraversalSum [

      ^ expectedKeys inject: 0 into: [ :sum :key |
         sum + key + (key * 2) ]
]

{ #category : 'as yet unclassified' }
ImmutableSortedBenchmarks >> mutableSetMinMax [

      | minimum maximum |
      minimum := nil.
      maximum := nil.

      mutableSet do: [ :each |
         (minimum isNil or: [ each < minimum ]) ifTrue: [
            minimum := each ].

         (maximum isNil or: [ each > maximum ]) ifTrue: [
            maximum := each ] ].

      ^ { minimum. maximum }
]

{ #category : 'instance creation' }
ImmutableSortedBenchmarks >> newBulkSortedMap [

      ^ ImmutableSortedMap fromArray: buildAssociations
]

{ #category : 'instance creation' }
ImmutableSortedBenchmarks >> newBulkSortedSet [

      ^ ImmutableSortedSet fromArray: buildKeys
]

{ #category : 'instance creation' }
ImmutableSortedBenchmarks >> newIncrementalSortedMap [

      | result |
      result := ImmutableSortedMap empty.

      buildAssociations do: [ :association |
         result := result
                      put: association key
                      value: association value ].

      ^ result
]

{ #category : 'instance creation' }
ImmutableSortedBenchmarks >> newIncrementalSortedSet [

      | result |
      result := ImmutableSortedSet empty.

      buildKeys do: [ :key |
         result := result add: key ].

      ^ result
]

{ #category : 'benchmarking' }
ImmutableSortedBenchmarks >> processResult: result withTimer: timer [

      validationBlock ifNil: [
         self error:
            'Benchmark-specific setup did not install a validation block' ].

      result ifNil: [
         self error: 'Sorted collection benchmark returned nil' ].

      (validationBlock value: result) ifFalse: [
         self error: 'Sorted collection benchmark produced an invalid result' ]
]

{ #category : 'running' }
ImmutableSortedBenchmarks >> setUp [

      buildKeys := ((1 to: self class collectionSize) collect: [ :i |
                       (i * 97) % 503 ]) asArray.

      buildAssociations := buildKeys collect: [ :key |
         key -> (key * 2) ].

      expectedKeys := buildKeys sorted.

      sortedMap :=
         ImmutableSortedMap fromArray: buildAssociations.

      dictionary := Dictionary new: self class collectionSize.
      buildAssociations do: [ :association |
         dictionary
            at: association key
            put: association value ].

      sortedSet := ImmutableSortedSet fromArray: buildKeys.
      mutableSet := buildKeys asSet.

      lookupItems :=
         expectedKeys
            copyFrom: 1
            to: self class lookupBatchSize
]

{ #category : 'initialization' }
ImmutableSortedBenchmarks >> setUpBenchDictionaryLookup [

      (lookupItems allSatisfy: [ :key |
         (dictionary at: key) = (key * 2) ]) ifFalse: [
         self error: 'Dictionary lookup fixture is invalid' ].

      validationBlock := [ :result |
         result = (lookupItems last * 2) ]
]

{ #category : 'accessing' }
ImmutableSortedBenchmarks >> setUpBenchDictionarySortedKeys [

      dictionary keys sorted = expectedKeys ifFalse: [
         self error: 'Dictionary sorted-key fixture is invalid' ].

      validationBlock := [ :result |
         result = expectedKeys ]
]

{ #category : 'accessing' }
ImmutableSortedBenchmarks >> setUpBenchDictionarySortedKeysAndValues [

      self dictionarySortedTraversalSum = self expectedTraversalSum ifFalse: [
         self error: 'Dictionary ordered traversal sum is invalid' ].

      validationBlock := [ :result |
         result = self expectedTraversalSum ]
]

{ #category : 'accessing' }
ImmutableSortedBenchmarks >> setUpBenchImmutableSortedMapKeys [

      sortedMap keys = expectedKeys ifFalse: [
         self error: 'SortedMap keys are not ordered correctly' ].

      validationBlock := [ :result |
         result = expectedKeys ]
]

{ #category : 'accessing' }
ImmutableSortedBenchmarks >> setUpBenchImmutableSortedMapKeysAndValues [

      | visitedKeys |
      visitedKeys := OrderedCollection new.

      sortedMap keysAndValuesDo: [ :key :value |
         visitedKeys add: key ].

      visitedKeys asArray = expectedKeys ifFalse: [
         self error: 'SortedMap traversal order is invalid' ].

      self sortedMapTraversalSum = self expectedTraversalSum ifFalse: [
         self error: 'SortedMap traversal sum is invalid' ].

      validationBlock := [ :result |
         result = self expectedTraversalSum ]
]

{ #category : 'initialization' }
ImmutableSortedBenchmarks >> setUpBenchImmutableSortedMapLookup [

      (lookupItems allSatisfy: [ :key |
         (sortedMap at: key) = (key * 2) ]) ifFalse: [
         self error: 'ImmutableSortedMap lookup fixture is invalid' ].

      validationBlock := [ :result |
         result = (lookupItems last * 2) ]
]

{ #category : 'initialization' }
ImmutableSortedBenchmarks >> setUpBenchImmutableSortedSetAsArray [

      sortedSet asArray = expectedKeys ifFalse: [
         self error: 'SortedSet array order is invalid' ].

      validationBlock := [ :result |
         result = expectedKeys ]
]

{ #category : 'initialization' }
ImmutableSortedBenchmarks >> setUpBenchImmutableSortedSetFirstLast [

      | expected |
      expected := { expectedKeys first. expectedKeys last }.

      { sortedSet first. sortedSet last } = expected ifFalse: [
         self error: 'SortedSet extrema are invalid' ].

      validationBlock := [ :result |
         result = expected ]
]

{ #category : 'initialization' }
ImmutableSortedBenchmarks >> setUpBenchImmutableSortedSetLookup [

      (lookupItems allSatisfy: [ :key |
         sortedSet includes: key ]) ifFalse: [
         self error: 'ImmutableSortedSet lookup fixture is invalid' ].

      validationBlock := [ :result | result ]
]

{ #category : 'initialization' }
ImmutableSortedBenchmarks >> setUpBenchSetLookup [

      (lookupItems allSatisfy: [ :key |
         mutableSet includes: key ]) ifFalse: [
         self error: 'Set lookup fixture is invalid' ].

      validationBlock := [ :result | result ]
]

{ #category : 'initialization' }
ImmutableSortedBenchmarks >> setUpBenchSetMinMax [

      | expected |
      expected := { expectedKeys first. expectedKeys last }.

      self mutableSetMinMax = expected ifFalse: [
         self error: 'Set extrema fixture is invalid' ].

      validationBlock := [ :result |
         result = expected ]
]

{ #category : 'initialization' }
ImmutableSortedBenchmarks >> setUpBenchSetSortedArray [

      mutableSet asArray sort = expectedKeys ifFalse: [
         self error: 'Set sorted-array fixture is invalid' ].

      validationBlock := [ :result |
         result = expectedKeys ]
]

{ #category : 'initialization' }
ImmutableSortedBenchmarks >> setUpBenchSortedMapBulkBuild [

      (self sortedMapIsValid: self newBulkSortedMap) ifFalse: [
         self error: 'Bulk SortedMap build is invalid' ].

      validationBlock := [ :result |
         self sortedMapIsValid: result ]
]

{ #category : 'initialization' }
ImmutableSortedBenchmarks >> setUpBenchSortedMapIncrementalBuild [

      (self sortedMapIsValid: self newIncrementalSortedMap) ifFalse: [
         self error: 'Incremental SortedMap build is invalid' ].

      validationBlock := [ :result |
         self sortedMapIsValid: result ]
]

{ #category : 'initialization' }
ImmutableSortedBenchmarks >> setUpBenchSortedSetBulkBuild [

      (self sortedSetIsValid: self newBulkSortedSet) ifFalse: [
         self error: 'Bulk SortedSet build is invalid' ].

      validationBlock := [ :result |
         self sortedSetIsValid: result ]
]

{ #category : 'initialization' }
ImmutableSortedBenchmarks >> setUpBenchSortedSetIncrementalBuild [

      (self sortedSetIsValid: self newIncrementalSortedSet) ifFalse: [
         self error: 'Incremental SortedSet build is invalid' ].

      validationBlock := [ :result |
         self sortedSetIsValid: result ]
]

{ #category : 'private' }
ImmutableSortedBenchmarks >> sortedMapIsValid: result [

      ^ result size = self class collectionSize and: [
         result keys = expectedKeys and: [
            expectedKeys allSatisfy: [ :key |
               (result at: key) = (key * 2) ] ] ]
]

{ #category : 'as yet unclassified' }
ImmutableSortedBenchmarks >> sortedMapTraversalSum [

      | sum |
      sum := 0.

      sortedMap keysAndValuesDo: [ :key :value |
         sum := sum + key + value ].

      ^ sum
]

{ #category : 'private' }
ImmutableSortedBenchmarks >> sortedSetIsValid: result [

      ^ result size = self class collectionSize and: [
         result asArray = expectedKeys ]
]
