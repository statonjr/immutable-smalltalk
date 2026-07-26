Class {
	#name : 'ImmutableQueueBenchmarks',
	#superclass : 'ImmutableBenchmarks',
	#instVars : [
		'baseQueue',
		'readyQueue',
		'orderedCollection',
		'readyOrderedCollection',
		'validationBlock',
		'lastResult'
	],
	#category : 'Immutable-Benchmarks',
	#package : 'Immutable-Benchmarks'
}

{ #category : 'defaults' }
ImmutableQueueBenchmarks class >> baseSize [

	^ 1000
]

{ #category : 'benchmarking' }
ImmutableQueueBenchmarks class >> benchmarkMetadata [

	^ {
		  (#ImmutableQueueEnqueueBatch -> {
			   (self enqueueRepetitions * self enqueueBatchSize).
			   'enqueues' }).
		  (#OrderedCollectionEnqueueBatch -> {
			   (self enqueueRepetitions * self enqueueBatchSize).
			   'enqueues' }).

		  (#ImmutableQueueDequeueAll -> {
			   (self dequeueRepetitions * self baseSize).
			   'dequeues' }).
		  (#OrderedCollectionDequeueAll -> {
			   (self dequeueRepetitions * self baseSize).
			   'dequeues' }).

		  (#ImmutableQueueMixed -> {
			   (self mixedRepetitions * 100).
			   'queue operations' }).
		  (#OrderedCollectionMixed -> {
			   (self mixedRepetitions * 100).
			   'queue operations' }).

		  (#ImmutableQueuePeekAfterEnqueues -> {
			   self peekRepetitions.
			   'peeks' }).
		  (#OrderedCollectionPeekAfterEnqueues -> {
			   self peekRepetitions.
			   'peeks' }).
		  (#ImmutableQueuePeekAfterDequeue -> {
			   self peekRepetitions.
			   'peeks' }).
		  (#OrderedCollectionPeekAfterDequeue -> {
			   self peekRepetitions.
			   'peeks' }) } asDictionary
]

