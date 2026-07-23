Class {
	#name : 'ImmutableBenchmarks',
	#superclass : 'SMarkSuite',
	#category : 'Immutable-Benchmarks',
	#package : 'Immutable-Benchmarks'
}

{ #category : 'comparing' }
ImmutableBenchmarks class >> compare: labelA block: blockA with: labelB block: blockB iterations: n [
    | resultA resultB ratio |
    resultA := self run: labelA iterations: n block: blockA.
    resultB := self run: labelB iterations: n block: blockB.
    ratio := resultB period / resultA period.
    Transcript
        show: '  Ratio: ';
        show: (ratio asFloat roundTo: 0.01) printString;
        show: 'x (';
        show: (ratio > 1 ifTrue: ['Immutable faster'] ifFalse: ['Built-in faster']);
        show: ')';
        cr; cr
]

{ #category : 'running' }
ImmutableBenchmarks class >> run: label iterations: n block: aBlock [
    | start elapsed result |
    start := DateAndTime now.
    n timesRepeat: aBlock.
    elapsed := DateAndTime now - start.
    result := BenchmarkResult new
        iterations: n;
        elapsedTime: elapsed;
        yourself.
    Transcript
        show: label;
        show: ': ';
        show: result printString;
        cr.
    ^ result
]

{ #category : 'running' }
ImmutableBenchmarks class >> runAll [
	self runLazyViewBenchmarks.
	self runListBenchmarks.
	self runMapBenchmarks.
	self runSetBenchmarks.
	self runVectorBenchmarks.
]

{ #category : 'running' }
ImmutableBenchmarks class >> runLazyViewBenchmarks [
    | vec |
    
    Transcript show: '=== Lazy View Benchmarks ==='; cr.
    
    vec := ImmutableVector fromArray: (1 to: 10000) asArray.
    
    "Lazy chain — views stacked, no copying"
    self run: '  Lazy view chain (10k, 5 ops)    ' iterations: 1000 block: [
        | result |
        result := vec drop: 100.
        result := result take: 5000.
        result := result select: [:n | n even].
        result := result collect: [:n | n * 10].
        result first].
    
    "Eager chain — each step realizes"
    self run: '  Eager chain (10k, 5 ops)       ' iterations: 100 block: [
        | result |
        result := vec.
        result := result drop: 100.
        result := result take: 5000.
        result := result select: [:n | n even].
        result := result collect: [:n | n * 10].
        result first].
    
    Transcript cr.
    
    "Lazy: access just first element after chain"
    self run: '  Lazy chain + first only (10k)  ' iterations: 10000 block: [
        | result |
        result := vec drop: 100; take: 5000; select: [:n | n even]; collect: [:n | n * 10].
        result first].
    
    "Lazy: realize entire chain"
    self run: '  Lazy chain + full realize (10k) ' iterations: 10 block: [
        | result sum |
        result := vec drop: 100; take: 5000; select: [:n | n even]; collect: [:n | n * 10].
        sum := 0.
        result do: [:each | sum := sum + each]].
    
    "Eager: full realization"
    self run: '  Eager chain + full realize (10k)' iterations: 10 block: [
        | result sum |
        result := vec.
        result := result drop: 100.
        result := result take: 5000.
        result := result select: [:n | n even].
        result := result collect: [:n | n * 10].
        sum := 0.
        result do: [:each | sum := sum + each]]
]

{ #category : 'running' }
ImmutableBenchmarks class >> runListBenchmarks [
    | smallList smallArray |
    
    Transcript show: '=== List Benchmarks ==='; cr.
    
    smallList := ImmutableList fromArray: (1 to: 100) asArray.
    smallArray := (1 to: 100) asArray.
    
    "Prepend"
    self run: '  ImmutableList cons: 10            ' iterations: 10000 block: [
        | l |
        l := smallList.
        1 to: 10 do: [:i | l := l cons: i]].
    
    self run: '  OrderedCollection addFirst: 10    ' iterations: 10000 block: [
        | oc |
        oc := smallArray asOrderedCollection.
        1 to: 10 do: [:i | oc addFirst: i]].
    
    Transcript cr.
    
    "Sequence operations"
    self run: '  ImmutableList take: 50             ' iterations: 10000 block: [
        smallList take: 50].
    
    self run: '  ImmutableList drop: 50             ' iterations: 10000 block: [
        smallList drop: 50].
    
    self run: '  ImmutableList reverse              ' iterations: 10000 block: [
        smallList reverse].
    
    self run: '  Array reverse (copy)               ' iterations: 10000 block: [
        smallArray reverse].
    
    Transcript cr.
    
    "Car/cdr chain"
    self run: '  ImmutableList car/cdr chain (10)   ' iterations: 10000 block: [
        | l |
        l := smallList.
        1 to: 10 do: [:i | l := l cdr].
        l car].
    
    Transcript cr.
    
    "Structural sharing: branching"
    self run: '  ImmutableList 10 branches (100)   ' iterations: 1000 block: [
        | branches |
        branches := (1 to: 10) collect: [:i | smallList cons: i]].
    
    self run: '  Array 10 copies (100)             ' iterations: 100 block: [
        | copies |
        copies := (1 to: 10) collect: [:i | | a |
            a := smallArray copy.
            a := {i}, a]].
]

{ #category : 'running' }
ImmutableBenchmarks class >> runMapBenchmarks [
    | smallImmutable largeImmutable smallDict largeDict keys |
    
    Transcript show: '=== Map Benchmarks ==='; cr.
    
    smallImmutable := ImmutableMap empty.
    1 to: 100 do: [:i | smallImmutable := smallImmutable put: i value: i * 2].
    smallDict := Dictionary new.
    1 to: 100 do: [:i | smallDict at: i put: i * 2].
    
    largeImmutable := ImmutableMap empty.
    1 to: 100000 do: [:i | largeImmutable := largeImmutable put: i value: i * 2].
    largeDict := Dictionary new.
    1 to: 100000 do: [:i | largeDict at: i put: i * 2].
    
    keys := (1 to: 100) asArray.
    
    self compare: '  ImmutableMap at: (100)' block: [keys do: [:k | smallImmutable at: k]]
        with: '  Dictionary at: (100)   ' block: [keys do: [:k | smallDict at: k]]
        iterations: 1000.
    
    keys := (1 to: 1000) collect: [:i | (i * 97) % 100000 + 1].
    self compare: '  ImmutableMap at: (100k)' block: [keys do: [:k | largeImmutable at: k]]
        with: '  Dictionary at: (100k)   ' block: [keys do: [:k | largeDict at: k]]
        iterations: 100.
    
    self run: '  ImmutableMap building (1000)' iterations: 10 block: [
        | m |
        m := ImmutableMap empty.
        1 to: 1000 do: [:i | m := m put: i value: i]].
    self run: '  Dictionary building (1000)   ' iterations: 10 block: [
        | d |
        d := Dictionary new.
        1 to: 1000 do: [:i | d at: i put: i]]
]

{ #category : 'running' }
ImmutableBenchmarks class >> runSetBenchmarks [
    | immSet smallSet items |
    
    Transcript show: '=== Set Benchmarks ==='; cr.
    
    immSet := ImmutableSet fromArray: (1 to: 500) asArray.
    smallSet := (1 to: 500) asSet.
    items := (1 to: 100) asArray.
    
    "Lookup"
    self compare: '  ImmutableSet includes:          ' block: [
        items do: [:i | immSet includes: i]]
        with: '  Set includes:                   ' block: [
        items do: [:i | smallSet includes: i]]
        iterations: 10000.
    
    "Building"
    self compare: '  ImmutableSet building (500)   ' block: [
        | s |
        s := ImmutableSet empty.
        1 to: 500 do: [:i | s := s add: i]]
        with: '  Set building (500)             ' block: [
        | s |
        s := Set new.
        1 to: 500 do: [:i | s add: i]]
        iterations: 100.
    
    "Set operations"
    self run: '  ImmutableSet union                ' iterations: 1000 block: [
        immSet union: (ImmutableSet fromArray: (400 to: 900) asArray)].
    
    self run: '  ImmutableSet intersection         ' iterations: 1000 block: [
        immSet intersection: (ImmutableSet fromArray: (400 to: 900) asArray)].
    
    self run: '  ImmutableSet difference           ' iterations: 1000 block: [
        immSet difference: (ImmutableSet fromArray: (400 to: 900) asArray)].
    
    Transcript cr.
    
    "Structural sharing: single add"
    self run: '  ImmutableSet single add (500)     ' iterations: 1000 block: [
        immSet add: 999].
    
    self run: '  Set copy + add (500)             ' iterations: 100 block: [
        | s2 |
        s2 := smallSet copy.
        s2 add: 999]
]

{ #category : 'running' }
ImmutableBenchmarks class >> runStructuralSharingBenchmarks [
    | immMap largeDict immBranches dictCopies |
    
    Transcript show: '=== Structural Sharing Benchmarks ==='; cr.
    
    immMap := ImmutableMap empty.
    1 to: 10000 do: [:i | immMap := immMap put: i value: i].
    largeDict := Dictionary new.
    1 to: 10000 do: [:i | largeDict at: i put: i].
    
    "Immutable: change one key, keep old version"
    self run: '  ImmutableMap single update (10k)  ' iterations: 1000 block: [
        | m2 |
        m2 := immMap put: 5000 value: #changed.
        m2 at: 5000].
    
    "Mutable: must copy entire dictionary first"
    self run: '  Dictionary copy + update (10k)    ' iterations: 100 block: [
        | d2 |
        d2 := largeDict copy.
        d2 at: 5000 put: #changed.
        d2 at: 5000].
    
    Transcript cr.
    
    "Branching: create multiple versions"
    self run: '  ImmutableMap 10 branches (10k)    ' iterations: 100 block: [
        | branches |
        branches := (1 to: 10) collect: [:i | immMap put: 5000 value: i]].
    
    self run: '  Dictionary 10 copies (10k)        ' iterations: 10 block: [
        | copies |
        copies := (1 to: 10) collect: [:i | | d |
            d := largeDict copy.
            d at: 5000 put: i.
            d]].
    
    Transcript cr.
    
    "Memory: compare size of 10 branches"
    immBranches := (1 to: 10) collect: [:i | immMap put: 5000 value: i].
    dictCopies := (1 to: 10) collect: [:i | | d |
        d := largeDict copy.
        d at: 5000 put: i.
        d].
    
    Transcript
        show: '  ImmutableMap 10 branches size: ';
        show: (immBranches inject: 0 into: [:sum :m | sum + m size]) printString;
        cr.
    Transcript
        show: '  Dictionary 10 copies size:     ';
        show: (dictCopies inject: 0 into: [:sum :d | sum + d size]) printString;
        cr.
]

{ #category : 'running' }
ImmutableBenchmarks class >> runVectorBenchmarks [
    | smallVec smallArray largeVec largeArray |
    
    Transcript show: '=== Vector Benchmarks ==='; cr.
    
    smallVec := ImmutableVector fromArray: (1 to: 100) asArray.
    smallArray := (1 to: 100) asArray.
    largeVec := ImmutableVector fromArray: (1 to: 100000) asArray.
    largeArray := (1 to: 100000) asArray.
    
    "Random access"
    self compare: '  ImmutableVector at: (100)     ' block: [
        1 to: 100 do: [:i | smallVec at: i - 1]]
        with: '  Array at: (100)                ' block: [
        1 to: 100 do: [:i | smallArray at: i]]
        iterations: 10000.
    
    self compare: '  ImmutableVector at: (100k)    ' block: [
        1 to: 1000 do: [:i | largeVec at: (i * 97) % 100000]]
        with: '  Array at: (100k)               ' block: [
        1 to: 1000 do: [:i | largeArray at: ((i * 97) % 100000) + 1]]
        iterations: 1000.
    
    "Building"
    self compare: '  ImmutableVector building (1000)' block: [
        | v |
        v := ImmutableVector empty.
        1 to: 1000 do: [:i | v := v add: i]]
        with: '  OrderedCollection building (1000)' block: [
        | oc |
        oc := OrderedCollection new.
        1 to: 1000 do: [:i | oc add: i]]
        iterations: 100.
    
    "Transient batch building"
    self run: '  ImmutableVector transient (10k)  ' iterations: 10 block: [
        | v t |
        v := ImmutableVector empty.
        t := ImmutableVectorTransient from: v.
        1 to: 10000 do: [:i | t add: i].
        v := t persistent].
    
    "Sequence operations"
    self run: '  ImmutableVector take: 50 (100)   ' iterations: 10000 block: [
        smallVec take: 50].
    
    self run: '  ImmutableVector drop: 50 (100)   ' iterations: 10000 block: [
        smallVec drop: 50].
    
    Transcript cr.
    
    "Structural sharing: single append"
    self run: '  ImmutableVector single append (100k)' iterations: 1000 block: [
        largeVec add: 99999].
    
    self run: '  Array copy + add (100k)            ' iterations: 100 block: [
        | a2 |
        a2 := largeArray copy.
        a2 := a2, #(99999)].
    
    Transcript cr.
]
