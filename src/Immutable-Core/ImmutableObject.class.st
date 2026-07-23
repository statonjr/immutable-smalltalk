"
ImmutableObject is the base class for all immutable data structures.

Subclasses are made read-only via Pharo 14 primitives upon initialization.
 
Inspired by Clojure's persistent collections and immutable-ruby.
"
Class {
	#name : 'ImmutableObject',
	#superclass : 'Object',
	#category : 'Immutable-Core',
	#package : 'Immutable-Core'
}

{ #category : 'initialization' }
ImmutableObject >> initialize [
    super initialize.
    self makeImmutable
]

{ #category : 'initialization' }
ImmutableObject >> isImmutable [
    ^ ImmutablePlatform current isImmutable: self
]

{ #category : 'initialization' }
ImmutableObject >> makeDeepImmutable [
    ImmutablePlatform current makeDeepImmutable: self
]

{ #category : 'initialization' }
ImmutableObject >> makeImmutable [
    ImmutablePlatform current makeImmutable: self
]
