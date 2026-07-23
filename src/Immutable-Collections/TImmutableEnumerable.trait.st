"
""I provide iteration and query methods for immutable collections.
 
 Requires: do:, isEmpty
 Provides: select:, reject:, collect:, detect:, detect:ifNone:,
           includes:, anySatisfy:, allSatisfy:, noneSatisfy:,
           inject:into:, size, asArray, isNotEmpty
 
 Stateless trait — all behavior, no instance variables.""
"
Trait {
	#name : 'TImmutableEnumerable',
	#category : 'Immutable-Collections',
	#package : 'Immutable-Collections'
}

{ #category : 'enumerating' }
TImmutableEnumerable >> allSatisfy: aBlock [
    self do: [:each | (aBlock value: each) ifFalse: [^ false]].
    ^ true
]

{ #category : 'enumerating' }
TImmutableEnumerable >> anySatisfy: aBlock [
    self do: [:each | (aBlock value: each) ifTrue: [^ true]].
    ^ false
]

{ #category : 'enumerating' }
TImmutableEnumerable >> asArray [
    | result index |
    result := Array new: self size.
    index := 1.
    self do: [:each | result at: index put: each. index := index + 1].
    ^ result
]

{ #category : 'enumerating' }
TImmutableEnumerable >> collect: aBlock [
    | result |
    result := self species empty.
    self do: [:each | result := result add: (aBlock value: each)].
    ^ result
]

{ #category : 'enumerating' }
TImmutableEnumerable >> detect: aBlock [
    self do: [:each | (aBlock value: each) ifTrue: [^ each]].
    ^ nil
]

{ #category : 'enumerating' }
TImmutableEnumerable >> detect: aBlock ifNone: noneBlock [
    ^ (self detect: aBlock) ifNil: [noneBlock value]
]

{ #category : 'enumerating' }
TImmutableEnumerable >> do: aBlock [
    "Subclasses must implement. Iterate over all elements."
    self explicitRequirement
]

{ #category : 'enumerating' }
TImmutableEnumerable >> includes: anObject [
    self do: [:each | each = anObject ifTrue: [^ true]].
    ^ false
]

{ #category : 'enumerating' }
TImmutableEnumerable >> inject: thisValue into: binaryBlock [
    | nextValue |
    nextValue := thisValue.
    self do: [:each | nextValue := binaryBlock value: nextValue value: each].
    ^ nextValue
]

{ #category : 'enumerating' }
TImmutableEnumerable >> isEmpty [
    self do: [:each | ^ false].
    ^ true
]

{ #category : 'enumerating' }
TImmutableEnumerable >> isNotEmpty [
    self do: [:each | ^ true].
    ^ false
]

{ #category : 'enumerating' }
TImmutableEnumerable >> noneSatisfy: aBlock [
    ^ (self anySatisfy: aBlock) not
]

{ #category : 'enumerating' }
TImmutableEnumerable >> reject: aBlock [
    ^ self select: [:each | (aBlock value: each) not]
]

{ #category : 'enumerating' }
TImmutableEnumerable >> select: aBlock [
    | result |
    result := self species empty.
    self do: [:each |
        (aBlock value: each) ifTrue: [result := result add: each]].
    ^ result
]

{ #category : 'enumerating' }
TImmutableEnumerable >> size [
    | count |
    count := 0.
    self do: [:each | count := count + 1].
    ^ count
]
