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

/// A diffable text view state model.
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
    
    @inlinable mutating func unique() {        
        if !isKnownUniquelyReferenced(&storage) { self.storage = storage.copy() }
    }
    
    //*========================================================================*
    // MARK: * Storage [...]
    //*========================================================================*
    
    @usableFromInline final class Storage {
        
        //=--------------------------------------------------------------------=
        
        @usableFromInline var status: Status
        @usableFromInline var layout: Layout?
        @usableFromInline var backup: String?
        
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ status: Status, _ layout: Layout?, _ backup: String?) {
            self.status = status
            self.layout = layout
            self.backup = backup
            
            assert((status.focus ==  true) == (layout != nil))
            assert((status.focus == false) == (backup != nil))
        }
        
        @inlinable convenience init(_ remote: Transaction) {
            self.init(remote.status,  remote.base.map(Layout.init), remote.backup)
        }
        
        @inlinable func copy() -> Storage {
            Storage(status, layout, backup)
        }
    }
    
    //*========================================================================*
    // MARK: * Transaction [...]
    //*========================================================================*
    
    @usableFromInline struct Transaction {
        
        //=--------------------------------------------------------------------=
        
        @usableFromInline private(set) var status: Status
        @usableFromInline private(set) var base: Snapshot?
        @usableFromInline private(set) var backup: String?
        
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
    
    @inlinable var status: Status  { storage.status }
    
    @inlinable var layout: Layout? { storage.layout }
    
    @inlinable var backup: String? { storage.backup }
    
    //=------------------------------------------------------------------------=
    // MARK: Status
    //=------------------------------------------------------------------------=
    
    @inlinable public var style: Style { status.style }
    
    @inlinable public var value: Value { status.value }
    
    @inlinable public var focus: Focus { status.focus }
    
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
    // MARK: Status
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
    
    //=------------------------------------------------------------------------=
    // MARK: Transaction
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func merge(_ remote: Transaction) {
        //=--------------------------------------=
        // Active
        //=--------------------------------------=
        if remote.base != nil, layout != nil {
            self.unique()
            self.storage.status = remote.status
            self.storage.layout!.merge(snapshot: remote.base!)
        //=--------------------------------------=
        // Inactive
        //=--------------------------------------=
        } else { self.storage = Storage(remote) }
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
    @inlinable public mutating func merge<T>(_ characters: String,
    in range: Range<Offset<T>>, with cache: inout Cache) throws -> Update {
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
        self.unique()
        self.storage.status.value = commit.value
        self.storage.layout!.selection.collapse()
        self.storage.layout!.merge(snapshot: commit.snapshot)
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
    @inlinable public mutating func merge<T>(
    selection: Range<Offset<T>>, momentums: Bool) -> Update {
        //=--------------------------------------=
        // Layout
        //=--------------------------------------=
        if layout == nil { return [] }
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let selection  = Selection(layout!.snapshot.indices(at: selection))
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.unique()
        self.storage.layout!.merge(selection: selection, momentums: momentums)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Update.selection(layout!.selection != selection)
    }
}
