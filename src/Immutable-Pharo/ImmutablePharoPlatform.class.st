"
I implement immutability for Pharo 14 using VM primitives 163 and 164.

Makes objects read-only via setIsReadOnlyObject:, queries via isReadOnlyObject. Supports deep immutability via recursivelySetIsReadOnlyObject:exceptObjectsIn:.

See ImmutablePlatform.
"
Class {
	#name : 'ImmutablePharoPlatform',
	#superclass : 'ImmutablePlatform',
	#category : 'Immutable-Pharo-Platform',
	#package : 'Immutable-Pharo',
	#tag : 'Platform'
}

{ #category : 'converting' }
ImmutablePharoPlatform >> ensureMutable: anObject during: aBlock [
    | wasReadOnly result |
    wasReadOnly := anObject isReadOnlyObject.
    wasReadOnly ifTrue: [anObject setIsReadOnlyObject: false].
    result := aBlock value: anObject.
    wasReadOnly ifTrue: [anObject setIsReadOnlyObject: true].
    ^ result
]

{ #category : 'testing' }
ImmutablePharoPlatform >> isImmutable: anObject [
    ^ anObject isReadOnlyObject
]

{ #category : 'converting' }
ImmutablePharoPlatform >> makeDeepImmutable: anObject [
    | alreadyDone |
    alreadyDone := IdentitySet new.
    anObject recursivelySetIsReadOnlyObject: true exceptObjectsIn: alreadyDone.
    ^ anObject
]

{ #category : 'converting' }
ImmutablePharoPlatform >> makeImmutable: anObject [
    anObject setIsReadOnlyObject: true.
    ^ anObject
]
