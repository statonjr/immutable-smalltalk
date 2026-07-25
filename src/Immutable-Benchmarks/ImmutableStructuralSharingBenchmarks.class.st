Class {
	#name : 'ImmutableStructuralSharingBenchmarks',
	#superclass : 'ImmutableBenchmarks',
	#instVars : [
		'immutableList',
		'immutableMap',
		'queue',
		'orderedCollection',
		'vector',
		'dictionary',
		'array',
		'immutableSet',
		'mutableSet',
		'validationBlock',
		'lastResult'
	],
	#category : 'Immutable-Benchmarks',
	#package : 'Immutable-Benchmarks'
}

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks class >> benchmarkMetadata [

	| listBranches mapBranches queueBranches |
	listBranches := self listBranchRepetitions * 10.
	mapBranches := self mapBranchRepetitions * 10.
	queueBranches := self queueBranchRepetitions * 10.

	^ {
		  (#ArrayTenPrependCopies -> {
			   listBranches.
			   'versions' }).
		  (#ImmutableListTenBranches -> {
			   listBranches.
			   'versions' }).
		  (#ArrayCopyAndAppend -> {
			   self vectorAppendRepetitions.
			   'versions' }).
		  (#DictionaryCopyAndUpdate -> {
			   self mapUpdateRepetitions.
			   'versions' }).
		  (#DictionaryTenCopies -> {
			   mapBranches.
			   'versions' }).
		  (#ImmutableMapSingleUpdate -> {
			   self mapUpdateRepetitions.
			   'versions' }).
		  (#ImmutableMapTenBranches -> {
			   mapBranches.
			   'versions' }).
		  (#ImmutableVectorSingleAppend -> {
			   self vectorAppendRepetitions.
			   'versions' }).
		  (#ImmutableSetSingleAdd -> {
			   self setUpdateRepetitions.
			   'versions' }).
			#ImmutableQueueTenBranches
      			-> { queueBranches. 'versions' }.
			#OrderedCollectionTenCopies
      			-> { queueBranches. 'versions' }.
		  (#SetCopyAndAdd -> {
			   self setUpdateRepetitions.
			   'versions' }) } asDictionary
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks class >> isAbstractClass [

	^ false.
]

