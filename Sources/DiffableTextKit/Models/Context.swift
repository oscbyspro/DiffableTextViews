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
    
    /// Use this on view setup.
    @inlinable public init(_ status: Status, with cache: inout Cache) {
        var  changes = Changes() // it's too infrequent to worry about the comparison
        self.storage = Storage(Transaction(status, with: &cache, observing: &changes))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func merge(_ remote: Transaction<Style>) {
        //=--------------------------------------=
        // Active
        //=--------------------------------------=
        if  layout != nil, remote.commit != nil {
            self.unique()
            self.storage.status = remote.status
            self.storage.layout!.merge(
            snapshot:   remote.commit!.snapshot,
            preference: remote.commit!.selection)
        //=--------------------------------------=
        // Inactive
        //=--------------------------------------=
        } else { self.storage = Storage(remote) }
    }
    
    @inlinable mutating func unique() {
        if !isKnownUniquelyReferenced(&storage) { self.storage = storage.copy() }
    }
    
    //*========================================================================*
    // MARK: * Storage [...]
    //*========================================================================*
    
    @usableFromInline final class Storage {
        
        //=--------------------------------------------------------------------=
        
        @usableFromInline var status: Status
        @usableFromInline var backup: String?
        @usableFromInline var layout: Layout?
        
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ status: Status, _ backup: String?, _ layout: Layout?) {
            self.status = status
            self.backup = backup
            self.layout = layout
            
            assert((status.focus ==  true) == (layout != nil))
            assert((status.focus == false) == (backup != nil))
        }
        
        @inlinable convenience init(_ remote: Transaction<Style>) {
            self.init(remote.status,  remote.backup, remote.layout())
        }
        
        @inlinable func copy() -> Storage {
            Storage(status, backup, layout)
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
        var changes = Changes()
        self.merge(Transaction(status, with: &cache, observing: &changes))
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
        with: Snapshot(characters), in: range)
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
        self.storage.layout!.merge(
        snapshot:   commit.snapshot,
        preference: commit.selection)
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
        let selection = Selection(layout!.snapshot.indices(at: selection))
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.unique()
        self.storage.layout!.merge(
        selection: selection,
        momentums: momentums)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Update.selection(layout!.selection != selection)
    }
}
