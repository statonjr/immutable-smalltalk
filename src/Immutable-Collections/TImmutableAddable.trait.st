"
I provide addition methods for immutable collections.
 
 Requires: add:
 Provides: addAll:, ,
 
 Stateless trait — all behavior, no instance variables.
"
Trait {
	#name : 'TImmutableAddable',
	#category : 'Immutable-Collections',
	#package : 'Immutable-Collections'
}

{ #category : 'adding' }
TImmutableAddable >> , aCollection [
    ^ self addAll: aCollection
]

{ #category : 'adding' }
TImmutableAddable >> add: anObject [
    "Subclasses must implement. Return new instance with element added."
    self explicitRequirement
]

{ #category : 'adding' }
TImmutableAddable >> addAll: aCollection [
    | result |
    result := self.
    aCollection do: [:each | result := result add: each].
    ^ result
]
