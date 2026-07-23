Class {
	#name : 'ImmutableSetTest',
	#superclass : 'TestCase',
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'tests' }
ImmutableSetTest >> testAdd [
    | set |
    set := ImmutableSet empty.
    set := set add: 1.
    self assert: set size equals: 1.
    self assert: (set includes: 1)
]

{ #category : 'tests' }
ImmutableSetTest >> testAddDuplicate [
    | set |
    set := ImmutableSet empty.
    set := set add: 1.
    set := set add: 1.
    self assert: set size equals: 1
]

{ #category : 'tests' }
ImmutableSetTest >> testCollect [
    | set result |
    set := ImmutableSet empty.
    set := set add: 1.
    set := set add: 2.
    set := set add: 3.
    result := set collect: [:n | n * 10].
    self assert: result size equals: 3.
    self assert: (result includes: 10).
    self assert: (result includes: 20).
    self assert: (result includes: 30)
]

{ #category : 'tests' }
ImmutableSetTest >> testDifference [
    | set1 set2 result |
    set1 := ImmutableSet fromArray: #(1 2 3 4).
    set2 := ImmutableSet fromArray: #(3 4 5 6).
    result := set1 difference: set2.
    self assert: result size equals: 2.
    self assert: (result includes: 1).
    self assert: (result includes: 2)
]

{ #category : 'tests' }
ImmutableSetTest >> testDo [
    | set results |
    set := ImmutableSet empty.
    set := set add: 1.
    set := set add: 2.
    set := set add: 3.
    results := OrderedCollection new.
    set do: [:each | results add: each].
    self assert: results size equals: 3
]

{ #category : 'tests' }
ImmutableSetTest >> testEmpty [
    | set |
    set := ImmutableSet empty.
    self assert: set isEmpty.
    self assert: set size equals: 0
]

{ #category : 'tests' }
ImmutableSetTest >> testFromArray [
    | set |
    set := ImmutableSet fromArray: #(1 2 3 2 1).
    self assert: set size equals: 3.
    self assert: (set includes: 1).
    self assert: (set includes: 2).
    self assert: (set includes: 3)
]

{ #category : 'tests' }
ImmutableSetTest >> testImmutability [
    | set |
    set := ImmutableSet fromArray: #(1 2 3).
    self assert: set isImmutable.
    self should: [set instVarAt: 1 put: 99] raise: ModificationForbidden
]

{ #category : 'tests' }
ImmutableSetTest >> testIncludes [
    | set |
    set := ImmutableSet empty.
    set := set add: #apple.
    set := set add: #banana.
    self assert: (set includes: #apple).
    self assert: (set includes: #banana).
    self deny: (set includes: #cherry)
]

{ #category : 'tests' }
ImmutableSetTest >> testIntersection [
    | set1 set2 result |
    set1 := ImmutableSet fromArray: #(1 2 3 4).
    set2 := ImmutableSet fromArray: #(3 4 5 6).
    result := set1 intersection: set2.
    self assert: result size equals: 2.
    self assert: (result includes: 3).
    self assert: (result includes: 4)
]

{ #category : 'tests' }
ImmutableSetTest >> testRemove [
    | set1 set2 |
    set1 := ImmutableSet empty.
    set1 := set1 add: #a.
    set1 := set1 add: #b.
    set1 := set1 add: #c.
    set2 := set1 remove: #b.
    self assert: set1 size equals: 3.
    self assert: set2 size equals: 2.
    self assert: (set2 includes: #a).
    self deny: (set2 includes: #b).
    self assert: (set2 includes: #c)
]

{ #category : 'tests' }
ImmutableSetTest >> testRemoveNonExistent [
    | set result |
    set := ImmutableSet empty.
    set := set add: 1.
    result := set remove: 99.
    self assert: result equals: set
]

{ #category : 'tests' }
ImmutableSetTest >> testSelect [
    | set result |
    set := ImmutableSet empty.
    set := set add: 1.
    set := set add: 2.
    set := set add: 3.
    set := set add: 4.
    result := set select: [:n | n even].
    self assert: result size equals: 2.
    self assert: (result includes: 2).
    self assert: (result includes: 4)
]

{ #category : 'tests' }
ImmutableSetTest >> testUnion [
    | set1 set2 result |
    set1 := ImmutableSet fromArray: #(1 2 3).
    set2 := ImmutableSet fromArray: #(3 4 5).
    result := set1 union: set2.
    self assert: result size equals: 5.
    self assert: (result includes: 1).
    self assert: (result includes: 5)
]
