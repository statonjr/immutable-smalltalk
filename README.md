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
    repository: 'github://statonjr/immutable-smalltalk:main/src';
    load
```

```smalltalk
"Load tests"
Metacello new
    baseline: 'Immutable';
    repository: 'github://statonjr/immutable-smalltalk:main/src';
    load: 'Tests'
```

```smalltalk
"Load benchmarks and SMark"
Metacello new
    baseline: 'Immutable';
    repository: 'github://statonjr/immutable-smalltalk:main/src';
    load: 'Benchmarks'
```

## Collections

| Collection | Backend | Key Operations |
|-----------|---------|---------------|
| `ImmutableList` | Cons cells | O(1) cons, O(n) add |
| `ImmutableVector` | 32-way branching | O(log₃₂ n) at, O(1) amortized add |
| `ImmutableMap` | HAMT | O(log₃₂ n) put/at/remove |
| `ImmutableSet` | HAMT-backed | O(log₃₂ n) add/remove/includes |
| `ImmutableSortedMap` | HAMT + sorted keys | O(log₃₂ n) lookup, ordered traversal |
| `ImmutableSortedSet` | HAMT + sorted keys | O(log₃₂ n) lookup, ordered traversal |
| `ImmutableQueue` | Normalized two-list queue | O(1) enqueue/peek, O(1) amortized dequeue under linear use |

## API Conventions

### Equality and hashing

Immutable collections use value equality within their semantic families:

- Lists, Vectors, SubVectors, and lazy/memoized sequence views compare by elements and order.
- Maps and SortedMaps compare by key/value mappings, independent of traversal order.
- Sets and SortedSets compare by membership, independent of traversal order.
- Queues compare by FIFO order and only compare equal to other Queues.

Immutable collections do not compare equal to Pharo's mutable built-in collections. Equal immutable collections always produce equal hashes and may be used interchangeably as Dictionary keys.

### Indexing

`ImmutableList`, `ImmutableVector`, and `ImmutableSubVector` use
**zero-based indexes**, following their Clojure-inspired API rather than
Smalltalk's usual one-based collection convention.

- `at:` signals `SubscriptOutOfBounds` when the index is invalid.
- `at:ifAbsent:` evaluates its block when the index is invalid.
- Map `at:` messages use keys rather than numeric positions.

### Nil values

Collections support `nil` elements and map values.

Use `isEmpty` to distinguish an empty sequence from a sequence whose first
element is `nil`. `detect:` signals `NotFound` when no element matches;
`detect:ifNone:` evaluates its fallback only when no element matches.

### Ordering

Lists and vectors preserve sequence order. Map and Set traversal order is
unspecified and may change between versions. SortedMap and SortedSet use
natural ordering through `<`.

### Map snapshots

`ImmutableMap>>keys` and `ImmutableMap>>values` return detached Arrays.
Mutating these snapshots does not mutate the map.

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

### SortedMaps

```smalltalk
sorted := ImmutableSortedMap fromArray: {#c -> 3. #a -> 1. #b -> 2}.
sorted keys.       "#(#a #b #c)"
sorted first.      "#a -> 1"
sorted last.       "#c -> 3"
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

### SortedSets

```smalltalk
sorted := ImmutableSortedSet fromArray: #(3 1 2).
sorted asArray.    "#(1 2 3)"
sorted first.      "1"
sorted last.       "3"
```

### Queues

```smalltalk
queue := ImmutableQueue empty.
queue := queue enqueue: 1.
queue := queue enqueue: 2.
queue := queue enqueue: 3.
result := queue dequeue.  "{1. queue(2 3)}"
queue peek.               "1"
```

### Memoization

```smalltalk
view := vec take: 4.
lazy := view select: [ :n | n even ].
lazy := lazy collect: [ :n | n * 10 ].

"memoize traverses the source and caches it immediately."
memoized := lazy memoize.

memoized do: [ :each | ... ].  "Reads cache"
memoized do: [ :each | ... ].  "Reads the same cache"
```

`select:`, `collect:`, and `reject:` sent directly to an `ImmutableVector` are eager. `take:` and `drop:` can produce an `ImmutableSubVector`. Sequence transformations sent to that view remain lazy.

`memoize` eagerly traverses a lazy view and stores its result for repeated traversal.

## Traits

### TImmutableEnumerable

#### Requires

- `do:`, `isEmpty`

#### Provides

- `select:`, `collect:`, `reject:`
- `detect:`, `detect:ifNone:`
- `includes:`, `anySatisfy:`, `allSatisfy:`, `noneSatisfy:`
- `inject:into:`, `size`, `asArray`

### TImmutableSequence

#### Requires

- `first`, `rest`, `cons:`, `isEmpty`

#### Provides

- `second`, `third`, `fourth`, `fifth`
- `car`, `cdr`, `cadr`, `caddr`, `cadddr`
- `caar`, `cdar`, `caadr`, `cdadr`, `cdddr`
- `take:`, `drop:`, `takeWhile:`, `dropWhile:`, `reverse`

### TImmutableAddable

#### Requires

- `add:`

#### Provides

- `addAll:`, `,`

### TImmutableLazySequence

#### Uses

- `TImmutableSequence`

#### Provides

- `select:`, `collect:`, `reject:`

These methods return lazy views instead of realizing.

## Platform Support

| Platform | Status | Immutability Mechanism |
|----------|--------|----------------------|
| Pharo 14 | ✅ | `setIsReadOnlyObject:` (prim 164) |
| TruffleSqueak | Planned | `setIsReadOnlyObject:` (prim 164) |
| VAST Platform | Planned | `markReadOnly` |

## Benchmarks

Load the benchmark package as described above, then run every suite with:

```smalltalk
ImmutableBenchmarks runAll
 ```

Individual families may be run directly:

```smalltalk
ImmutableQueueBenchmarks runAndReport
```

The benchmark harness uses SMark with two Cog warmup executions and nine
recorded samples. It reports the median, range, spread, operation count, and
operations per second. Fixture construction and correctness validation occur
outside the timed region. Each run also reports its Pharo, VM, operating-system,
runner, and timer environment.

### Publication status

Canonical numeric results are not currently published.

During 1.0 release validation on Pharo 14 snapshot build 733 with VM
v12.0.3-beta, repeated executions produced materially different Pharo built-in
collection baselines without benchmark source changes. The immutable workloads
were generally more stable, but publishing comparison tables before identifying
the source of the baseline variation would imply reproducibility that has not
yet been established.

A dated benchmark report tied to an exact Immutable Collections release, Pharo
build, VM build, operating system, and architecture will be published once the
results are reproducible.

## Credits

Inspired by:

- Rich Hickey's Clojure persistent collections
- immutable-ruby
- Phil Bagwell's Hash Array Mapped Trie (2001)
- Chris Okasaki's Purely Functional Data Structures