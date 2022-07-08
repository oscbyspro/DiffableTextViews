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
        self.storage = Storage(Transaction(status, with: &cache))
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
    
    @inlinable mutating func merge(_ remote: Transaction) {
        //=--------------------------------------=
        // Active
        //=--------------------------------------=
        if remote.base != nil, layout != nil {
            self.write { storage in
                storage.status = remote.status
                storage.layout!.merge(snapshot: remote.base!)
            }
        //=--------------------------------------=
        // Inactive
        //=--------------------------------------=
        } else { self.storage = Storage(remote) }
    }
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*
    
    @usableFromInline final class Storage {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var status: Status
        @usableFromInline var layout: Layout?
        @usableFromInline var backup: String?
        
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
            assert((status.focus ==  true) == (layout != nil))
            assert((status.focus == false) == (backup != nil))
        }
        
        @inlinable convenience init(_ remote: Transaction) {
            self.init(remote.status,  remote.base.map(Layout.init), remote.backup)
        }
    }
    
    //*========================================================================*
    // MARK: * Transaction
    //*========================================================================*
    
    @usableFromInline struct Transaction {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline private(set) var status: Status
        @usableFromInline private(set) var base: Snapshot?
        @usableFromInline private(set) var backup: String?
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ status: Status, with cache: inout Cache,
        observing changes: UnsafeMutablePointer<Changes>? = nil) {
            self.status = status
            //=----------------------------------=
            // Active
            //=----------------------------------=
            if status.focus == true {
                let commit = status.interpret(with: &cache)
                changes?.pointee += .value(status.value != commit.value)
                
                self.base = commit.snapshot
                self.status.value = commit.value
            //=----------------------------------=
            // Inactive
            //=----------------------------------=
            } else { self.backup = status.format(with: &cache) }
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
    
    @inlinable public var text: String {
        layout?.snapshot.characters ?? backup!
    }
    
    @inlinable public var selection: Range<String.Index> {
        let selection = layout?.selection.map(\.character).positions()
        return selection ?? Selection(backup! .startIndex).positions()
    }
    
    @inlinable public func selection<T>(as type: T.Type = T.self) -> Range<Offset<T>> {
        layout.map({$0.snapshot.distances(to:$0.selection.positions())}) ?? 0 ..< 0
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream
//=----------------------------------------------------------------------------=

extension Context {
    
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
            self.merge(Transaction(status, with: &cache, observing:$0))
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        update += .text
        if status.focus == false { return update }
        
        update += .selection
        update += .value(changes.contains(.value))
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
        //=--------------------------------------=
        // Layout
        //=--------------------------------------=
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
            storage.layout!.selection.collapse()
            storage.layout!.merge(snapshot: commit.snapshot)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        update += .text
        update += .selection(focus == true)
        return update
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    /// Call this on changes to selection.
    @inlinable public mutating func merge(
    selection: Range<Offset<some Encoding>>, momentums: Bool) -> Update {
        //=--------------------------------------=
        // Layout
        //=--------------------------------------=
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
