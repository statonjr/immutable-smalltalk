Class {
	#name : 'ImmutableVectorOracleTest',
	#superclass : 'TestCase',
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'asserting' }
ImmutableVectorOracleTest >> assertVector: vector equalsOrderedCollection: ordered context: context [

      self
         assert: vector size = ordered size
         description: [
            context,
               ' — size mismatch: vector=',
               vector size printString,
               ', oracle=',
               ordered size printString ].

      0 to: vector size - 1 do: [ :index |
         self
            assert: (vector at: index) = (ordered at: index + 1)
            description: [
               context,
                  ' — value mismatch at zero-based index ',
                  index printString ] ]
]

{ #category : 'private' }
ImmutableVectorOracleTest >> drop: count from: ordered [

      | result start |
      result := OrderedCollection new.
      start := (count min: ordered size) + 1.

      start to: ordered size do: [ :index |
         result add: (ordered at: index) ].

      ^ result
]

{ #category : 'running' }
ImmutableVectorOracleTest >> exerciseVectorWithSeed: seed operations: operationCount [

	| random vector ordered |
      random := Random seed: seed.
      vector := ImmutableVector empty.
      ordered := OrderedCollection new.

      1 to: operationCount do: [ :step |
         | operation operationName previousVector previousOrdered
           value count index lookupMatches context |

         operation := random nextInteger: 5.

         "Looking up an empty collection is not useful here. Append instead."
         (operation = 3 and: [ ordered isEmpty ]) ifTrue: [
            operation := 1 ].

         previousVector := vector.
         previousOrdered := ordered copy.
         lookupMatches := true.

         operation <= 2
            ifTrue: [
               "40% append."
               value := (random nextInteger: 20) = 1
                           ifTrue: [ nil ]
                           ifFalse: [ random nextInteger: 100000 ].

               vector := vector add: value.
               ordered add: value.
               operationName := #add ]
            ifFalse: [
               operation = 3
                  ifTrue: [
                     "20% indexed lookup."
                     index := (random nextInteger: ordered size) - 1.

                     lookupMatches :=
                        (vector at: index) = (ordered at: index + 1).

                     operationName := #at ]
                  ifFalse: [
                     count := (random nextInteger: ordered size + 6) - 1.

                     operation = 4
                        ifTrue: [
                           "20% take, including counts beyond size."
                           vector := vector take: count.
                           ordered := self take: count from: ordered.
                           operationName := #take ]
                        ifFalse: [
                           "20% drop, including counts beyond size."
                           vector := vector drop: count.
                           ordered := self drop: count from: ordered.
                           operationName := #drop ] ] ].

         context := 'seed=', seed printString,
                    ' step=', step printString,
                    ' operation=', operationName printString.

         self
            assert: lookupMatches
            description: [
               context,
                  ' — indexed lookup did not match oracle' ].

         "Every operation must leave the previous persistent version intact."
         self
            assertVector: previousVector
            equalsOrderedCollection: previousOrdered
            context: context,
               ' — previous version changed'.

         self
            assertVector: vector
            equalsOrderedCollection: ordered
            context: context ]
]

{ #category : 'private' }
ImmutableVectorOracleTest >> take: count from: ordered [

      | result limit |
      limit := count min: ordered size.
      result := OrderedCollection new: limit.

      1 to: limit do: [ :index |
         result add: (ordered at: index) ].

      ^ result
]

{ #category : 'tests' }
ImmutableVectorOracleTest >> testGeneratedOperationsMatchOrderedCollection [
		
		#(1 42 8675309 123456789) do: [ :seed |
         self
            exerciseVectorWithSeed: seed
            operations: 3000 ]
]

{ #category : 'tests' }
ImmutableVectorOracleTest >> testStructuralBoundariesMatchOrderedCollection [

	| vector ordered checkpoints |
      vector := ImmutableVector empty.
      ordered := OrderedCollection new.

      checkpoints := #(
         31 32 33
         1023 1024 1025
         1055 1056 1057
         32767 32768
         32799 32800 32801
      ).

      1 to: checkpoints last do: [ :value |
         vector := vector add: value.
         ordered add: value.

         (checkpoints includes: value) ifTrue: [
            self
               assertVector: vector
               equalsOrderedCollection: ordered
               context: 'boundary size=', value printString ] ]
]
