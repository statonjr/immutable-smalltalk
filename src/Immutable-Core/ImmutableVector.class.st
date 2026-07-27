"
I am an immutable persistent vector using 32-way branching with structural sharing.
 
O(log₃₂ n) random access via at:, O(1) amortized append via add:. Use ImmutableVectorTransient for efficient batch operations.
 
I implement the TImmutableSequence trait providing Lisp-style accessors: car, cdr, cadr, caddr, take:, drop:, reverse, etc.
 
Inspired by Clojure's PersistentVector and immutable-ruby's Immutable::Vector.
"
Class {
	#name : 'ImmutableVector',
	#superclass : 'ImmutableObject',
	#traits : 'TImmutableSequence + TImmutableAddable + TImmutableEnumerable',
	#classTraits : 'TImmutableSequence classTrait + TImmutableAddable classTrait + TImmutableEnumerable classTrait',
	#instVars : [
		'shift',
		'size',
		'root',
		'tail'
	],
	#classVars : [
		'EmptyVector'
	],
	#category : 'Immutable-Core',
	#package : 'Immutable-Core'
}

{ #category : 'enumerating' }
ImmutableVector class >> bitShift [
    ^ 5
]

{ #category : 'enumerating' }
ImmutableVector class >> branchingFactor [
    ^ 32
]

{ #category : 'enumerating' }
ImmutableVector class >> empty [
    EmptyVector ifNil: [EmptyVector := self basicNew initializeEmpty].
    ^ EmptyVector
]

{ #category : 'enumerating' }
ImmutableVector class >> fromArray: anArray [
    | vector |
    vector := self empty.
    anArray do: [:each | vector := vector add: each].
    ^ vector
]

{ #category : 'enumerating' }
ImmutableVector class >> mask [
    ^ 31
]

{ #category : 'enumerating' }
ImmutableVector class >> withAll: aCollection [
    ^ self fromArray: aCollection asArray
]

{ #category : 'enumerating' }
ImmutableVector >> add: anObject [
    | newTail newRoot newSize newShift |

      "Append to the existing tail while it has capacity."
      tail size < self branchingFactor ifTrue: [
         newTail := tail copyWith: anObject.

         ^ self class basicNew
              initializeWithSize: size + 1
              shift: shift
              root: root
              tail: newTail ].

      "The tail is full and must be promoted into the tree."
      newRoot := root.
      newShift := shift.

      "The current root is full. Introduce a new root above it."
      ((size >> self bitShift) > (1 << shift)) ifTrue: [
         newRoot := Array new: self branchingFactor.
         newRoot at: 1 put: root.
         newShift := shift + self bitShift ].

      newRoot := self
                    promoteTail: tail
                    intoRoot: newRoot
                    shift: newShift.

      newTail := Array with: anObject.
      newSize := size + 1.

      ^ self class basicNew
           initializeWithSize: newSize
           shift: newShift
           root: newRoot
           tail: newTail
]

{ #category : 'private' }
ImmutableVector >> asArray [
    | result |
    result := Array new: size.
    0 to: size - 1 do: [:i | result at: i + 1 put: (self at: i)].
    ^ result
]

{ #category : 'accessing' }
ImmutableVector >> at: index [
    ^ self
           at: index
           ifAbsent: [
              SubscriptOutOfBounds
                 signalFor: index
                 lowerBound: 0
                 upperBound: size - 1
                 in: self ]
]

{ #category : 'accessing' }
ImmutableVector >> at: index ifAbsent: absentBlock [

      (index < 0 or: [ index >= size ]) ifTrue: [
         ^ absentBlock value ].

      ^ self atIndex: index
]

{ #category : 'accessing' }
ImmutableVector >> atIndex: index [
    | tailStart |
    tailStart := size - tail size.
    index >= tailStart ifTrue: [
        ^ tail at: index - tailStart + 1].
    ^ self lookupAt: index shift: shift node: root
]

{ #category : 'enumerating' }
ImmutableVector >> bitShift [
    ^ 5
]

{ #category : 'enumerating' }
ImmutableVector >> branchingFactor [
    ^ 32
]

{ #category : 'adding' }
ImmutableVector >> cons: anObject [
    "Prepend — O(n) for vectors, use add: for O(1) append"
    | result |
    result := self class empty.
    result := result add: anObject.
    0 to: size - 1 do: [:i | result := result add: (self at: i)].
    ^ result
]

{ #category : 'private' }
ImmutableVector >> copyFrom: startIndex to: endIndex [
    | result |
    startIndex > endIndex ifTrue: [^ self class empty].
    result := self class empty.
    startIndex to: (endIndex min: size - 1) do: [:i | result := result add: (self at: i)].
    ^ result
]

{ #category : 'enumerating' }
ImmutableVector >> do: aBlock [
    0 to: size - 1 do: [:i | aBlock value: (self at: i)]
]

{ #category : 'accessing' }
ImmutableVector >> drop: n [
    n <= 0 ifTrue: [^ self].
    n >= size ifTrue: [^ self class empty].
    ^ ImmutableSubVector on: self from: n size: size - n
]

{ #category : 'enumerating' }
ImmutableVector >> empty [
    EmptyVector ifNil: [EmptyVector := self basicNew initializeEmpty].
    ^ EmptyVector
]

{ #category : 'enumerating' }
ImmutableVector >> first [
    size = 0 ifTrue: [^ nil].
    ^ self atIndex: 0
]

{ #category : 'enumerating' }
ImmutableVector >> fromArray: anArray [
    | vector |
    vector := self empty.
    anArray do: [:each | vector := vector add: each].
    ^ vector
]

{ #category : 'enumerating' }
ImmutableVector >> initializeEmpty [
    size := 0.
    shift := 5.
    root := Array new: 32.
    tail := Array new: 0.
    self makeImmutable
]

{ #category : 'enumerating' }
ImmutableVector >> initializeWithSize: aSize shift: aShift root: aRoot tail: aTail [
    size := aSize.
    shift := aShift.
    root := aRoot.
    tail := aTail.
    self makeImmutable
]

{ #category : 'private' }
ImmutableVector >> insertElement: element intoRoot: aRoot atIndex: index shift: currentShift [
    | subIndex child newNode newRoot |
    currentShift = 0 ifTrue: [
        "At leaf level — store the element"
        newRoot := aRoot copy.
        newRoot at: index + 1 put: element.
        ^ newRoot].
    
    subIndex := ((index >> currentShift) bitAnd: 31) + 1.
    child := aRoot at: subIndex ifAbsent: [nil].
    child ifNil: [child := Array new: 32].
    
    newNode := self 
        insertElement: element 
        intoRoot: child 
        atIndex: (index bitAnd: (1 << currentShift) - 1) 
        shift: currentShift - 5.
    
    newRoot := aRoot copy.
    newRoot at: subIndex put: newNode.
    ^ newRoot
]

{ #category : 'accessing' }
ImmutableVector >> isEmpty [
    ^ size = 0
]

{ #category : 'accessing' }
ImmutableVector >> lookupAt: index shift: currentShift node: node [
    | childIndex |
    currentShift > 0 ifTrue: [
        childIndex := ((index >> currentShift) bitAnd: 31) + 1.
        ^ self 
            lookupAt: (index bitAnd: (1 << currentShift) - 1)
            shift: currentShift - 5
            node: (node at: childIndex)].
    ^ node at: index + 1
]

{ #category : 'enumerating' }
ImmutableVector >> mask [
    ^ 31
]

{ #category : 'printing' }
ImmutableVector >> printOn: aStream [
    aStream nextPutAll: 'ImmutableVector['.
    0 to: size - 1 do: [:i |
        i > 0 ifTrue: [aStream nextPutAll: ', '].
        (self at: i) printOn: aStream].
    aStream nextPut: $]
]

{ #category : 'private' }
ImmutableVector >> promoteTail: aTail intoRoot: aRoot shift: aShift [
		| newRoot tailStart |
      newRoot := aRoot.
      tailStart := size - aTail size.

      aTail doWithIndex: [ :element :i |
         newRoot := self
                       insertElement: element
                       intoRoot: newRoot
                       atIndex: tailStart + i - 1
                       shift: aShift ].

      ^ newRoot
]

{ #category : 'enumerating' }
ImmutableVector >> rest [
    size <= 1 ifTrue: [^ self class empty].
    ^ self copyFrom: 1 to: size - 1
]

{ #category : 'accessing' }
ImmutableVector >> size [
    ^ size
]

{ #category : 'private' }
ImmutableVector >> species [
    ^ ImmutableVector
]

{ #category : 'enumerating' }
ImmutableVector >> tailOffset [
    ^ size - tail size
]

{ #category : 'accessing' }
ImmutableVector >> take: n [
    n <= 0 ifTrue: [^ self class empty].
    n >= size ifTrue: [^ self].
    ^ ImmutableSubVector on: self from: 0 size: n
]

{ #category : 'enumerating' }
ImmutableVector >> withAll: aCollection [
    ^ self fromArray: aCollection asArray
]
