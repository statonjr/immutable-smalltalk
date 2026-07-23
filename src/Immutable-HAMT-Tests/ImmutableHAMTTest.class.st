Class {
	#name : 'ImmutableHAMTTest',
	#superclass : 'TestCase',
	#category : 'Immutable-HAMT-Tests',
	#package : 'Immutable-HAMT-Tests'
}

{ #category : 'tests' }
ImmutableHAMTTest >> testBitmapNodeCompressOnRemove [
    | node result1 result2 |
    node := HAMTBitmapNode new initializeWithBitmap: 0 children: #().
    result1 := node insert: #name value: 'Pharo' hash: #name hash shift: 0 added: [:b | ].
    result1 := result1 insert: #age value: 50 hash: #age hash shift: 0 added: [:b | ].
    
    result2 := result1 remove: #age hash: #age hash shift: 0.
    "Should compress to leaf node when only one entry remains"
    self assert: (result2 isKindOf: HAMTLeafNode)
]

{ #category : 'tests' }
ImmutableHAMTTest >> testBitmapNodeDo [
    | node result results |
    node := HAMTBitmapNode new initializeWithBitmap: 0 children: #().
    result := node insert: #a value: 1 hash: #a hash shift: 0 added: [:b | ].
    result := result insert: #b value: 2 hash: #b hash shift: 0 added: [:b | ].
    result := result insert: #c value: 3 hash: #c hash shift: 0 added: [:b | ].
    
    results := OrderedCollection new.
    result do: [:each | results add: each].
    self assert: results size equals: 3.
    self assert: (results collect: #key) sorted equals: #(#a #b #c) asOrderedCollection.
    self assert: (results collect: #value) sorted equals: #(1 2 3) asOrderedCollection.
]

{ #category : 'tests' }
ImmutableHAMTTest >> testBitmapNodeEmpty [
    | node |
    node := HAMTBitmapNode new initializeWithBitmap: 0 children: #().
    self assert: (node lookup: #any hash: 42 shift: 0) isNil
]

{ #category : 'tests' }
ImmutableHAMTTest >> testBitmapNodeIsImmutable [
    | node |
    node := HAMTBitmapNode new initializeWithBitmap: 0 children: #().
    self assert: node isImmutable
]

{ #category : 'tests' }
ImmutableHAMTTest >> testBitmapNodeMultipleEntriesDifferentBranches [

	| node entries result |
	node := HAMTBitmapNode new initializeWithBitmap: 0 children: #(  ).
	entries := {
		           (#name -> 'Pharo').
		           (#age -> 50).
		           (#language -> 'Smalltalk').
		           (#paradigm -> 'OO').
		           (#year -> 2026) }.

	result := node.
	entries do: [ :assoc |
			result := result
				          insert: assoc key
				          value: assoc value
				          hash: assoc key hash
				          shift: 0
				          added: [ :b | self assert: b ] ].

	entries do: [ :assoc |
			| found |
			found := result lookup: assoc key hash: assoc key hash shift: 0.
			self assert: found value equals: assoc value ]
]

{ #category : 'tests' }
ImmutableHAMTTest >> testBitmapNodeRemove [
    | node result1 result2 |
    node := HAMTBitmapNode new initializeWithBitmap: 0 children: #().
    result1 := node insert: #name value: 'Pharo' hash: #name hash shift: 0 added: [:b | ].
    result1 := result1 insert: #age value: 50 hash: #age hash shift: 0 added: [:b | ].
    
    result2 := result1 remove: #name hash: #name hash shift: 0.
    self assert: (result2 lookup: #name hash: #name hash shift: 0) isNil.
    self assert: (result2 lookup: #age hash: #age hash shift: 0) value equals: 50
]

{ #category : 'tests' }
ImmutableHAMTTest >> testBitmapNodeSingleEntry [

	| node result |
	node := HAMTBitmapNode new initializeWithBitmap: 0 children: #(  ).
	result := node
		          insert: #name
		          value: 'Pharo'
		          hash: 42
		          shift: 0
		          added: [ :b | self assert: b ].
	self assert: (result isKindOf: HAMTBitmapNode).
	self assert: (result lookup: #name hash: 42 shift: 0) value equals: 'Pharo'
]

{ #category : 'tests' }
ImmutableHAMTTest >> testBitmapNodeUpdateExisting [

	| node result1 result2 |
	node := HAMTBitmapNode new initializeWithBitmap: 0 children: #(  ).
	result1 := node
		           insert: #name
		           value: 'Pharo'
		           hash: #name hash
		           shift: 0
		           added: [ :b | self assert: b ].
	result2 := result1
		           insert: #name
		           value: 'Pharo14'
		           hash: #name hash
		           shift: 0
		           added: [ :b | self deny: b ].
	self assert: (result2 lookup: #name hash: #name hash shift: 0) value equals: 'Pharo14'.
	self deny: result1 identicalTo: result2
]

{ #category : 'tests' }
ImmutableHAMTTest >> testCollisionNodeCreation [
    | node |
    node := HAMTCollisionNode new 
        initializeWithHash: 42 
        leaves: {
            HAMTLeafNode new initializeWithHash: 42 key: #a value: 1.
            HAMTLeafNode new initializeWithHash: 42 key: #b value: 2 }.
    self assert: (node lookup: #a hash: 42 shift: 0) value equals: 1.
    self assert: (node lookup: #b hash: 42 shift: 0) value equals: 2.
    self assert: (node lookup: #c hash: 42 shift: 0) isNil.
    self assert: (node lookup: #a hash: 99 shift: 0) isNil
]

{ #category : 'tests' }
ImmutableHAMTTest >> testCollisionNodeInsertNewKey [

	| node result |
	node := HAMTCollisionNode new initializeWithHash: 42 leaves: { (HAMTLeafNode new initializeWithHash: 42 key: #a value: 1) }.
	result := node
		          insert: #b
		          value: 2
		          hash: 42
		          shift: 0
		          added: [ :b | self assert: b ].
	self assert: (result isKindOf: HAMTCollisionNode).
	self assert: (result lookup: #b hash: 42 shift: 0) value equals: 2
]

{ #category : 'tests' }
ImmutableHAMTTest >> testCollisionNodeRemoveLast [
    | node result |
    node := HAMTCollisionNode new 
        initializeWithHash: 42 
        leaves: {HAMTLeafNode new initializeWithHash: 42 key: #a value: 1}.
    result := node remove: #a hash: 42 shift: 0.
    self assert: result isNil
]

{ #category : 'tests' }
ImmutableHAMTTest >> testCollisionNodeRemoveToLeaf [
    | node result |
    node := HAMTCollisionNode new 
        initializeWithHash: 42 
        leaves: {
            HAMTLeafNode new initializeWithHash: 42 key: #a value: 1.
            HAMTLeafNode new initializeWithHash: 42 key: #b value: 2 }.
    result := node remove: #b hash: 42 shift: 0.
    self assert: (result isKindOf: HAMTLeafNode).
    self assert: result key equals: #a.
    self assert: result value equals: 1
]

{ #category : 'tests' }
ImmutableHAMTTest >> testDeepStructuralSharing [
    | original updated |
    original := HAMTBitmapNode new initializeWithBitmap: 0 children: #().
    1 to: 1000 do: [:i | original := original insert: i value: i hash: i hash shift: 0 added: [:b | ]].
    
    updated := original insert: 1001 value: 1001 hash: 1001 hash shift: 0 added: [:b | ].
    
    "Most internal nodes should be shared"
    self assert: (original lookup: 500 hash: 500 hash shift: 0) value equals: 500.
    self assert: (updated lookup: 500 hash: 500 hash shift: 0) value equals: 500.
]

{ #category : 'tests' }
ImmutableHAMTTest >> testEmptyKey [
    | node result |
    node := HAMTBitmapNode new initializeWithBitmap: 0 children: #().
    result := node insert: '' value: 'empty' hash: '' hash shift: 0 added: [:b | ].
    self assert: (result lookup: '' hash: '' hash shift: 0) value equals: 'empty'

]

{ #category : 'tests' }
ImmutableHAMTTest >> testLargeNumberOfEntries [
    | node result |
    node := HAMTBitmapNode new initializeWithBitmap: 0 children: #().
    1 to: 10000 do: [:i | node := node insert: i value: i * 2 hash: i hash shift: 0 added: [:b | ]].
    
    1 to: 10000 do: [:i |
        result := node lookup: i hash: i hash shift: 0.
        self assert: result value equals: i * 2]
]

{ #category : 'tests' }
ImmutableHAMTTest >> testLeafNodeCreation [
    | leaf |
    leaf := HAMTLeafNode new 
        initializeWithHash: 42 key: #name value: 'Pharo'.
    self assert: leaf key equals: #name.
    self assert: leaf value equals: 'Pharo'
]

{ #category : 'tests' }
ImmutableHAMTTest >> testLeafNodeDo [
    | leaf results |
    leaf := HAMTLeafNode new initializeWithHash: 42 key: #name value: 'Pharo'.
    results := OrderedCollection new.
    leaf do: [:each | results add: each].
    self assert: results size equals: 1.
    self assert: results first key equals: #name.
    self assert: results first value equals: 'Pharo'
]

{ #category : 'tests' }
ImmutableHAMTTest >> testLeafNodeInsertDifferentHash [

	| leaf result |
	leaf := HAMTLeafNode new initializeWithHash: 42 key: #name value: 'Pharo'.
	result := leaf
		          insert: #age
		          value: 50
		          hash: 99
		          shift: 0
		          added: [ :b | self assert: b ].
	self assert: (result isKindOf: HAMTBitmapNode).
	self assert: (result lookup: #name hash: 42 shift: 0) value equals: 'Pharo'.
	self assert: (result lookup: #age hash: 99 shift: 0) value equals: 50
]

{ #category : 'tests' }
ImmutableHAMTTest >> testLeafNodeInsertDifferentKeySameHash [

	| leaf result |
	leaf := HAMTLeafNode new initializeWithHash: 42 key: #name value: 'Pharo'.
	result := leaf
		          insert: #eman
		          value: 'Other'
		          hash: 42
		          shift: 0
		          added: [ :b | self assert: b ].
	self assert: (result isKindOf: HAMTCollisionNode).
	self assert: (result lookup: #name hash: 42 shift: 0) value equals: 'Pharo'.
	self assert: (result lookup: #eman hash: 42 shift: 0) value equals: 'Other'
]

{ #category : 'tests' }
ImmutableHAMTTest >> testLeafNodeInsertSameKey [

	| leaf result |
	leaf := HAMTLeafNode new initializeWithHash: 42 key: #name value: 'Pharo'.
	result := leaf
		          insert: #name
		          value: 'Pharo14'
		          hash: 42
		          shift: 0
		          added: [ :b | self deny: b ].
	self assert: result value equals: 'Pharo14'
]

{ #category : 'tests' }
ImmutableHAMTTest >> testLeafNodeIsImmutable [
    | leaf |
    leaf := HAMTLeafNode new initializeWithHash: 42 key: #name value: 'Pharo'.
    self assert: leaf isImmutable
]

{ #category : 'tests' }
ImmutableHAMTTest >> testLeafNodeLookup [
    | leaf |
    leaf := HAMTLeafNode new 
        initializeWithHash: 42 key: #name value: 'Pharo'.
    self assert: (leaf lookup: #name hash: 42 shift: 0) equals: leaf.
    self assert: (leaf lookup: #other hash: 42 shift: 0) isNil.
    self assert: (leaf lookup: #name hash: 99 shift: 0) isNil
]

{ #category : 'tests' }
ImmutableHAMTTest >> testLeafNodeRemove [
    | leaf result |
    leaf := HAMTLeafNode new 
        initializeWithHash: 42 key: #name value: 'Pharo'.
    result := leaf remove: #name hash: 42 shift: 0.
    self assert: result isNil.
    
    result := leaf remove: #other hash: 42 shift: 0.
    self assert: result equals: leaf
]

{ #category : 'tests' }
ImmutableHAMTTest >> testModifyingImmutableNodeRaisesError [
    | leaf |
    leaf := HAMTLeafNode new initializeWithHash: 42 key: #name value: 'Pharo'.
    self should: [leaf instVarAt: 1 put: 99] raise: ModificationForbidden
]

{ #category : 'tests' }
ImmutableHAMTTest >> testNilValue [
    | node result |
    node := HAMTBitmapNode new initializeWithBitmap: 0 children: #().
    result := node insert: #key value: nil hash: #key hash shift: 0 added: [:b | ].
    self assert: (result lookup: #key hash: #key hash shift: 0) value isNil
]

{ #category : 'tests' }
ImmutableHAMTTest >> testRemoveNonExistent [
    | node result |
    node := HAMTBitmapNode new initializeWithBitmap: 0 children: #().
    result := node insert: #a value: 1 hash: #a hash shift: 0 added: [:b | ].
    result := result remove: #b hash: #b hash shift: 0.
    self assert: (result lookup: #a hash: #a hash shift: 0) value equals: 1
]

{ #category : 'tests' }
ImmutableHAMTTest >> testStructuralSharing [
    | original updated |
    original := HAMTBitmapNode new initializeWithBitmap: 0 children: #().
    1 to: 100 do: [:i | original := original insert: i value: i hash: i hash shift: 0 added: [:b | ]].
    
    updated := original insert: 42 value: 99 hash: 42 hash shift: 0 added: [:b | ].
    
    "Original should be unchanged"
    self assert: (original lookup: 42 hash: 42 hash shift: 0) value equals: 42.
    "Updated should have new value"
    self assert: (updated lookup: 42 hash: 42 hash shift: 0) value equals: 99.
    "Different nodes for the path that changed"
    self assert: original ~~ updated
]
