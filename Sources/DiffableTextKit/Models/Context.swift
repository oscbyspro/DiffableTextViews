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
    
    @inlinable public init(_ status: Status, with cache: inout Cache) {
        self.init(status, with: &cache, observing: nil)
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
            self.storage = Storage(status, layout, backup)
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
        if self.layout != nil, other.layout != nil {
            self.write { storage in
                storage.status = other.status
                storage.layout!.merge(snapshot: other.layout!.snapshot)
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
        @usableFromInline var layout: Layout!
        @usableFromInline var backup: String!
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ status: Status, _ layout: Layout?, _ backup: String?) {
            self.status = status
            self.layout = layout
            self.backup = backup
            //=----------------------------------=
            // Invariants
            //=----------------------------------=
            assert((status.focus == true) == (layout != nil))
            assert((status.focus == true) == (backup == nil))
        }
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
    var layout: Layout? {
        storage.layout
    }
    
    @inlinable @inline(__always)
    var backup: String? {
        storage.backup
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
        layout?.snapshot.characters ?? backup!
    }
    
    @inlinable @inline(__always)
    public var selection: Range<String.Index> {
        let selection = layout?.selection.map(\.character).range
        return selection ?? Selection(backup! .startIndex).range
    }
    
    @inlinable @inline(__always)
    public func selection<T>(as type: T.Type = T.self) -> Range<Offset<T>> {        
        layout?.selection() ?? .zero ..< .zero
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream
//=----------------------------------------------------------------------------=

extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ status: Status, with cache: inout Cache,
    observing changes: Optional<UnsafeMutablePointer<Changes>>) {
        //=--------------------------------------=
        // Active
        //=--------------------------------------=
        if status.focus == true {
            var status = status
            let commit = status.interpret(with: &cache)
            changes?.pointee.formUnion(.value(commit.value != status.value))
            
            status.value = commit.value
            self.storage = Storage(status, Layout(commit.snapshot), nil)
        //=--------------------------------------=
        // Inactive
        //=--------------------------------------=
        } else {
            self.storage = Storage(status, nil, status.format(with: &cache))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Synchronization
    //=------------------------------------------------------------------------=
    
    /// Call this on view update.
    @inlinable public mutating func merge(_ remote: Status, with cache: inout Cache) -> Update {
        var update = Update()
        //=--------------------------------------=
        // At Least One Value Must Have Changed
        //=--------------------------------------=
        var status = self.status
        if !status.merge(remote) { return update }
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        var changes = Changes(); withUnsafeMutablePointer(to: &changes) {
            let observable = status.focus == true ? $0 : nil
            self.merge(Self(status, with: &cache, observing: observable))
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        update.formUnion(.text)
        if status.focus == false { return update }
        
        update.formUnion(.selection)
        update.formUnion(.value(changes.contains(.value)))
        return update
    }
}


//=----------------------------------------------------------------------------=
// MARK: + Downstream
//=----------------------------------------------------------------------------=

extension Context {

    //=------------------------------------------------------------------------=
    // MARK: Text
    //=------------------------------------------------------------------------=
    
    /// Call this on changes to text.
    @inlinable public mutating func merge(_   characters: String, in range:
    Range<Offset<some Encoding>>, with cache: inout Cache) throws -> Update {
        if layout == nil { return [] }
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let proposal = Proposal(layout!.snapshot,
        with: Snapshot(characters, as: .content),
        in: layout!.snapshot.indices(at:  range))
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        let commit = try status.resolve(proposal, with: &cache)
        var update = Update.value(value != commit.value)
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.write { storage in
            storage.status.value = commit.value
            storage.layout.selection.collapse()
            storage.layout.merge(snapshot: commit.snapshot)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        update.formUnion(.text)
        update.formUnion(.selection(focus == true))
        return update
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    /// Call this on changes to selection.
    @inlinable public mutating func merge(
    selection: Range<Offset<some Encoding>>, momentums: Bool) -> Update {
        if layout == nil { return [] }
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let selection = Selection(layout!.snapshot.indices(at: selection))
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.write { storage in
            storage.layout!.merge(
            selection: selection,
            momentums: momentums)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return .selection(layout!.selection != selection)
    }
}
