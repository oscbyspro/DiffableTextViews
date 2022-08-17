//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Commit
//*============================================================================*

/// A value, a snapshot and an optional selection.
///
/// Commits update the state of interactive diffable text views.
///
/// ```
/// |+|1|2|_|(|3|4|5|)|_|6|7|8|-|9|#|-|#|#|~
/// |x|o|o|x|x|o|o|o|x|x|o|o|o|x|o|x|x|x|x|~
/// ```
///
/// **Selection**
///
/// Selection is done by differentiation, but it can also be done manually.
/// Commits containing only passthrough characters should always provide a
/// selection, however. A pattern text style may select its first placeholder
/// character, as illustrated:
///
/// ```
///   ↓ == selection
/// |+|#|#|_|(|#|#|#|)|_|#|#|#|-|#|#|-|#|#|~
/// |x|x|x|x|x|x|x|x|x|x|x|x|x|x|x|x|x|x|x|~
/// ```
///
public struct Commit<Value: Equatable>: Equatable {
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var value:     Value
    public var snapshot:  Snapshot
    public var selection: Selection<Index>?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ value: Value, _ snapshot: Snapshot) {
        self.value = value;  self.snapshot = snapshot
    }
    
    @inlinable public init() where Value: RangeReplaceableCollection {
        self.init(Value(), Snapshot())
    }
    
    @inlinable public init<T>() where Value == Optional<T> {
        self.init(nil, Snapshot())
    }
    
    @inlinable public init<T>(_ commit: Commit<T>) where Value == Optional<T> {
        self.init(commit.value, commit.snapshot)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func select(_ index: (Snapshot) -> Index) {
        self.selection = Selection(index(snapshot))
    }
    
    @inlinable public mutating func select(_ range: (Snapshot) -> Range<Index>) {
        self.selection = Selection(range(snapshot))
    }
}
