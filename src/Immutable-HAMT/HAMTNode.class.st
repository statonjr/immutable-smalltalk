"
I am an internal node in a Hash Array Mapped Trie.
See: Bagwell, 'Ideal Hash Trees' (2001).
 
Subclasses: HAMTLeafNode, HAMTBitmapNode, HAMTCollisionNode.
"
Class {
	#name : 'HAMTNode',
	#superclass : 'Object',
	#category : 'Immutable-HAMT',
	#package : 'Immutable-HAMT'
}

{ #category : 'testing' }
HAMTNode >> isImmutable [
	^ self isReadOnlyObject
]

{ #category : 'initialization' }
HAMTNode >> makeImmutable [
    "Make this node read-only using Pharo 14's primitive"
    self setIsReadOnlyObject: true.
    ^ self
]
