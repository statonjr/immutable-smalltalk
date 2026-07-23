Class {
	#name : 'ImmutableMapTest',
	#superclass : 'TestCase',
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'tests' }
ImmutableMapTest >> testAddAssociation [
    | map result |
    map := ImmutableMap empty.
    result := map add: #name -> 'Pharo'.
    self assert: (result at: #name) equals: 'Pharo'
]

{ #category : 'tests' }
ImmutableMapTest >> testAtIfAbsent [
    | map |
    map := ImmutableMap empty put: #name value: 'Pharo'.
    self assert: (map at: #name ifAbsent: ['default']) equals: 'Pharo'.
    self assert: (map at: #missing ifAbsent: ['default']) equals: 'default'
]

{ #category : 'tests' }
ImmutableMapTest >> testCollect [
    | map result |
    map := ImmutableMap empty.
    map := map put: #a value: 1.
    map := map put: #b value: 2.
    map := map put: #c value: 3.
    result := map collect: [:key :value | value * 10].
    self assert: (result at: #a) equals: 10.
    self assert: (result at: #b) equals: 20.
    self assert: (result at: #c) equals: 30
]

{ #category : 'tests' }
ImmutableMapTest >> testDo [
    | map results |
    map := ImmutableMap empty.
    map := map put: #a value: 1.
    map := map put: #b value: 2.
    results := OrderedCollection new.
    map do: [:assoc | results add: assoc].
    self assert: results size equals: 2
]

{ #category : 'tests' }
ImmutableMapTest >> testEmpty [
    | map |
    map := ImmutableMap empty.
    self assert: map isEmpty.
    self assert: map size equals: 0.
    self should: [map at: #anything] raise: Error
]

{ #category : 'tests' }
ImmutableMapTest >> testFromAssociations [
    | map |
    map := ImmutableMap fromAssociations: {#a -> 1. #b -> 2. #c -> 3}.
    self assert: map size equals: 3.
    self assert: (map at: #a) equals: 1.
    self assert: (map at: #b) equals: 2.
    self assert: (map at: #c) equals: 3
]

{ #category : 'tests' }
ImmutableMapTest >> testImmutability [
    | map |
    map := ImmutableMap empty put: #name value: 'Pharo'.
    self assert: map isImmutable.
    self should: [map instVarAt: 1 put: 99] raise: ModificationForbidden
]

{ #category : 'tests' }
ImmutableMapTest >> testIncludesKey [
    | map |
    map := ImmutableMap empty put: #name value: 'Pharo'.
    self assert: (map includesKey: #name).
    self deny: (map includesKey: #missing)
]

{ #category : 'tests' }
ImmutableMapTest >> testKeysAndValues [
    | map keys values |
    map := ImmutableMap empty.
    map := map put: #a value: 1.
    map := map put: #b value: 2.
    map := map put: #c value: 3.
    keys := map keys sorted.
    values := map values sorted.
    self assert: keys equals: #(#a #b #c) asOrderedCollection.
    self assert: values equals: #(1 2 3) asOrderedCollection.
]

{ #category : 'tests' }
ImmutableMapTest >> testKeysAndValuesDo [
    | map results |
    map := ImmutableMap empty.
    map := map put: #a value: 1.
    map := map put: #b value: 2.
    results := OrderedCollection new.
    map keysAndValuesDo: [:key :value | results add: {key. value}].
    self assert: results size equals: 2
]

{ #category : 'tests' }
ImmutableMapTest >> testLargeMap [
    | map |
    map := ImmutableMap empty.
    1 to: 1000 do: [:i | map := map put: i value: i * 2].
    self assert: map size equals: 1000.
    1 to: 1000 do: [:i | self assert: (map at: i) equals: i * 2]
]

{ #category : 'tests' }
ImmutableMapTest >> testMerge [
    | map1 map2 merged |
    map1 := ImmutableMap empty.
    map1 := map1 put: #a value: 1.
    map1 := map1 put: #b value: 2.
    map2 := ImmutableMap empty.
    map2 := map2 put: #b value: 99.
    map2 := map2 put: #c value: 3.
    merged := map1 merge: map2.
    self assert: (merged at: #a) equals: 1.
    self assert: (merged at: #b) equals: 99. "map2 wins"
    self assert: (merged at: #c) equals: 3.
    self assert: merged size equals: 3
]

{ #category : 'tests' }
ImmutableMapTest >> testMultipleEntries [
    | map |
    map := ImmutableMap empty.
    map := map put: #name value: 'Pharo'.
    map := map put: #version value: 14.
    map := map put: #language value: 'Smalltalk'.
    self assert: map size equals: 3.
    self assert: (map at: #name) equals: 'Pharo'.
    self assert: (map at: #version) equals: 14.
    self assert: (map at: #language) equals: 'Smalltalk'
]

{ #category : 'tests' }
ImmutableMapTest >> testPutAndAt [
    | map |
    map := ImmutableMap empty put: #name value: 'Pharo'.
    self assert: map size equals: 1.
    self assert: (map at: #name) equals: 'Pharo'
]

{ #category : 'tests' }
ImmutableMapTest >> testRemoveKey [
    | map1 map2 |
    map1 := ImmutableMap empty put: #name value: 'Pharo'.
    map1 := map1 put: #version value: 14.
    map2 := map1 removeKey: #name.
    self deny: (map2 includesKey: #name).
    self assert: (map2 includesKey: #version).
    self assert: map1 size equals: 2.
    self assert: map2 size equals: 1
]

{ #category : 'tests' }
ImmutableMapTest >> testRemoveKeyToEmpty [
    | map result |
    map := ImmutableMap empty put: #name value: 'Pharo'.
    result := map removeKey: #name.
    self assert: result isEmpty
]

{ #category : 'tests' }
ImmutableMapTest >> testSelect [
    | map result |
    map := ImmutableMap empty.
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
ImmutableMapTest >> testStructuralSharing [
    | map1 map2 |
    map1 := ImmutableMap empty.
    1 to: 100 do: [:i | map1 := map1 put: i value: i].
    map2 := map1 put: 101 value: 101.
    self assert: map1 size equals: 100.
    self assert: map2 size equals: 101.
    1 to: 100 do: [:i | self assert: (map1 at: i) equals: i]
]

{ #category : 'tests' }
ImmutableMapTest >> testUpdateExisting [
    | map1 map2 |
    map1 := ImmutableMap empty put: #name value: 'Pharo'.
    map2 := map1 put: #name value: 'Pharo14'.
    self assert: (map1 at: #name) equals: 'Pharo'.
    self assert: (map2 at: #name) equals: 'Pharo14'.
    self assert: map1 size equals: 1.
    self assert: map2 size equals: 1
]
