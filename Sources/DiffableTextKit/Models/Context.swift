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
public final class Context<Style: DiffableTextStyle> {
    @usableFromInline typealias State = DiffableTextKit.State<Style>

    public typealias Cache  = Style.Cache
    public typealias Value  = Style.Value
    
    public typealias Status = DiffableTextKit.Status<Style>
    public typealias Commit = DiffableTextKit.Commit<Value>
    
    //=--------------------------------------------------------------------=
    // MARK: State
    //=--------------------------------------------------------------------=
    
    @usableFromInline private(set) var cache: Cache
    @usableFromInline private(set) var state: State
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ status: Status) {
        self.cache = status.style.cache()
        self.state = State(status,&cache)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Accessors
//=----------------------------------------------------------------------------=

extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    internal var status: Status {
        state.status
    }
    
    @inlinable @inline(__always)
    internal var layout: Layout {
        state.layout
    }

    //=------------------------------------------------------------------------=
    // MARK: Status
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
    // MARK: Layout
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    internal var snapshot: Snapshot {
        layout.snapshot
    }
    
    @inlinable @inline(__always)
    public var text: String {
        layout.snapshot.characters
    }
    
    @inlinable @inline(__always)
    public func selection<T>(as encoding: T.Type = T.self) -> Range<Offset<T>> {
        layout.selection().range
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Status
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(_ status: Status) -> Update {
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        var next    = self.state.status
        let changes = next.merge(status)
        //=--------------------------------------=
        // At Least One Value Must Have Changed
        //=--------------------------------------=
        guard !changes.isEmpty else { return [] }
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.state.merge(State(status, &cache))
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Update([.text, .selection(focus == true), .value(value != status.value)])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge<T>(_ characters: String,
    in range: Range<Offset<T>>) throws -> Update {
        let previous = value
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let proposal = Proposal(update: layout.snapshot,
        with: Snapshot(characters), in: layout.indices(at: Carets(range)).range)
        let next = try State(status, proposal, &self.cache)
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.state.collapse()
        self.state.merge(next)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Update([.text, .selection, .value(value != previous)])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge<T>(
    selection: Range<Offset<T>>,
    momentums: Bool) -> Update {
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.state.merge(
        selection: Carets(selection),
        momentums: momentums)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Update.selection(selection != self.selection())
    }
}
