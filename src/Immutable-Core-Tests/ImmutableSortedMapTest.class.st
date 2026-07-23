Class {
	#name : 'ImmutableSortedMapTest',
	#superclass : 'TestCase',
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'tests' }
ImmutableSortedMapTest >> testCollect [
    | map result |
    map := ImmutableSortedMap empty.
    map := map put: #a value: 1.
    map := map put: #b value: 2.
    map := map put: #c value: 3.
    result := map collect: [:key :value | value * 10].
    self assert: (result at: #a) equals: 10.
    self assert: (result at: #b) equals: 20.
    self assert: (result at: #c) equals: 30
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testDo [
    | map results |
    map := ImmutableSortedMap empty.
    map := map put: #b value: 2.
    map := map put: #a value: 1.
    results := OrderedCollection new.
    map do: [:assoc | results add: assoc].
    self assert: results size equals: 2.
    self assert: results first key equals: #a.
    self assert: results last key equals: #b
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testEmpty [
    | map |
    map := ImmutableSortedMap empty.
    self assert: map isEmpty.
    self assert: map size equals: 0.
    self should: [map at: #anything] raise: Error
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testFirstAndLast [
    | map |
    map := ImmutableSortedMap empty.
    map := map put: #c value: 3.
    map := map put: #a value: 1.
    map := map put: #b value: 2.
    self assert: map first key equals: #a.
    self assert: map first value equals: 1.
    self assert: map last key equals: #c.
    self assert: map last value equals: 3
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testFromArray [
    | map |
    map := ImmutableSortedMap fromArray: {#c -> 3. #a -> 1. #b -> 2. #a -> 99}.
    self assert: map size equals: 3.
    self assert: map keys equals: #(#a #b #c).
    self assert: (map at: #a) equals: 99  
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testFromArrayEmpty [
    | map |
    map := ImmutableSortedMap fromArray: #().
    self assert: map isEmpty
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testFromArraySingle [
    | map |
    map := ImmutableSortedMap fromArray: {#x -> 42}.
    self assert: map size equals: 1.
    self assert: (map at: #x) equals: 42
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testImmutability [
    | map |
    map := ImmutableSortedMap empty put: #name value: 'Pharo'.
    self assert: map isImmutable.
    self should: [map instVarAt: 1 put: 99] raise: ModificationForbidden
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testKeysAndValuesDo [
    | map results |
    map := ImmutableSortedMap empty.
    map := map put: #c value: 3.
    map := map put: #a value: 1.
    map := map put: #b value: 2.
    results := OrderedCollection new.
    map keysAndValuesDo: [:k :v | results add: {k. v}].
    self assert: results asArray equals: {{#a. 1}. {#b. 2}. {#c. 3}}
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testMultipleEntriesMaintainsOrder [
    | map |
    map := ImmutableSortedMap empty.
    map := map put: #c value: 3.
    map := map put: #a value: 1.
    map := map put: #b value: 2.
    self assert: map size equals: 3.
    self assert: map keys equals: #(#a #b #c)
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testPutAndAt [
    | map |
    map := ImmutableSortedMap empty.
    map := map put: #name value: 'Pharo'.
    self assert: map size equals: 1.
    self assert: (map at: #name) equals: 'Pharo'
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testReject [
    | map result |
    map := ImmutableSortedMap empty.
    map := map put: #a value: 1.
    map := map put: #b value: 2.
    map := map put: #c value: 3.
    map := map put: #d value: 4.
    result := map reject: [:key :value | value even].
    self assert: result size equals: 2.
    self assert: (result includesKey: #a).
    self assert: (result includesKey: #c).
    self assert: (result at: #a) equals: 1.
    self assert: (result at: #c) equals: 3.
    self assert: result keys equals: #(#a #c)
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testRemoveKey [
    | map result |
    map := ImmutableSortedMap empty.
    map := map put: #c value: 3.
    map := map put: #a value: 1.
    map := map put: #b value: 2.
    result := map removeKey: #b.
    self assert: result size equals: 2.
    self assert: result keys equals: #(#a #c).
    self assert: (map at: #b) equals: 2
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testSelect [
    | map result |
    map := ImmutableSortedMap empty.
    map := map put: #a value: 1.
    map := map put: #b value: 2.
    map := map put: #c value: 3.
    map := map put: #d value: 4.
    result := map select: [:key :value | value even].
    self assert: result size equals: 2.
    self assert: (result includesKey: #b).
    self assert: (result includesKey: #d)
]

{ #category : 'tests' }
ImmutableSortedMapTest >> testUpdateExistingPreservesPosition [
    | map |
    map := ImmutableSortedMap empty.
    map := map put: #b value: 2.
    map := map put: #a value: 1.
    map := map put: #c value: 3.
    map := map put: #a value: 99.
    self assert: (map at: #a) equals: 99.
    self assert: map keys equals: #(#a #b #c)
]
