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

## Credits

Inspired by:

- Rich Hickey's Clojure persistent collections
- immutable-ruby
- Phil Bagwell's Hash Array Mapped Trie (2001)
- Chris Okasaki's Purely Functional Data Structures