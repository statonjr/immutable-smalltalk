Class {
	#name : 'ImmutableQueueTest',
	#superclass : 'TestCase',
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'tests' }
ImmutableQueueTest >> testCollect [
    | queue result |
    queue := ImmutableQueue fromArray: #(1 2 3).
    result := queue collect: [:n | n * 10].
    self assert: result size equals: 3.
    result := result asArray.
    self assert: result equals: #(10 20 30)
]

{ #category : 'tests' }
ImmutableQueueTest >> testDequeueRefillsFromIn [
    | queue result |
    queue := ImmutableQueue empty.
    "Enqueue many elements to build up 'in' list"
    1 to: 10 do: [:i | queue := queue enqueue: i].
    "Dequeue all to trigger refill"
    1 to: 10 do: [:i |
        result := queue dequeue.
        self assert: result first equals: i.
        queue := result second].
    self assert: queue isEmpty
]

{ #category : 'tests' }
ImmutableQueueTest >> testDo [
    | queue results |
    queue := ImmutableQueue empty.
    queue := queue enqueue: 1.
    queue := queue enqueue: 2.
    queue := queue enqueue: 3.
    results := OrderedCollection new.
    queue do: [:each | results add: each].
    self assert: results asArray equals: #(1 2 3)
]

{ #category : 'tests' }
ImmutableQueueTest >> testEmpty [
    | queue |
    queue := ImmutableQueue empty.
    self assert: queue isEmpty.
    self assert: queue size equals: 0.
    self assert: queue peek isNil.
    self assert: queue dequeue isNil
]

{ #category : 'tests' }
ImmutableQueueTest >> testEnqueueAndDequeue [
    | queue result |
    queue := ImmutableQueue empty.
    queue := queue enqueue: 1.
    queue := queue enqueue: 2.
    queue := queue enqueue: 3.
    result := queue dequeue.
    self assert: result first equals: 1.
    queue := result second.
    self assert: queue size equals: 2.
    self assert: queue peek equals: 2
]

{ #category : 'tests' }
ImmutableQueueTest >> testEnqueueAndPeek [
    | queue |
    queue := ImmutableQueue empty.
    queue := queue enqueue: 1.
    self assert: queue size equals: 1.
    self assert: queue peek equals: 1.
    self deny: queue isEmpty
]

{ #category : 'tests' }
ImmutableQueueTest >> testFifoOrder [
    | queue result1 result2 result3 |
    queue := ImmutableQueue empty.
    queue := queue enqueue: #first.
    queue := queue enqueue: #second.
    queue := queue enqueue: #third.
    result1 := queue dequeue.
    self assert: result1 first equals: #first.
    queue := result1 second.
    result2 := queue dequeue.
    self assert: result2 first equals: #second.
    queue := result2 second.
    result3 := queue dequeue.
    self assert: result3 first equals: #third.
    queue := result3 second.
    self assert: queue isEmpty
]

{ #category : 'tests' }
ImmutableQueueTest >> testImmutability [
    | queue |
    queue := ImmutableQueue empty enqueue: 1.
    self assert: queue isImmutable.
    self should: [queue instVarAt: 1 put: 99] raise: ModificationForbidden
]

{ #category : 'tests' }
ImmutableQueueTest >> testOriginalUnchangedAfterDequeue [
    | queue1 queue2 result |
    queue1 := ImmutableQueue empty.
    queue1 := queue1 enqueue: 1.
    queue1 := queue1 enqueue: 2.
    result := queue1 dequeue.
    queue2 := result second.
    self assert: queue1 size equals: 2.
    self assert: queue2 size equals: 1.
    self assert: queue1 peek equals: 1.
    self assert: queue2 peek equals: 2
]

{ #category : 'tests' }
ImmutableQueueTest >> testSelect [
    | queue result |
    queue := ImmutableQueue fromArray: #(1 2 3 4 5 6).
    result := queue select: [:n | n even].
    self assert: result size equals: 3.
    result := result asArray.
    self assert: result equals: #(2 4 6)
]
