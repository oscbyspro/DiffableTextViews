//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Context
//*============================================================================*

/// A set of values describing the state of a diffable text view.
///
/// - Uses copy-on-write semantics.
///
public struct Context<Style: DiffableTextStyle> {
    public typealias Value  = Style.Value
    public typealias Status = DiffableTextKit.Status<Style>
    public typealias Commit = DiffableTextKit.Commit<Value>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline private(set) var _storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ status: Status) {
        switch status.focus == true {
        case  true: self =   .focused(status.style, status.value)
        case false: self = .unfocused(status.style, status.value)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ status: Status, _ layout: Layout) {
        self._storage = Storage(status, layout)
    }
    
    @inlinable static func focused(_ style: Style, _ value: Value) -> Self {
        Self.focused(style, style.interpret(value))
    }
    
    @inlinable static func focused(_ style: Style, _ commit: Commit) -> Self {
        Self(Status(style, commit.value, true), Layout(commit.snapshot))
    }
    
    @inlinable static func unfocused(_ style: Style, _ value: Value) -> Self {
        Self(Status(style, value, false), Layout(Snapshot(style.format(value), as: .phantom)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation
    //=------------------------------------------------------------------------=
    
    /// Writes to storage with copy-on-write behavior.
    @inlinable mutating func write(_ write: (Storage) -> Void) {
        //=--------------------------------------=
        // Unique
        //=--------------------------------------=
        if !isKnownUniquelyReferenced(&_storage) {
            self._storage = self._storage.copy()
        }
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        write(self._storage)
    }
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*
    
    @usableFromInline final class Storage {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var status: Status
        @usableFromInline var layout: Layout
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ status: Status, _ layout: Layout) {
            self.status = status
            self.layout = layout
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func copy() -> Self {
            Self(status, layout)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Accessors
//=----------------------------------------------------------------------------=

extension Context {

    //=------------------------------------------------------------------------=
    // MARK: 1st
    //=------------------------------------------------------------------------=
        
    @inlinable @inline(__always)
    var status: Status {
        _storage.status
    }
    
    @inlinable @inline(__always)
    var layout: Layout {
        _storage.layout
    }
    
    //=------------------------------------------------------------------------=
    // MARK: 2nd
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public var style: Style {
        status.style
    }
    
    @inlinable @inline(__always)
    public var value: Value {
        status.value
    }
    
    @inlinable @inline(__always)
    public var focus: Focus {
        status.focus
    }
    
    //=------------------------------------------------------------------------=
    // MARK: 3rd
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always)
    public var snapshot: Snapshot {
        layout.snapshot
    }
    
    @inlinable @inline(__always)
    public var text: String {
        layout.snapshot.characters
    }
    
    @inlinable @inline(__always)
    public func selection<T>(as position: Position<T>.Type =
    Position<T>.self) -> Range<T.Position> where T: Offset {
        layout.selection().range
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Context
    //=------------------------------------------------------------------------=
        
    @inlinable mutating func merge(_ other: Self) {
        //=--------------------------------------=
        // Active
        //=--------------------------------------=
        if other.focus == true {
            self.write {
                $0.status = other.status
                $0.layout.merge(snapshot: other.snapshot)
            }
        //=--------------------------------------=
        // Inactive
        //=--------------------------------------=
        } else { self = other }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func collapse() {
        self.write({ $0.layout.selection.collapse() })
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Status
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func merge(_ status: Status) -> Update {
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        var next    = self.status
        let changes = next.merge(status)
        //=--------------------------------------=
        // At Least One Value Must Be Different
        //=--------------------------------------=
        guard !changes.isEmpty else { return [] }
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.merge(Self(next))
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return [.text, .selection(focus == true), .value(value != status.value)]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func merge<T>(_ characters: String,
    in range: Range<T.Position>) throws -> Update where T: Offset {
        let previous = value
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let commit = try style.resolve(Proposal(
        update:  snapshot, with: characters, in:
        layout.indices(at: Carets(range)).range))
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.collapse()
        self.merge(Self.focused(style, commit))
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return [.text, .selection, .value(value != previous)]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func merge<T>(
    selection: Range<T.Position>,
    momentums: Bool) -> Update where T: Offset {
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.write {
            $0.layout.merge(
            selection: Carets(selection),
            momentums: momentums)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return .selection(selection != self.selection())
    }
}
