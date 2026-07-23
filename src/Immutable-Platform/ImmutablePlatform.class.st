"
I provide a portability layer for immutability across Smalltalk dialects.

My subclasses implement dialect-specific primitives for making objects read-only:
  - Pharo 14 / TruffleSqueak: setIsReadOnlyObject: (prim 164), isReadOnlyObject (prim 163)
  - VAST Platform: markReadOnly, isReadOnly

Use 'ImmutablePlatform current' to obtain the platform-appropriate instance.

Inspired by Seaside's Grease portability layer.
"
Class {
	#name : 'ImmutablePlatform',
	#superclass : 'Object',
	#classVars : [
		'CurrentPlatform'
	],
	#category : 'Immutable-Platform-Core',
	#package : 'Immutable-Platform',
	#tag : 'Core'
}

{ #category : 'accessing' }
ImmutablePlatform class >> current [
	CurrentPlatform ifNil: [CurrentPlatform := self detectPlatform].
   ^ CurrentPlatform
]

{ #category : 'accessing' }
ImmutablePlatform class >> detectPlatform [
    (Object canUnderstand: #markReadOnly) ifTrue: [^ ImmutableVASTPlatform new].
    (Object canUnderstand: #setIsReadOnlyObject:) ifTrue: [^ ImmutablePharoPlatform new].
    self error: 'Unknown Smalltalk platform for immutability'
]

{ #category : 'converting' }
ImmutablePlatform >> attemptToModifyImmutable: anObject [
    "Called when modification is attempted on an immutable object"
    ModificationForbidden signal: 
        'Cannot modify immutable object: ', anObject printString
]

{ #category : 'converting' }
ImmutablePlatform >> ensureMutable: anObject during: aBlock [
    self subclassResponsibility
]

{ #category : 'converting' }
ImmutablePlatform >> isImmutable: anObject [
    self subclassResponsibility
]

{ #category : 'converting' }
ImmutablePlatform >> makeDeepImmutable: anObject [
    self subclassResponsibility
]

{ #category : 'converting' }
ImmutablePlatform >> makeImmutable: anObject [
    self subclassResponsibility
]
