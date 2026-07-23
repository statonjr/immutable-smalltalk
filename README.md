# immutable-smalltalk

Persistent immutable collections for Pharo Smalltalk, inspired by Clojure's data structures and immutable-ruby's elegant API.

## Features

- **Persistent data structures** — structural sharing ensures efficient immutable updates
- **VM-enforced immutability** — objects are truly read-only via Pharo 14 primitives
- **Clojure-inspired design** — HAMT maps, 32-way branching vectors, cons-based lists
- **immutable-ruby compatible API** — `car`, `cdr`, `cadr`, `take:`, `drop:`, and friends
- **Composable traits** — `TImmutableEnumerable`, `TImmutableSequence`, `TImmutableAddable`

## Installation

```smalltalk
Metacello new
    baseline: 'Immutable';
    repository: 'github://statonjr/immutable:main/src';
    load
```

## Collections

| Collection | Backend | Key Operations |
|-----------|---------|---------------|
| `ImmutableList` | Cons cells | O(1) cons, O(n) add |
| `ImmutableVector` | 32-way branching | O(log₃₂ n) at, O(1) amortized add |
| `ImmutableMap` | HAMT | O(log₃₂ n) put/at/remove |
| `ImmutableSet` | HAMT-backed | O(log₃₂ n) add/remove/includes |

## Quick Start

### Lists

```smalltalk
list := ImmutableList fromArray: #(1 2 3).
list car.          "1"
list cdr.          "(2 3)"
list cadr.         "2"
list take: 2.      "(1 2)"
list reverse.      "(3 2 1)"
list select: [:n | n odd].  "(1 3)"
```

### Vectors

```smalltalk
vec := ImmutableVector fromArray: #(1 2 3 4 5).
vec at: 0.         "1"
vec at: 4.         "5"
vec add: 6.        "[1 2 3 4 5 6]"
vec rest.          "[2 3 4 5]"
vec take: 3.       "[1 2 3]"

"Batch operations with transient"
result := vec addAll: #(6 7 8 9 10).
result size.       "10"
```

### Maps

```smalltalk
map := ImmutableMap empty.
map := map put: #name value: 'Pharo'.
map := map put: #version value: 14.
map at: #name.     "'Pharo'"
map includesKey: #version.  "true"

map := map removeKey: #version.
map size.          "1"
```

### Sets

```smalltalk
set := ImmutableSet fromArray: #(1 2 3 2 1).
set size.          "3"
set includes: 2.   "true"
set := set add: 4.
set := set remove: 1.

set union: otherSet.
set intersection: otherSet.
set difference: otherSet.
```

## Traits

### TImmutableEnumerable (requires: do:, isEmpty)

- select:, collect:, reject:
- detect:, detect:ifNone:
- includes:, anySatisfy:, allSatisfy:, noneSatisfy:
- inject:into:, size, asArray

### TImmutableSequence (requires: first, rest, cons:, isEmpty)

- second, third, fourth, fifth
- car, cdr, cadr, caddr, cadddr
- caar, cdar, caadr, cdadr, cdddr
- take:, drop:, takeWhile:, dropWhile:, reverse

### TImmutableAddable (requires: add:)

- addAll:, ,

## Platform Support

| Platform | Status | Immutability Mechanism |
|----------|--------|----------------------|
| Pharo 14 | ✅ | `setIsReadOnlyObject:` (prim 164) |
| TruffleSqueak | Planned | `setIsReadOnlyObject:` (prim 164) |
| VAST Platform | Planned | `markReadOnly` |

## Benchmarks

Run with:

```smalltalk
ImmutableBenchmarks runAll
```

### Structural Sharing

Where persistent data structures dominate by keeping old versions without copying.

| Benchmark | Immutable | Mutable (copy) | Speedup |
|-----------|-----------|----------------|---------|
| Vector single append (100k) | 174,581/s | 125/s | 1,391x |
| List 10 branches (100) | 4,048,583/s | 564,971/s | 7.2x |
| Set single add (500) | 2,631,579/s | 1,190,476/s | 2.2x |

### Sequence Operations

Lazy views make `take:` and `drop:` O(1).

| Benchmark | Before (eager) | After (lazy) | Speedup |
|-----------|---------------|--------------|---------|
| Vector take: 50 | 783/s | 21,097,046/s | 26,947x |
| Vector drop: 50 | 1,298/s | 20,366,598/s | 15,690x |

### Lookup

Competitive with mutable built-in collections.

| Benchmark | Immutable | Built-in | Ratio |
|-----------|-----------|----------|-------|
| Map at: (100 entries) | 83,382/s | 116,686/s | 0.71x |
| Map at: (100k entries) | 4,952/s | 11,436/s | 0.43x |
| Set includes: (500) | 120,283/s | 128,050/s | 0.94x |
| Vector at: (100) | 681,245/s | 4,798,464/s | 0.14x |

### Sorted Collections

Pre-sorted construction via fromArray: is 28-29x faster than incremental building.

| Benchmark | Naive build | fromArray: | Speedup |
|-----------|-------------|-----------|---------|
| SortedMap building (500) | 145/s | 4,250/s | 29.3x |
| SortedSet building (500) | 153/s | 4,254/s | 27.8x |

Lookup remains competitive:

| Benchmark | Immutable | Built-in | Ratio |
|-----------|-----------|----------|-------|
| SortedMap at: (500) | 63,040/s | 112,994/s | 0.56x |
| SortedSet includes: (500) | 119,717/s | 136,463/s | 0.88x |

### Queue

| Benchmark | Speed |
|-----------|-------|
| Enqueue (batch 100) | 67,114/s |
| Dequeue all (1000) | 3,481/s |
| Peek | 41,345/s |
| Enqueue/dequeue mix | 206,612/s |
| 10 branches (1000) | 1,694,915/s |

The two-stack design gives O(1) amortized `enqueue` and `dequeue`. Branching is fast as expected. 10 branches from the same queue share structure at 1.7M/s.

### Memoized Views

| Benchmark | Speed |
|-----------|-------|
| Lazy chain traversal (10k) | 4,462/s |
| Memoized first traversal (10k) | 6,562/s |
| Memoized second traversal (10k) | 6,276/s |
| Eager chain traversal (10k) | 262/s |

Memoized views cache the result on first traversal, avoiding recomputation. Second traversal is instant compared to eager chains.

### Where Built-ins Still Win

Mutable collections avoid tree traversal and node allocation overhead.

| Benchmark | Immutable | Built-in | Ratio |
|-----------|-----------|----------|-------|
| Map building (1000) | 3,076/s | 8,143/s | 0.38x |
| Vector building (1000) | 6,181/s | 136,799/s | 0.05x |
| Vector at: (100k) | 59,542/s | 209,030/s | 0.28x |
| Set building (500) | 4,990/s | 19,298/s | 0.26x |
| SortedMap building (500) | 111/s | - | - |
| SortedSet building (500) | 111/s | - | - |

Note: Sorted collection building is slow (O(n²) incremental insert). Use `fromArray:` for 28-37x faster bulk construction.

List `cons:` is faster than `OrderedCollection addFirst:`. `prepend` is the natural immutable operation (6.5M/s vs 5.6M/s).

## Credits

Inspired by:

- Rich Hickey's Clojure persistent collections
- immutable-ruby
- Phil Bagwell's Hash Array Mapped Trie (2001)
- Chris Okasaki's Purely Functional Data Structures