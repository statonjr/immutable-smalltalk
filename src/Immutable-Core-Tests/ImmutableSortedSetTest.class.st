Class {
	#name : 'ImmutableSortedSetTest',
	#superclass : 'TestCase',
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'tests' }
ImmutableSortedSetTest >> testAdd [
    | set |
    set := ImmutableSortedSet empty.
    set := set add: 3.
    set := set add: 1.
    set := set add: 2.
    self assert: set size equals: 3.
    self assert: set asArray equals: #(1 2 3)
]

{ #category : 'tests' }
ImmutableSortedSetTest >> testAddDuplicate [
    | set |
    set := ImmutableSortedSet empty.
    set := set add: 1.
    set := set add: 2.
    set := set add: 1.
    self assert: set size equals: 2
]

{ #category : 'tests' }
ImmutableSortedSetTest >> testCollect [
    | set result |
    set := ImmutableSortedSet fromArray: #(1 2 3).
    result := set collect: [:n | n * 10].
    self assert: result size equals: 3.
    self assert: result asArray equals: #(10 20 30)
]

{ #category : 'tests' }
ImmutableSortedSetTest >> testDo [
    | set results |
    set := ImmutableSortedSet empty.
    set := set add: 3.
    set := set add: 1.
    set := set add: 2.
    results := OrderedCollection new.
    set do: [:each | results add: each].
    self assert: results asArray equals: #(1 2 3)
]

{ #category : 'tests' }
ImmutableSortedSetTest >> testEmpty [
    | set |
    set := ImmutableSortedSet empty.
    self assert: set isEmpty.
    self assert: set size equals: 0
]

{ #category : 'tests' }
ImmutableSortedSetTest >> testFirstAndLast [
    | set |
    set := ImmutableSortedSet empty.
    set := set add: 3.
    set := set add: 1.
    set := set add: 2.
    self assert: set first equals: 1.
    self assert: set last equals: 3
]

{ #category : 'tests' }
ImmutableSortedSetTest >> testFromArray [
    | set |
    set := ImmutableSortedSet fromArray: #(3 1 2 3 1).
    self assert: set size equals: 3.
    self assert: set asArray equals: #(1 2 3)
]

{ #category : 'tests' }
ImmutableSortedSetTest >> testFromArrayEmpty [
    | set |
    set := ImmutableSortedSet fromArray: #().
    self assert: set isEmpty
]

{ #category : 'tests' }
ImmutableSortedSetTest >> testFromArraySingle [
    | set |
    set := ImmutableSortedSet fromArray: #(42).
    self assert: set size equals: 1.
    self assert: (set includes: 42).
]

{ #category : 'tests' }
ImmutableSortedSetTest >> testImmutability [
    | set |
    set := ImmutableSortedSet fromArray: #(1 2 3).
    self assert: set isImmutable.
    self should: [set instVarAt: 1 put: 99] raise: ModificationForbidden
]

{ #category : 'tests' }
ImmutableSortedSetTest >> testIncludes [
    | set |
    set := ImmutableSortedSet empty.
    set := set add: #apple.
    set := set add: #banana.
    set := set add: #cherry.
    self assert: (set includes: #apple).
    self assert: (set includes: #banana).
    self assert: (set includes: #cherry).
    self deny: (set includes: #date)
]

{ #category : 'tests' }
ImmutableSortedSetTest >> testReject [
    | set result |
    set := ImmutableSortedSet fromArray: #(1 2 3 4 5 6).
    result := set reject: [:n | n even].
    self assert: result size equals: 3.
    self assert: result asArray equals: #(1 3 5)
]

{ #category : 'tests' }
ImmutableSortedSetTest >> testRemove [
    | set result |
    set := ImmutableSortedSet empty.
    set := set add: #c.
    set := set add: #a.
    set := set add: #b.
    result := set remove: #b.
    self assert: result size equals: 2.
    self assert: result asArray equals: #(#a #c).
    self assert: set size equals: 3  "Original unchanged"
]

{ #category : 'tests' }
ImmutableSortedSetTest >> testSelect [
    | set result |
    set := ImmutableSortedSet fromArray: #(1 2 3 4 5 6).
    result := set select: [:n | n even].
    self assert: result size equals: 3.
    self assert: result asArray equals: #(2 4 6)
]
