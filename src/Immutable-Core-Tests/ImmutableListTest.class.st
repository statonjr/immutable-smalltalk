Class {
	#name : 'ImmutableListTest',
	#superclass : 'TestCase',
	#category : 'Immutable-Core-Tests',
	#package : 'Immutable-Core-Tests'
}

{ #category : 'tests' }
ImmutableListTest >> testAddToEnd [
    | list result |
    list := ImmutableList fromArray: #(1 2 3).
    result := list add: 4.
    self assert: result asArray equals: #(4 1 2 3)
]

{ #category : 'tests' }
ImmutableListTest >> testAllSatisfy [
    | list |
    list := ImmutableList fromArray: #(2 4 6 8).
    self assert: (list allSatisfy: [:n | n even]).
    self deny: (list allSatisfy: [:n | n > 5])
]

{ #category : 'tests' }
ImmutableListTest >> testAnySatisfy [
    | list |
    list := ImmutableList fromArray: #(1 2 3 4 5).
    self assert: (list anySatisfy: [:n | n > 3]).
    self deny: (list anySatisfy: [:n | n > 10])
]

{ #category : 'tests' }
ImmutableListTest >> testAppend [
    | list1 list2 result |
    list1 := ImmutableList fromArray: #(1 2 3).
    list2 := ImmutableList fromArray: #(4 5 6).
    result := list1 append: list2.
    self assert: result asArray equals: #(1 2 3 4 5 6)
]

{ #category : 'tests' }
ImmutableListTest >> testAt [
    | list |
    list := ImmutableList fromArray: #(10 20 30 40 50).
    self assert: (list at: 0) equals: 10.
    self assert: (list at: 2) equals: 30.
    self assert: (list at: 4) equals: 50.
    self assert: (list at: 99) isNil
]

{ #category : 'tests' }
ImmutableListTest >> testCaddr [
    | list |
    list := ImmutableList fromArray: #(1 2 3).
    self assert: list caddr equals: 3
]

{ #category : 'tests' }
ImmutableListTest >> testCadr [
    | list |
    list := ImmutableList fromArray: #(1 2 3).
    self assert: list cadr equals: 2
]

{ #category : 'tests' }
ImmutableListTest >> testCar [
    | list |
    list := ImmutableList fromArray: #(1 2 3).
    self assert: list car equals: 1
]

{ #category : 'tests' }
ImmutableListTest >> testCdr [
    | list |
    list := ImmutableList fromArray: #(1 2 3).
    self assert: list cdr first equals: 2
]

{ #category : 'tests' }
ImmutableListTest >> testCollect [
    | list result |
    list := ImmutableList fromArray: #(1 2 3).
    result := list collect: [:n | n * 10].
    self assert: result asArray equals: #(30 20 10)
]

{ #category : 'tests' }
ImmutableListTest >> testCons [
    | list |
    list := ImmutableList empty cons: 1.
    self assert: list size equals: 1.
    self assert: list first equals: 1.
    self assert: list rest equals: ImmutableList empty
]

{ #category : 'tests' }
ImmutableListTest >> testConsMultiple [
    | list |
    list := ImmutableList empty.
    list := list cons: 3.
    list := list cons: 2.
    list := list cons: 1.
    self assert: list size equals: 3.
    self assert: list first equals: 1.
    self assert: list rest first equals: 2.
    self assert: list rest rest first equals: 3
]

{ #category : 'tests' }
ImmutableListTest >> testDo [
    | list results |
    list := ImmutableList fromArray: #(1 2 3).
    results := OrderedCollection new.
    list do: [:each | results add: each].
    self assert: results asArray equals: #(1 2 3)
]

{ #category : 'tests' }
ImmutableListTest >> testDrop [
    | list |
    list := ImmutableList fromArray: #(1 2 3 4 5).
    self assert: (list drop: 2) asArray equals: #(3 4 5).
    self assert: (list drop: 0) asArray equals: #(1 2 3 4 5).
    self assert: (list drop: 10) isEmpty
]

{ #category : 'tests' }
ImmutableListTest >> testDropWhile [
    | list |
    list := ImmutableList fromArray: #(1 2 3 4 5).
    self assert: (list dropWhile: [:n | n < 4]) asArray equals: #(4 5)
]

{ #category : 'tests' }
ImmutableListTest >> testEmpty [
    | list |
    list := ImmutableList empty.
    self assert: list isEmpty.
    self assert: list size equals: 0.
    self assert: list first isNil
]

{ #category : 'tests' }
ImmutableListTest >> testFromArray [
    | list |
    list := ImmutableList fromArray: #(1 2 3).
    self assert: list size equals: 3.
    self assert: list first equals: 1.
    self assert: list rest first equals: 2.
    self assert: list rest rest first equals: 3
]

{ #category : 'tests' }
ImmutableListTest >> testImmutability [
    | list |
    list := ImmutableList fromArray: #(1 2 3).
    self assert: list isImmutable.
    self should: [list instVarAt: 1 put: 'hacked'] raise: ModificationForbidden
]

{ #category : 'tests' }
ImmutableListTest >> testIncludes [
    | list |
    list := ImmutableList fromArray: #(1 2 3 4 5).
    self assert: (list includes: 3).
    self deny: (list includes: 99)
]

{ #category : 'tests' }
ImmutableListTest >> testInjectInto [
    | list sum |
    list := ImmutableList fromArray: #(1 2 3 4 5).
    sum := list inject: 0 into: [:a :b | a + b].
    self assert: sum equals: 15
]

{ #category : 'tests' }
ImmutableListTest >> testLast [
    | list |
    list := ImmutableList fromArray: #(1 2 3).
    self assert: list last equals: 3
]

{ #category : 'tests' }
ImmutableListTest >> testReject [
    | list result |
    list := ImmutableList fromArray: #(1 2 3 4 5).
    result := list reject: [:n | n even].
    self assert: result asArray equals: #(5 3 1)
]

{ #category : 'tests' }
ImmutableListTest >> testReverse [
    | list |
    list := ImmutableList fromArray: #(1 2 3).
    self assert: list reverse asArray equals: #(3 2 1)
]

{ #category : 'tests' }
ImmutableListTest >> testSecondThirdFourth [
    | list |
    list := ImmutableList fromArray: #(1 2 3 4 5).
    self assert: list second equals: 2.
    self assert: list third equals: 3.
    self assert: list fourth equals: 4
]

{ #category : 'tests' }
ImmutableListTest >> testSelect [
    | list result |
    list := ImmutableList fromArray: #(1 2 3 4 5 6).
    result := list select: [:n | n even].
    self assert: result asArray equals: #(6 4 2)
]

{ #category : 'tests' }
ImmutableListTest >> testStructuralSharing [

	| original modified |
	original := ImmutableList fromArray: #( 1 2 3 4 5 ).
	modified := original cons: 0.
	self assert: original asArray equals: #( 1 2 3 4 5 ).
	self assert: modified asArray equals: #( 0 1 2 3 4 5 ).
	self assert: original rest identicalTo: modified rest rest
]

{ #category : 'tests' }
ImmutableListTest >> testTake [
    | list |
    list := ImmutableList fromArray: #(1 2 3 4 5).
    self assert: (list take: 3) asArray equals: #(1 2 3).
    self assert: (list take: 0) isEmpty.
    self assert: (list take: 10) asArray equals: #(1 2 3 4 5)
]

{ #category : 'tests' }
ImmutableListTest >> testTakeWhile [
    | list |
    list := ImmutableList fromArray: #(1 2 3 4 5).
    self assert: (list takeWhile: [:n | n < 4]) asArray equals: #(3 2 1)
]
