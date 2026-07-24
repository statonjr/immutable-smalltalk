Class {
	#name : 'ImmutableMapOracleTest',
	#superclass : 'TestCase',
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'asserting' }
ImmutableMapOracleTest >> assertMap: immutableMap equalsDictionary: dictionary context: context [
	self
         assert: immutableMap size = dictionary size
         description: [
            context,
            ' — size mismatch: immutable=',
            immutableMap size printString,
            ', dictionary=',
            dictionary size printString ].

      dictionary keysAndValuesDo: [ :key :value |
         self
            assert: (immutableMap includesKey: key)
            description: [
               context,
                  ' — immutable map is missing key ',
                  key printString ].

         self
            assert: (immutableMap at: key) = value
            description: [
               context,
                  ' — value mismatch for key ',
                  key printString ] ].

      immutableMap keysAndValuesDo: [ :key :value |
         self
            assert: (dictionary includesKey: key)
            description: [
               context,
                  ' — immutable map contains unexpected key ',
                  key printString ].

         self
            assert: (dictionary at: key) = value
            description: [
               context,
                  ' — oracle value mismatch for key ',
                  key printString ] ]
]

{ #category : 'running' }
ImmutableMapOracleTest >> exerciseMapWithSeed: seed operations: operationCount [

      | random immutableMap dictionary history sentinel |
      random := Random seed: seed.
      immutableMap := ImmutableMap empty.
      dictionary := Dictionary new.
      history := OrderedCollection new.
      sentinel := Object new.

      1 to: operationCount do: [ :step |
         | operation key value previousMap previousDictionary
           operationName lookupMatches context |

         operation := random nextInteger: 4.
         key := random nextInteger: 64.

         previousMap := nil.
         previousDictionary := nil.
         lookupMatches := true.

         operation <= 2
            ifTrue: [
               "50% put/update. A small key space deliberately causes
             repeated updates of existing keys."
               previousMap := immutableMap.
               previousDictionary := dictionary copy.

               value := (random nextInteger: 10) = 1
                           ifTrue: [ nil ]
                           ifFalse: [ random nextInteger: 100000 ].

               immutableMap := immutableMap
                                  put: key
                                  value: value.

               dictionary at: key put: value.
               operationName := #put.
               history add: { #put. key. value } ]
            ifFalse: [
               operation = 3
                  ifTrue: [
                     "25% removal, including absent keys."
                     previousMap := immutableMap.
                     previousDictionary := dictionary copy.

                     immutableMap := immutableMap removeKey: key.
                     dictionary
                        removeKey: key
                        ifAbsent: [ ].

                     operationName := #remove.
                     history add: { #remove. key } ]
                  ifFalse: [
                     "25% lookup, including absent keys."
                     | expected actual |
                     expected := dictionary
                                    at: key
                                    ifAbsent: [ sentinel ].

                     actual := immutableMap
                                  at: key
                                  ifAbsent: [ sentinel ].

                     lookupMatches := actual = expected.
                     operationName := #lookup.
                     history add: { #lookup. key } ] ].

         context := 'seed=', seed printString,
                    ' step=', step printString,
                    ' operation=', operationName printString.

         self
            assert: lookupMatches
            description: [
               context,
                  ' — lookup mismatch; history=',
                  history printString ].

         previousMap ifNotNil: [
            self
               assertMap: previousMap
               equalsDictionary: previousDictionary
               context: context,
                  ' — previous persistent version changed' ].

         self
            assertMap: immutableMap
            equalsDictionary: dictionary
            context: context ]
]

{ #category : 'tests' }
ImmutableMapOracleTest >> testGeneratedOperationsMatchDictionary [
	#(1 42 8675309 123456789) do: [ :seed |
         self
            exerciseMapWithSeed: seed
            operations: 1000 ].
]
