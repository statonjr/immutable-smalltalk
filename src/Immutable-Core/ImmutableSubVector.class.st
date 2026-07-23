"
I am a lazy view over an ImmutableVector, created by take: and drop:.

I share the underlying vector's structure and apply an offset and size limit.
All read operations (at:, first, rest, do:) pass through with the offset applied.
Write operations (add:, cons:) realize the view into a full ImmutableVector.

Chained take: and drop: operations stay lazy — no copying occurs until mutation.

Inspired by Clojure's SubVector (clojure.lang.APersistentVector$SubVector).
"
Class {
	#name : 'ImmutableSubVector',
	#superclass : 'ImmutableObject',
	#traits : 'TImmutableLazySequence + TImmutableAddable + (TImmutableEnumerable - {#select:. #collect:. #reject:})',
	#classTraits : 'TImmutableLazySequence classTrait + TImmutableAddable classTrait + TImmutableEnumerable classTrait',
	#instVars : [
		'vector',
		'offset',
		'subSize'
	],
	#category : 'Immutable-Core',
	#package : 'Immutable-Core'
}

{ #category : 'as yet unclassified' }
ImmutableSubVector class >> on: aVector from: start size: n [
    ^ self basicNew initializeWithVector: aVector offset: start size: n
]

{ #category : 'accessing' }
ImmutableSubVector >> add: anObject [
    "Adding forces realization into a proper vector"
    ^ (self asImmutableVector) add: anObject
]

{ #category : 'accessing' }
ImmutableSubVector >> asImmutableVector [
    | t |
    t := ImmutableVectorTransient from: ImmutableVector empty.
    0 to: subSize - 1 do: [:i | t add: (self at: i)].
    ^ t persistent
]

{ #category : 'accessing' }
ImmutableSubVector >> at: index [
    ^ vector at: offset + index
]

{ #category : 'accessing' }
ImmutableSubVector >> cons: anObject [
    ^ (self asImmutableVector) cons: anObject
]

{ #category : 'accessing' }
ImmutableSubVector >> do: aBlock [
    0 to: subSize - 1 do: [:i | aBlock value: (vector at: offset + i)]
]

{ #category : 'accessing' }
ImmutableSubVector >> drop: n [
    n <= 0 ifTrue: [^ self].
    n >= subSize ifTrue: [^ ImmutableVector empty].
    ^ ImmutableSubVector on: vector from: offset + n size: subSize - n
]

{ #category : 'accessing' }
ImmutableSubVector >> first [
    ^ vector at: offset
]

{ #category : 'initialization' }
ImmutableSubVector >> initializeWithVector: aVector offset: anOffset size: aSize [
    vector := aVector.
    offset := anOffset.
    subSize := aSize.
    self makeImmutable
]

{ #category : 'accessing' }
ImmutableSubVector >> isEmpty [
    ^ subSize = 0
]

{ #category : 'accessing' }
ImmutableSubVector >> rest [
    subSize <= 1 ifTrue: [^ ImmutableVector empty].
    ^ ImmutableSubVector on: vector from: offset + 1 size: subSize - 1

]

{ #category : 'accessing' }
ImmutableSubVector >> size [
    ^ subSize
]

{ #category : 'accessing' }
ImmutableSubVector >> species [
    ^ ImmutableVector
]

{ #category : 'accessing' }
ImmutableSubVector >> take: n [
    n <= 0 ifTrue: [^ ImmutableVector empty].
    n >= subSize ifTrue: [^ self].
    ^ ImmutableSubVector on: vector from: offset size: n
]
