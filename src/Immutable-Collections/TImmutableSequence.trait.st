"
I provide sequential access methods for immutable ordered collections.
 
 Requires: first, rest, cons:, isEmpty
 Provides: second, third, fourth, fifth,
           car, cdr, cadr, caddr, cadddr, caar, cdar, caadr, cdadr,
           take:, drop:, takeWhile:, dropWhile:, reverse
 
 Uses TImmutableEnumerable.
 Stateless trait — all behavior, no instance variables.
"
Trait {
	#name : 'TImmutableSequence',
	#category : 'Immutable-Collections',
	#package : 'Immutable-Collections'
}

{ #category : 'accessing' }
TImmutableSequence >> cadddr [
    ^ self rest rest rest first
]

{ #category : 'accessing' }
TImmutableSequence >> caddr [
    ^ self rest rest first
]

{ #category : 'accessing' }
TImmutableSequence >> cadr [
    ^ self rest first
]

{ #category : 'accessing' }
TImmutableSequence >> car [
    ^ self first
]

{ #category : 'accessing' }
TImmutableSequence >> cdr [
    ^ self rest
]

{ #category : 'initialization' }
TImmutableSequence >> cons: anObject [
    "Prepend an element. Return new sequence with anObject as first element."
    self explicitRequirement
]

{ #category : 'accessing' }
TImmutableSequence >> drop: n [

	| current remaining |
	current := self.
	remaining := n.
	[ remaining > 0 and: [ current isNotEmpty ] ] whileTrue: [
			current := current rest.
			remaining := remaining - 1 ].
	^ current
]

{ #category : 'accessing' }
TImmutableSequence >> dropWhile: aBlock [

	| current |
	current := self.
	[ current isNotEmpty and: [ aBlock value: current first ] ] whileTrue: [ current := current rest ].
	^ current
]

{ #category : 'accessing' }
TImmutableSequence >> fifth [
    ^ self rest rest rest rest first
]

{ #category : 'accessing' }
TImmutableSequence >> first [
    self explicitRequirement
]

{ #category : 'accessing' }
TImmutableSequence >> fourth [
    ^ self rest rest rest first
]

{ #category : 'accessing' }
TImmutableSequence >> rest [
    self explicitRequirement
]

{ #category : 'accessing' }
TImmutableSequence >> reverse [
    | result current |
    result := self species empty.
    current := self.
    [current isEmpty] whileFalse: [
        result := result cons: current first.
        current := current rest].
    ^ result
]

{ #category : 'accessing' }
TImmutableSequence >> second [
    ^ self rest first
]

{ #category : 'accessing' }
TImmutableSequence >> take: n [

	| result current remaining |
	n <= 0 ifTrue: [ ^ self species empty ].
	result := self species empty.
	current := self.
	remaining := n.
	[ remaining > 0 and: [ current isNotEmpty ] ] whileTrue: [
			result := result cons: current first.
			current := current rest.
			remaining := remaining - 1 ].
	^ result reverse
]

{ #category : 'accessing' }
TImmutableSequence >> takeWhile: aBlock [

	| result current |
	result := self species empty.
	current := self.
	[ current isNotEmpty and: [ aBlock value: current first ] ] whileTrue: [
			result := result add: current first.
			current := current rest ].
	^ result
]

{ #category : 'accessing' }
TImmutableSequence >> third [
    ^ self rest rest first
]
