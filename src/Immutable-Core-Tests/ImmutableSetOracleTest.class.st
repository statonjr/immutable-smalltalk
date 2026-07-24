Class {
	#name : 'ImmutableSetOracleTest',
	#superclass : 'TestCase',
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'asserting' }
ImmutableSetOracleTest >> assertSet: immutableSet equalsSet: oracle context: context [
	
	self
         assert: immutableSet size = oracle size
         description: [
            context,
               ' — size mismatch: immutable=',
               immutableSet size printString,
               ', oracle=',
               oracle size printString ].

      oracle do: [ :each |
         self
            assert: (immutableSet includes: each)
            description: [
               context,
                  ' — immutable set is missing ',
                  each printString ] ].

      immutableSet do: [ :each |
         self
            assert: (oracle includes: each)
            description: [
               context,
                  ' — immutable set contains unexpected value ',
                  each printString ] ]
]

{ #category : 'running' }
ImmutableSetOracleTest >> exerciseSetWithSeed: seed operations: operationCount [

	| random immutableSet oracle |
      random := Random seed: seed.
      immutableSet := ImmutableSet empty.
      oracle := Set new.

      1 to: operationCount do: [ :step |
         | operation operationName element previousSet previousOracle
           includesMatches context |

         operation := random nextInteger: 4.

         element := (random nextInteger: 20) = 1
                       ifTrue: [ nil ]
                       ifFalse: [ random nextInteger: 64 ].

         previousSet := immutableSet.
         previousOracle := oracle copy.
         includesMatches := true.

         operation <= 2
            ifTrue: [
               "50% add, with frequent duplicates from the small domain."
               immutableSet := immutableSet add: element.
               oracle add: element.
               operationName := #add ]
            ifFalse: [
               operation = 3
                  ifTrue: [
                     "25% remove, including absent elements."
                     immutableSet := immutableSet remove: element.
                     oracle
                        remove: element
                        ifAbsent: [ ].
                     operationName := #remove ]
                  ifFalse: [
                     "25% membership query."
                     includesMatches :=
                        (immutableSet includes: element)
                           = (oracle includes: element).
                     operationName := #includes ] ].

         context := 'seed=', seed printString,
                    ' step=', step printString,
                    ' operation=', operationName printString.

         self
            assert: includesMatches
            description: [
               context,
                  ' — membership result did not match oracle' ].

         self
            assertSet: previousSet
            equalsSet: previousOracle
            context: context,
               ' — previous persistent version changed'.

         self
            assertSet: immutableSet
            equalsSet: oracle
            context: context ]
]

{ #category : 'tests' }
ImmutableSetOracleTest >> testGeneratedOperationsMatchSet [

		#(1 42 8675309 123456789) do: [ :seed |
         self
            exerciseSetWithSeed: seed
            operations: 2000 ]
]

{ #category : 'tests' }
ImmutableSetOracleTest >> testGeneratedSetAlgebraMatchesBuiltInSet [

	#(1 42 8675309 123456789) do: [ :seed |
         | random leftValues rightValues
           leftImmutable rightImmutable
           leftOracle rightOracle |

         random := Random seed: seed.

         leftValues := (1 to: 100) collect: [ :ignored |
            random nextInteger: 128 ].

         rightValues := (1 to: 100) collect: [ :ignored |
            random nextInteger: 128 ].

         leftImmutable := ImmutableSet fromArray: leftValues.
         rightImmutable := ImmutableSet fromArray: rightValues.

         leftOracle := leftValues asSet.
         rightOracle := rightValues asSet.

         self
            assertSet: (leftImmutable union: rightImmutable)
            equalsSet: (leftOracle union: rightOracle)
            context: 'union seed=', seed printString.

         self
            assertSet: (leftImmutable intersection: rightImmutable)
            equalsSet: (leftOracle intersection: rightOracle)
            context: 'intersection seed=', seed printString.

         self
            assertSet: (leftImmutable difference: rightImmutable)
            equalsSet: (leftOracle difference: rightOracle)
            context: 'difference seed=', seed printString.

         "Set algebra must not mutate either input."
         self
            assertSet: leftImmutable
            equalsSet: leftOracle
            context: 'left input changed, seed=', seed printString.

         self
            assertSet: rightImmutable
            equalsSet: rightOracle
            context: 'right input changed, seed=', seed printString ]
]