{ #category : 'defaults' }
ImmutableQueueBenchmarks class >> dequeueRepetitions [

	^ 10000
]

{ #category : 'defaults' }
ImmutableQueueBenchmarks class >> enqueueBatchSize [

      ^ 100
]

{ #category : 'defaults' }
ImmutableQueueBenchmarks class >> enqueueRepetitions [

	^ 600000
]

{ #category : 'benchmarking' }
ImmutableQueueBenchmarks class >> isAbstractClass [ 

	^ false
]

{ #category : 'defaults' }
ImmutableQueueBenchmarks class >> mixedRepetitions [

	^ 250000
]

{ #category : 'defaults' }
ImmutableQueueBenchmarks class >> peekRepetitions [

	^ 60000000
]

{ #category : 'benchmarking' }
ImmutableQueueBenchmarks >> benchImmutableQueueDequeueAll [

      self class dequeueRepetitions timesRepeat: [
         lastResult := self dequeueImmutableBase ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableQueueBenchmarks >> benchImmutableQueueEnqueueBatch [

      self class enqueueRepetitions timesRepeat: [
         lastResult := self newImmutableEnqueueBatch ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableQueueBenchmarks >> benchImmutableQueueMixed [

      self class mixedRepetitions timesRepeat: [
         lastResult := self newImmutableMixedQueue ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableQueueBenchmarks >> benchImmutableQueuePeekAfterDequeue [

	self class peekRepetitions timesRepeat: [ lastResult := readyQueue peek ].

	^ lastResult
]

{ #category : 'benchmarking' }
ImmutableQueueBenchmarks >> benchImmutableQueuePeekAfterEnqueues [

	self class peekRepetitions timesRepeat: [ lastResult := baseQueue peek ].

	^ lastResult
]

{ #category : 'benchmarking' }
ImmutableQueueBenchmarks >> benchOrderedCollectionDequeueAll [

      self class dequeueRepetitions timesRepeat: [
         lastResult := self dequeueOrderedCollectionBase ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableQueueBenchmarks >> benchOrderedCollectionEnqueueBatch [

      self class enqueueRepetitions timesRepeat: [
         lastResult := self newOrderedCollectionEnqueueBatch ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableQueueBenchmarks >> benchOrderedCollectionMixed [

      self class mixedRepetitions timesRepeat: [
         lastResult := self newOrderedCollectionMixedQueue ].

      ^ lastResult
]

{ #category : 'benchmarking' }
ImmutableQueueBenchmarks >> benchOrderedCollectionPeekAfterDequeue [

	self class peekRepetitions timesRepeat: [ lastResult := readyOrderedCollection first ].

	^ lastResult
]

{ #category : 'benchmarking' }
ImmutableQueueBenchmarks >> benchOrderedCollectionPeekAfterEnqueues [

	self class peekRepetitions timesRepeat: [ lastResult := orderedCollection first ].

	^ lastResult
]

{ #category : 'private' }
ImmutableQueueBenchmarks >> dequeueImmutableBase [

      | current dequeued last |
      current := baseQueue.

      self class baseSize timesRepeat: [
         dequeued := current dequeue.
         last := dequeued first.
         current := dequeued second ].

      ^ { last. current }
]

{ #category : 'private' }
ImmutableQueueBenchmarks >> dequeueOrderedCollectionBase [

      | current last |
      current := orderedCollection copy.

      self class baseSize timesRepeat: [
         last := current removeFirst ].

      ^ { last. current }
]

{ #category : 'instance creation' }
ImmutableQueueBenchmarks >> newImmutableEnqueueBatch [

      | result |
      result := ImmutableQueue empty.

      1 to: self class enqueueBatchSize do: [ :i |
         result := result enqueue: i ].

      ^ result
]

{ #category : 'private' }
ImmutableQueueBenchmarks >> newImmutableMixedQueue [

      | result dequeued |
      result := ImmutableQueue empty.

      1 to: 50 do: [ :i |
         result := result enqueue: i ].

      1 to: 25 do: [ :i |
         dequeued := result dequeue.
         result := dequeued second ].

      1 to: 25 do: [ :i |
         result := result enqueue: i ].

      ^ result
]

{ #category : 'private' }
ImmutableQueueBenchmarks >> newOrderedCollectionEnqueueBatch [

      | result |
      result := OrderedCollection new: self class enqueueBatchSize.

      1 to: self class enqueueBatchSize do: [ :i |
         result addLast: i ].

      ^ result
]

{ #category : 'private' }
ImmutableQueueBenchmarks >> newOrderedCollectionMixedQueue [

      | result |
      result := OrderedCollection new: 50.

      1 to: 50 do: [ :i |
         result addLast: i ].

      25 timesRepeat: [
         result removeFirst ].

      1 to: 25 do: [ :i |
         result addLast: i ].

      ^ result
]

{ #category : 'benchmarking' }
ImmutableQueueBenchmarks >> processResult: result withTimer: timer [

      validationBlock ifNil: [
         self error:
            'Benchmark-specific setup did not install a validation block' ].

      result ifNil: [
         self error: 'Queue benchmark returned nil' ].

      (validationBlock value: result) ifFalse: [
         self error: 'Queue benchmark produced an invalid result' ]
]

{ #category : 'running' }
ImmutableQueueBenchmarks >> setUp [

      | dequeued |
      baseQueue := ImmutableQueue
                      fromArray: (1 to: self class baseSize) asArray.

      orderedCollection :=
         (1 to: self class baseSize) asOrderedCollection.

      dequeued := baseQueue dequeue.
      readyQueue := dequeued second.

      readyOrderedCollection := orderedCollection copy.
      readyOrderedCollection removeFirst
]

{ #category : 'initialization' }
ImmutableQueueBenchmarks >> setUpBenchImmutableQueueDequeueAll [

      self validateDequeueResult: self dequeueImmutableBase
]

{ #category : 'initialization' }
ImmutableQueueBenchmarks >> setUpBenchImmutableQueueEnqueueBatch [

      self
         validateSequence: self newImmutableEnqueueBatch
         expected: (1 to: self class enqueueBatchSize) asArray
]

{ #category : 'initialization' }
ImmutableQueueBenchmarks >> setUpBenchImmutableQueueMixed [

      self
         validateSequence: self newImmutableMixedQueue
         expected:
            (26 to: 50) asArray , (1 to: 25) asArray
]

{ #category : 'initialization' }
ImmutableQueueBenchmarks >> setUpBenchImmutableQueuePeekAfterDequeue [

      readyQueue peek = 2 ifFalse: [
         self error: 'Rotated Queue peek produced the wrong value' ].

      validationBlock := [ :result | result = 2 ]
]

{ #category : 'initialization' }
ImmutableQueueBenchmarks >> setUpBenchImmutableQueuePeekAfterEnqueues [

      baseQueue peek = 1 ifFalse: [
         self error: 'Unrotated Queue peek produced the wrong value' ].

      validationBlock := [ :result | result = 1 ]
]

{ #category : 'initialization' }
ImmutableQueueBenchmarks >> setUpBenchOrderedCollectionDequeueAll [

      self validateDequeueResult: self dequeueOrderedCollectionBase
]

{ #category : 'initialization' }
ImmutableQueueBenchmarks >> setUpBenchOrderedCollectionEnqueueBatch [

      self
         validateSequence: self newOrderedCollectionEnqueueBatch
         expected: (1 to: self class enqueueBatchSize) asArray
]

{ #category : 'initialization' }
ImmutableQueueBenchmarks >> setUpBenchOrderedCollectionMixed [

      self
         validateSequence: self newOrderedCollectionMixedQueue
         expected:
            (26 to: 50) asArray , (1 to: 25) asArray
]

{ #category : 'initialization' }
ImmutableQueueBenchmarks >> setUpBenchOrderedCollectionPeekAfterDequeue [

      readyOrderedCollection first = 2 ifFalse: [
         self error: 'Ready OrderedCollection first produced the wrong value' ].

      validationBlock := [ :result | result = 2 ]
]

{ #category : 'initialization' }
ImmutableQueueBenchmarks >> setUpBenchOrderedCollectionPeekAfterEnqueues [

      orderedCollection first = 1 ifFalse: [
         self error: 'OrderedCollection first produced the wrong value' ].

      validationBlock := [ :result | result = 1 ]
]

{ #category : 'private' }
ImmutableQueueBenchmarks >> validateDequeueResult: result [

      (result first = self class baseSize and: [
         result second isEmpty ]) ifFalse: [
         self error: 'Queue dequeue benchmark produced an invalid result' ].

      validationBlock := [ :timedResult |
         timedResult first = self class baseSize and: [
            timedResult second isEmpty ] ]
]

{ #category : 'private' }
ImmutableQueueBenchmarks >> validateSequence: result expected: expected [

      result asArray = expected ifFalse: [
         self error: 'Queue operation produced an invalid sequence' ].

      validationBlock := [ :timedResult |
         timedResult asArray = expected ]
]
