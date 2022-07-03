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
    
    @inlinable init( _ storage: Storage) {
        self.storage = storage
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
    
    @inlinable mutating func merge(_ other: Self) {
        //=--------------------------------------=
        // Active
        //=--------------------------------------=
        if other.status.focus == true {
            self.write { storage in
                storage.status = other.status
                storage.layout.merge(snapshot: other.layout.snapshot)
            }
        //=--------------------------------------=
        // Inactive
        //=--------------------------------------=
        } else { self = other }
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

//=----------------------------------------------------------------------------=
// MARK: + Initializers
//=----------------------------------------------------------------------------=

extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Active, Inactive
    //=------------------------------------------------------------------------=
    
    /// Use this on view update.
    @inlinable public init(_ status: Status, with cache: inout Cache) {
        self = status.focus.wrapped
        ?   .active(style: status.style, value: status.value, with: &cache)
        : .inactive(style: status.style, value: status.value, with: &cache)
    }
    
    @inlinable static func active(style: Style, value: Value, with cache: inout Cache) -> Self {
        style.update(&cache); let commit = style.interpret(value, with: &cache)
        let status = Status(style,commit.value, true); let layout = Layout(commit.snapshot)
        return .init(Storage(status, layout))
    }
    
    @inlinable static func inactive(style: Style, value: Value, with cache: inout Cache) -> Self {
        style.update(&cache); let text = style.format(value, with: &cache)
        let status = Status(style, value, false); let layout = Layout(Snapshot(text, as: .phantom))
        return .init(Storage(status, layout))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Accessors
//=----------------------------------------------------------------------------=

extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Storage
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
    public var text: String {
        layout.snapshot.characters
    }
    
    @inlinable @inline(__always)
    public var selection: Range<String.Index> {
        layout.selection.map(caret: \.character).range
    }
    
    @inlinable @inline(__always)
    public func selection<T>(as type: T.Type = T.self) -> Range<Offset<T>> {
        layout.snapshot.distances(at: layout.selection.range)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    /// Call this on view update.
    @inlinable public mutating func merge(_ remote: Status, with cache: inout Cache) -> Update {
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
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    /// Call this on changes to text.
    @inlinable public mutating func merge(_ characters: String, in range:
    Range<some Position>, with cache: inout Cache) throws -> Update {
        let replacement = Snapshot(characters)
        let range = layout.snapshot.indices(at: range)
        let proposal = Proposal(update: layout.snapshot, with: replacement, in: range)
        //=----------------------------------=
        // Commit
        //=----------------------------------=
        status.style.update(&cache)
        
        let commit = try status.style.resolve(proposal, with: &cache)
        let value = Update.value(value != commit.value)
        //=----------------------------------=
        // Update
        //=----------------------------------=
        self.write { storage in
            storage.status.value = commit.value
            storage.layout.selection.collapse()
            storage.layout.merge(snapshot: commit.snapshot)
        }
        //=----------------------------------=
        // Return
        //=----------------------------------=
        return [.text, .selection(focus == true), value]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    /// Call this on changes to selection.
    @inlinable public mutating func merge(selection:
    Range<some Position>, momentums: Bool) -> Update {
        let selection = Carets(layout.snapshot.indices(at: selection))
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.write { storage in
            storage.layout.merge(
            selection: selection,
            momentums: momentums)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Update.selection(layout.selection != selection)
    }
}
