Class {
	#name : 'ImmutableSetBenchmarks',
	#superclass : 'ImmutableBenchmarks',
	#instVars : [
		'immutableSet',
		'mutableSet',
		'immutableOther',
		'mutableOther',
		'hitItems',
		'missItems',
		'expectedResult',
		'validationBlock',
		'lastResult'
	],
	#category : 'Immutable-Benchmarks',
	#package : 'Immutable-Benchmarks'
}

{ #category : 'as yet unclassified' }
ImmutableSetBenchmarks class >> algebraRepetitions [

	^ 5000
]

{ #category : 'benchmarking' }
ImmutableSetBenchmarks class >> benchmarkMetadata [

      | lookupOperations |
      lookupOperations :=
         self lookupRepetitions * self lookupBatchSize.

      ^ {
           #ImmutableSetIncludesHits
              -> { lookupOperations. 'lookups' }.
           #ImmutableSetIncludesMisses
              -> { lookupOperations. 'lookups' }.
           #SetIncludesHits
              -> { lookupOperations. 'lookups' }.
           #SetIncludesMisses
              -> { lookupOperations. 'lookups' }.

           #ImmutableSetDifference
              -> { self algebraRepetitions. 'operations' }.
           #ImmutableSetIntersection
              -> { self algebraRepetitions. 'operations' }.
           #ImmutableSetUnion
              -> { self algebraRepetitions. 'operations' }.
           #SetDifference
              -> { self algebraRepetitions. 'operations' }.
           #SetIntersection
              -> { self algebraRepetitions. 'operations' }.
           #SetUnion
              -> { self algebraRepetitions. 'operations' }
        } asDictionary
]

{ #category : 'benchmarking' }
ImmutableSetBenchmarks class >> isAbstractClass [

	^ false
]

{ #category : 'as yet unclassified' }
ImmutableSetBenchmarks class >> lookupBatchSize [

      ^ 100
]

{ #category : 'as yet unclassified' }
ImmutableSetBenchmarks class >> lookupRepetitions [

      ^ 500000
]

{ #category : 'initialization' }
ImmutableSetBenchmarks class >> setSize [

      ^ 500
]

{ #category : 'benchmarking' }
ImmutableSetBenchmarks >> benchImmutableSetDifference [

      self class algebraRepetitions timesRepeat: [
         lastResult := immutableSet difference: immutableOther ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSetBenchmarks >> benchImmutableSetIncludesHits [

      self class lookupRepetitions timesRepeat: [
         hitItems do: [ :item |
            lastResult := immutableSet includes: item ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSetBenchmarks >> benchImmutableSetIncludesMisses [

      self class lookupRepetitions timesRepeat: [
         missItems do: [ :item |
            lastResult := immutableSet includes: item ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSetBenchmarks >> benchImmutableSetIntersection [

      self class algebraRepetitions timesRepeat: [
         lastResult := immutableSet intersection: immutableOther ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSetBenchmarks >> benchImmutableSetUnion [

      self class algebraRepetitions timesRepeat: [
         lastResult := immutableSet union: immutableOther ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSetBenchmarks >> benchSetDifference [

      self class algebraRepetitions timesRepeat: [
         lastResult := mutableSet difference: mutableOther ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSetBenchmarks >> benchSetIncludesHits [

      self class lookupRepetitions timesRepeat: [
         hitItems do: [ :item |
            lastResult := mutableSet includes: item ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSetBenchmarks >> benchSetIncludesMisses [

      self class lookupRepetitions timesRepeat: [
         missItems do: [ :item |
            lastResult := mutableSet includes: item ] ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSetBenchmarks >> benchSetIntersection [

      self class algebraRepetitions timesRepeat: [
         lastResult := mutableSet intersection: mutableOther ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSetBenchmarks >> benchSetUnion [

      self class algebraRepetitions timesRepeat: [
         lastResult := mutableSet union: mutableOther ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableSetBenchmarks >> processResult: result withTimer: timer [

      validationBlock ifNil: [
         self error:
            'Benchmark-specific setup did not install a validation block' ].

      result ifNil: [
         self error: 'Set benchmark returned nil' ].

      (validationBlock value: result) ifFalse: [
         self error: 'Set benchmark produced an invalid result' ]
]

{ #category : 'running' }
ImmutableSetBenchmarks >> setUp [

      | primaryElements otherElements |
      primaryElements := (1 to: self class setSize) asArray.
      otherElements := (400 to: 900) asArray.

      immutableSet := ImmutableSet fromArray: primaryElements.
      mutableSet := primaryElements asSet.

      immutableOther := ImmutableSet fromArray: otherElements.
      mutableOther := otherElements asSet.

      hitItems :=
         (1 to: self class lookupBatchSize) asArray.

      missItems :=
         (self class setSize + 1
            to: self class setSize + self class lookupBatchSize)
               asArray
]

{ #category : 'initialization' }
ImmutableSetBenchmarks >> setUpBenchImmutableSetDifference [

      self
         validateSetResult:
            (immutableSet difference: immutableOther)
         expected:
            (1 to: 399) asSet
]

{ #category : 'initialization' }
ImmutableSetBenchmarks >> setUpBenchImmutableSetIncludesHits [

      (hitItems allSatisfy: [ :item |
         immutableSet includes: item ]) ifFalse: [
         self error: 'ImmutableSet hit fixture is invalid' ].

      validationBlock := [ :result | result = true ]
]

{ #category : 'initialization' }
ImmutableSetBenchmarks >> setUpBenchImmutableSetIncludesMisses [

      (missItems noneSatisfy: [ :item |
         immutableSet includes: item ]) ifFalse: [
         self error: 'ImmutableSet miss fixture is invalid' ].

      validationBlock := [ :result | result = false ]
]

{ #category : 'initialization' }
ImmutableSetBenchmarks >> setUpBenchImmutableSetIntersection [

      self
         validateSetResult:
            (immutableSet intersection: immutableOther)
         expected:
            (400 to: 500) asSet
]

{ #category : 'initialization' }
ImmutableSetBenchmarks >> setUpBenchImmutableSetUnion [

      self
         validateSetResult:
            (immutableSet union: immutableOther)
         expected:
            (1 to: 900) asSet
]

{ #category : 'initialization' }
ImmutableSetBenchmarks >> setUpBenchSetDifference [

      self
         validateSetResult:
            (mutableSet difference: mutableOther)
         expected:
            (1 to: 399) asSet
]

{ #category : 'initialization' }
ImmutableSetBenchmarks >> setUpBenchSetIncludesHits [

	(hitItems allSatisfy: [ :item | mutableSet includes: item ]) ifFalse: [ self error: 'Set hit fixture is invalid' ].

	validationBlock := [ :result | result ]
]

{ #category : 'initialization' }
ImmutableSetBenchmarks >> setUpBenchSetIncludesMisses [

	(missItems noneSatisfy: [ :item | mutableSet includes: item ]) ifFalse: [ self error: 'Set miss fixture is invalid' ].

	validationBlock := [ :result | result not ]
]

{ #category : 'initialization' }
ImmutableSetBenchmarks >> setUpBenchSetIntersection [

      self
         validateSetResult:
            (mutableSet intersection: mutableOther)
         expected:
            (400 to: 500) asSet
]

{ #category : 'initialization' }
ImmutableSetBenchmarks >> setUpBenchSetUnion [

      self
         validateSetResult:
            (mutableSet union: mutableOther)
         expected:
            (1 to: 900) asSet
]

{ #category : 'private' }
ImmutableSetBenchmarks >> validateSetResult: result expected: expected [

      (result size = expected size and: [
         expected allSatisfy: [ :item |
            result includes: item ] ]) ifFalse: [
         self error: 'Set algebra produced an invalid result' ].

      expectedResult := expected.

      validationBlock := [ :timedResult |
         timedResult size = expectedResult size and: [
            expectedResult allSatisfy: [ :item |
               timedResult includes: item ] ] ]
]
