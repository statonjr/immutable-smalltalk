"
I am a bitmap-indexed internal node in a HAMT.
 
Uses a 32-bit bitmap to encode child presence, enabling compact storage and fast lookup. Branching factor of 32 gives log₃₂ n depth.
 
See HAMTNode.
"
Class {
	#name : 'HAMTBitmapNode',
	#superclass : 'HAMTNode',
	#instVars : [
		'bitmap',
		'children'
	],
	#category : 'Immutable-HAMT',
	#package : 'Immutable-HAMT'
}

{ #category : 'initialization' }
HAMTBitmapNode >> bitForIndex: index [
    ^ 1 << (index - 1)
]

{ #category : 'initialization' }
HAMTBitmapNode >> childIndexForBit: bit [
    "Count population of bits below this one"
    ^ (bitmap bitAnd: bit - 1) bitCount
]

{ #category : 'initialization' }
HAMTBitmapNode >> do: aBlock [
    children do: [:child | child do: aBlock]
]

{ #category : 'initialization' }
HAMTBitmapNode >> initializeWithBitmap: aBitmap children: aChildren [
    bitmap := aBitmap.
    children := aChildren.
    self makeImmutable
]

{ #category : 'initialization' }
HAMTBitmapNode >> insert: aKey value: aValue hash: aHash shift: shift added: addedBlock [
    | bit childIndex child newChild newChildren newLeaf newBitmap insertIndex |
    bit := self bitForIndex: (self maskIndex: aHash shift: shift).

	"No child at this position - insert new leaf"
    (bitmap bitAnd: bit) = 0 ifTrue: [
        newLeaf := HAMTLeafNode new 
            initializeWithHash: aHash key: aKey value: aValue.
        insertIndex := (bitmap bitAnd: bit - 1) bitCount.
        newBitmap := bitmap bitOr: bit.
        newChildren := Array new: ((bitmap bitCount) + 1).
        
        "Copy existing children up to insertIndex"
        1 to: insertIndex do: [:i | newChildren at: i put: (children at: i)].
        
        "Insert new leaf"
        newChildren at: insertIndex + 1 put: newLeaf.
        
        "Copy remaining children after insertIndex"
        insertIndex + 2 to: newChildren size do: [:i | 
            newChildren at: i put: (children at: i - 1)].
        
        addedBlock value: true.
        ^ HAMTBitmapNode new initializeWithBitmap: newBitmap children: newChildren].

	"Child exists at this position - delegate insertion"
    childIndex := (bitmap bitAnd: bit - 1) bitCount.
    child := children at: childIndex + 1.
    newChild := child insert: aKey value: aValue hash: aHash shift: shift + 5 added: addedBlock.
    newChild == child ifTrue: [^ self].
    
	newChildren := children copy.
    newChildren at: childIndex + 1 put: newChild.
    ^ HAMTBitmapNode new initializeWithBitmap: bitmap children: newChildren

]

{ #category : 'initialization' }
HAMTBitmapNode >> keysAndValuesDo: aBlock [
    children do: [:child | child keysAndValuesDo: aBlock]
]

{ #category : 'initialization' }
HAMTBitmapNode >> lookup: aKey hash: aHash shift: shift [
    | bit childIndex child |
    bit := self bitForIndex: (self maskIndex: aHash shift: shift).
    (bitmap bitAnd: bit) = 0 ifTrue: [^ nil].
    childIndex := self childIndexForBit: bit.
    child := children at: childIndex + 1.
    ^ child lookup: aKey hash: aHash shift: shift + 5
]

{ #category : 'initialization' }
HAMTBitmapNode >> maskIndex: aHash shift: shift [
    ^ ((aHash >> shift) bitAnd: 31) + 1
]

{ #category : 'initialization' }
HAMTBitmapNode >> remove: aKey hash: aHash shift: shift [

	| bit childIndex child newChild newChildren |
	bit := self bitForIndex: (self maskIndex: aHash shift: shift).
	(bitmap bitAnd: bit) = 0 ifTrue: [ ^ self ].
	childIndex := self childIndexForBit: bit.
	child := children at: childIndex + 1.
	newChild := child remove: aKey hash: aHash shift: shift + 5.
	newChild == child ifTrue: [ ^ self ].

	newChild ifNil: [ "Child was removed - update bitmap"
			| newBitmap |
			newBitmap := bitmap bitClear: bit.
			newBitmap = 0 ifTrue: [ ^ nil ].
			newChildren := Array new: children size - 1.

			"Copy children before the removed one"
			1 to: childIndex do: [ :i | newChildren at: i put: (children at: i) ].

			"Copy children after the removed one"
			childIndex + 2 to: children size do: [ :i | newChildren at: i - 1 put: (children at: i) ].

			children size - 1 = 1 ifTrue: [ "Compress - only one child remains" ^ newChildren first ].

			^ HAMTBitmapNode new initializeWithBitmap: newBitmap children: newChildren ].

	newChildren := children copy.
	newChildren at: childIndex + 1 put: newChild.
	^ HAMTBitmapNode new initializeWithBitmap: bitmap children: newChildren
]