{ #category : 'defaults' }
ImmutableStructuralSharingBenchmarks class >> listBranchRepetitions [

	^ 1500000
]

{ #category : 'defaults' }
ImmutableStructuralSharingBenchmarks class >> listSize [

      ^ 100
]

{ #category : 'defaults' }
ImmutableStructuralSharingBenchmarks class >> mapBranchRepetitions [

      ^ 100000
]

{ #category : 'defaults' }
ImmutableStructuralSharingBenchmarks class >> mapSize [

      ^ 100
]

{ #category : 'defaults' }
ImmutableStructuralSharingBenchmarks class >> mapUpdateKey [

      ^ self mapSize // 2
]

{ #category : 'defaults' }
ImmutableStructuralSharingBenchmarks class >> mapUpdateRepetitions [

      ^ 1000000
]

{ #category : 'as yet unclassified' }
ImmutableStructuralSharingBenchmarks class >> queueBranchRepetitions [

      ^ 1000000
]

{ #category : 'as yet unclassified' }
ImmutableStructuralSharingBenchmarks class >> queueSize [

      ^ 100
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks class >> setSize [

      ^ 500
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks class >> setUpdateRepetitions [

      ^ 1000000
]

{ #category : 'defaults' }
ImmutableStructuralSharingBenchmarks class >> vectorAppendRepetitions [

      ^ 12000000
]

{ #category : 'defaults' }
ImmutableStructuralSharingBenchmarks class >> vectorSize [

      ^ 100
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks >> benchArrayCopyAndAppend [

      self class vectorAppendRepetitions timesRepeat: [
         lastResult := array copyWith: #appended ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks >> benchArrayTenPrependCopies [

      self class listBranchRepetitions timesRepeat: [
         lastResult := (1 to: 10) collect: [ :i |
            { i } , array ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks >> benchDictionaryCopyAndUpdate [

      self class mapUpdateRepetitions timesRepeat: [
         | copy |
         copy := dictionary copy.
         copy at: self class mapUpdateKey put: #changed.
         lastResult := copy ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks >> benchDictionaryTenCopies [

      self class mapBranchRepetitions timesRepeat: [
         lastResult := (1 to: 10) collect: [ :i |
            | copy |
            copy := dictionary copy.
            copy at: self class mapUpdateKey put: i.
            copy ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks >> benchImmutableListTenBranches [

      self class listBranchRepetitions timesRepeat: [
         lastResult := (1 to: 10) collect: [ :i |
            immutableList cons: i ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks >> benchImmutableMapSingleUpdate [

      self class mapUpdateRepetitions timesRepeat: [
         lastResult := immutableMap
                          put: (self class mapUpdateKey)
                          value: #changed ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks >> benchImmutableMapTenBranches [

      self class mapBranchRepetitions timesRepeat: [
         lastResult := (1 to: 10) collect: [ :i |
            immutableMap put: (self class mapUpdateKey) value: i ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks >> benchImmutableQueueTenBranches [

      self class queueBranchRepetitions timesRepeat: [
         lastResult := (1 to: 10) collect: [ :i |
            queue enqueue: i ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks >> benchImmutableSetSingleAdd [

      self class setUpdateRepetitions timesRepeat: [
         lastResult := immutableSet add: #appended ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks >> benchImmutableVectorSingleAppend [

      self class vectorAppendRepetitions timesRepeat: [
         lastResult := vector add: #appended ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks >> benchOrderedCollectionTenCopies [

      self class queueBranchRepetitions timesRepeat: [
         lastResult := (1 to: 10) collect: [ :i |
            | copy |
            copy := orderedCollection copy.
            copy addLast: i.
            copy ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks >> benchSetCopyAndAdd [

      self class setUpdateRepetitions timesRepeat: [
         | copy |
         copy := mutableSet copy.
         copy add: #appended.
         lastResult := copy ].

      ^ lastResult
]

{ #category : 'preparation' }
ImmutableStructuralSharingBenchmarks >> prepareListFixture [

      array := (1 to: self class listSize) asArray.
      immutableList := ImmutableList fromArray: array
]

{ #category : 'preparation' }
ImmutableStructuralSharingBenchmarks >> prepareMapFixture [

      immutableMap := ImmutableMap empty.
      dictionary := Dictionary new: self class mapSize.

      1 to: self class mapSize do: [ :i |
         immutableMap := immutableMap put: i value: i.
         dictionary at: i put: i ]
]

{ #category : 'preparation' }
ImmutableStructuralSharingBenchmarks >> prepareQueueFixture [

      queue := ImmutableQueue empty.

      1 to: self class queueSize do: [ :i |
         queue := queue enqueue: i ].

      orderedCollection :=
         (1 to: self class queueSize) asOrderedCollection
]

{ #category : 'preparation' }
ImmutableStructuralSharingBenchmarks >> prepareSetFixture [

      | elements |
      elements := (1 to: self class setSize) asArray.

      immutableSet := ImmutableSet fromArray: elements.
      mutableSet := elements asSet
]

{ #category : 'preparation' }
ImmutableStructuralSharingBenchmarks >> prepareVectorFixture [

      array := (1 to: self class vectorSize) asArray.
      vector := ImmutableVector fromArray: array
]

{ #category : 'benchmarking' }
ImmutableStructuralSharingBenchmarks >> processResult: result withTimer: timer [

      result ifNil: [
         self error: 'Structural-sharing benchmark returned nil' ].

      (validationBlock value: result) ifFalse: [
         self error: 'Structural-sharing benchmark produced an invalid version' ]
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks >> setUpBenchArrayCopyAndAppend [

      	self prepareVectorFixture.

      	validationBlock := [ :result |
      		result size = (self class vectorSize + 1) and: [
         		(result at: self class vectorSize + 1) = #appended and: [
            		array size = self class vectorSize ] ] ]
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks >> setUpBenchArrayTenPrependCopies [

      self prepareListFixture.

      validationBlock := [ :branches |
         branches size = 10 and: [
            (1 to: 10) allSatisfy: [ :i |
               | branch |
               branch := branches at: i.

               branch size = (self class listSize + 1) and: [
                  branch first = i and: [
                     array first = 1 ] ] ] ] ]
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks >> setUpBenchDictionaryCopyAndUpdate [

      self prepareMapFixture.

      validationBlock := [ :result |
         result size = self class mapSize and: [
            (result at: self class mapUpdateKey) = #changed and: [
               (dictionary at: self class mapUpdateKey) = self class mapUpdateKey ] ] ]
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks >> setUpBenchDictionaryTenCopies [

      self prepareMapFixture.

      validationBlock := [ :copies |
         copies size = 10 and: [
            (1 to: 10) allSatisfy: [ :i |
               ((copies at: i) at: self class mapUpdateKey) = i ] ] ]
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks >> setUpBenchImmutableListTenBranches [

      self prepareListFixture.

      validationBlock := [ :branches |
         branches size = 10 and: [
            (1 to: 10) allSatisfy: [ :i |
               | branch |
               branch := branches at: i.

               branch size = (self class listSize + 1) and: [
                  branch first = i and: [
                     immutableList first = 1 ] ] ] ] ]
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks >> setUpBenchImmutableMapSingleUpdate [

      self prepareMapFixture.

      validationBlock := [ :result |
         result size = self class mapSize and: [
            (result at: self class mapUpdateKey) = #changed and: [
               (immutableMap at: self class mapUpdateKey) = self class mapUpdateKey ] ] ]
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks >> setUpBenchImmutableMapTenBranches [

      self prepareMapFixture.

      validationBlock := [ :branches |
         branches size = 10 and: [
            (1 to: 10) allSatisfy: [ :i |
               ((branches at: i) at: self class mapUpdateKey) = i ] ] ]
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks >> setUpBenchImmutableQueueTenBranches [

      self prepareQueueFixture.

      validationBlock := [ :branches |
         branches size = 10 and: [
            (1 to: 10) allSatisfy: [ :i |
               | branch |
               branch := branches at: i.

               branch size = (self class queueSize + 1) and: [
                  (branch asArray at: self class queueSize + 1) = i and: [
                     queue size = self class queueSize and: [
                        queue peek = 1 ] ] ] ] ] ]
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks >> setUpBenchImmutableSetSingleAdd [

      self prepareSetFixture.

      validationBlock := [ :result |
         result size = (self class setSize + 1) and: [
            (result includes: #appended) and: [
               (immutableSet includes: #appended) not ] ] ]
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks >> setUpBenchImmutableVectorSingleAppend [

      self prepareVectorFixture.

      validationBlock := [ :result |
      		result size = (self class vectorSize + 1) and: [
         		(result at: self class vectorSize) = #appended and: [
            		vector size = self class vectorSize ] ] ]
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks >> setUpBenchOrderedCollectionTenCopies [

      self prepareQueueFixture.

      validationBlock := [ :copies |
         copies size = 10 and: [
            (1 to: 10) allSatisfy: [ :i |
               | copy |
               copy := copies at: i.

               copy size = (self class queueSize + 1) and: [
                  copy last = i and: [
                     orderedCollection size = self class queueSize and: [
                        orderedCollection first = 1 ] ] ] ] ] ]
]

{ #category : 'initialization' }
ImmutableStructuralSharingBenchmarks >> setUpBenchSetCopyAndAdd [

      self prepareSetFixture.

      validationBlock := [ :result |
         result size = (self class setSize + 1) and: [
            (result includes: #appended) and: [
               (mutableSet includes: #appended) not ] ] ]
]
