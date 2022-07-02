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
    public typealias Cache = Style.Cache
    public typealias Value = Style.Value
    
    public typealias Status = DiffableTextKit.Status<Style>
    public typealias Commit = DiffableTextKit.Commit<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline private(set) var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Use this on view update.
    @inlinable public init(_ status: Status, with cache: inout Cache) {
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        status.style.update(&cache)
        //=--------------------------------------=
        // Active
        //=--------------------------------------=
        if status.focus == true {
            let commit = status.style.interpret(status.value, with: &cache)
            let status = Status(status.style,   commit.value, status.focus)
            self.storage = Storage(status, Layout(commit.snapshot))
        //=--------------------------------------=
        // Inactive
        //=--------------------------------------=
        } else {
            let text = status.style.format(status.value, with: &cache)
            let layout = Layout(Snapshot(text, as: Attribute.phantom))
            self.storage = Storage(status, layout)
        }
    }
    
    /// Use this on changes to text.
    @inlinable init(_ status: Status, _ proposal: Proposal, _ cache: inout Cache) throws {
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        status.style.update(&cache)
        //=--------------------------------------=
        // Interactive
        //=--------------------------------------=
        let commit = try status.style.resolve(proposal, with: &cache)
        let status = Status(status.style, commit.value, status.focus)
        self.storage = Storage(status, Layout(commit.snapshot))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
        
    @inlinable @inline(__always)
    var status: Status {
        storage.status
    }
    
    @inlinable @inline(__always)
    var layout: Layout {
        storage.layout
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
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
    
    @inlinable @inline(__always)
    public var text: String {
        layout.snapshot.characters
    }
    
    @inlinable @inline(__always)
    public func selection<T>(as encoding: T.Type = T.self) -> Range<Offset<T>> {
        layout.selection().range
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation
    //=------------------------------------------------------------------------=
    
    /// Writes to storage with copy-on-write behavior.
    @inlinable mutating func write(_ write: (Storage) -> Void) {
        //=--------------------------------------=
        // Unique
        //=--------------------------------------=
        if !isKnownUniquelyReferenced(&storage) {
            self.storage = Storage(status,layout)
        }
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        write(self.storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func merge(_ other: Self) {
        //=--------------------------------------=
        // Active
        //=--------------------------------------=
        if other.status.focus == true {
            self.write {
                $0.status = other.status
                $0.layout.merge(snapshot: other.layout.snapshot)
            }
        //=--------------------------------------=
        // Inactive
        //=--------------------------------------=
        } else { self = other }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Call this on view update.
    @inlinable public mutating func merge(_ remote: Status, with cache: inout Cache) -> Update {
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        var next    = self.status
        let changes = next.merge(remote)
        //=--------------------------------------=
        // At Least One Value Must Have Changed
        //=--------------------------------------=
        guard !changes.isEmpty else { return [] }
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.merge(Self(next, with: &cache))
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Update([.text, .selection(focus == true), .value(value != remote.value)])
    }
    
    /// Call this on changes to text.
    @inlinable public mutating func merge<T>(_ characters: String, in range:
    Range<Offset<T>>, with cache: inout Cache) throws -> Update {
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let proposal = Proposal(update: layout.snapshot,
        with: Snapshot(characters), in: layout.indices(at: Carets(range)).range)
        let next = try Self(status, proposal, &cache)
        let previous = value
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.collapse()
        self.merge(next)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Update([.text, .selection, .value(value != previous)])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func collapse() {
        self.write({$0.layout.selection.collapse()})
    }
    
    /// Call this on changes to selection.
    @inlinable public mutating func merge<T>(selection: Range<Offset<T>>, momentums: Bool) -> Update {
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
        return Update.selection(self.selection() != selection)
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
    }
}
