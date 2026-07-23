"
I provide removal methods for immutable collections.
 
 Requires: remove:
 Provides: removeAll:
 
 Stateless trait — all behavior, no instance variables.
"
Trait {
	#name : 'TImmutableRemovable',
	#category : 'Immutable-Collections',
	#package : 'Immutable-Collections'
}

{ #category : 'removing' }
TImmutableRemovable >> remove: anObject [
    "Subclasses must implement. Return new instance with element removed."
    self explicitRequirement
]

{ #category : 'removing' }
TImmutableRemovable >> removeAll: aCollection [
    | result |
    result := self.
    aCollection do: [:each | result := result remove: each].
    ^ result
]
