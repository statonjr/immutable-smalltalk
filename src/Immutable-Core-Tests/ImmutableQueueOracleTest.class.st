Class {
	#name : 'ImmutableQueueOracleTest',
	#superclass : 'TestCase',
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'asserting' }
ImmutableQueueOracleTest >> assertQueue: queue equalsOrderedCollection: oracle context: context [

	| actual |
      actual := OrderedCollection new.
      queue do: [ :each |
         actual add: each ].

      self
         assert: queue size = oracle size
         description: [
            context,
               ' — size mismatch: queue=',
               queue size printString,
               ', oracle=',
               oracle size printString ].

      self
         assert: actual asArray = oracle asArray
         description: [
            context,
               ' — FIFO contents differ: queue=',
               actual asArray printString,
               ', oracle=',
               oracle asArray printString ]
]

{ #category : 'as yet unclassified' }
ImmutableQueueOracleTest >> exerciseQueueWithSeed: seed operations: operationCount [

	| random queue oracle |
      random := Random seed: seed.
      queue := ImmutableQueue empty.
      oracle := OrderedCollection new.

      1 to: operationCount do: [ :step |
         | operation operationName value previousQueue previousOracle
           result expected operationMatches context |

         operation := random nextInteger: 3.
         previousQueue := queue.
         previousOracle := oracle copy.
         operationMatches := true.

         operation = 1
            ifTrue: [
               "One-third enqueue."
               value := (random nextInteger: 20) = 1
                           ifTrue: [ nil ]
                           ifFalse: [ random nextInteger: 100000 ].

               queue := queue enqueue: value.
               oracle addLast: value.
               operationName := #enqueue ]
            ifFalse: [
               operation = 2
                  ifTrue: [
                     "One-third dequeue, including empty queues."
                     result := queue dequeue.

                     oracle isEmpty
                        ifTrue: [
                           operationMatches := result isNil ]
                        ifFalse: [
                           expected := oracle removeFirst.

                           operationMatches :=
                              result notNil and: [
                                 result first = expected ].

                           result ifNotNil: [
                              queue := result second ] ].

                     operationName := #dequeue ]
                  ifFalse: [
                     "One-third peek, including empty queues."
                     expected := oracle isEmpty
                                    ifTrue: [ nil ]
                                    ifFalse: [ oracle first ].

                     operationMatches := queue peek = expected.
                     operationName := #peek ] ].

         context := 'seed=', seed printString,
                    ' step=', step printString,
                    ' operation=', operationName printString.

         self
            assert: operationMatches
            description: [
               context,
                  ' — queue operation did not match oracle' ].

         self
            assertQueue: previousQueue
            equalsOrderedCollection: previousOracle
            context: context,
               ' — previous persistent version changed'.

         self
            assertQueue: queue
            equalsOrderedCollection: oracle
            context: context ]
]

{ #category : 'tests' }
ImmutableQueueOracleTest >> testGeneratedOperationsMatchOrderedCollection [

	#(1 42 8675309 123456789) do: [ :seed |
         self
            exerciseQueueWithSeed: seed
            operations: 5000 ]
]
