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
    
    public typealias Cache  = Style.Cache
    public typealias Value  = Style.Value
    
    public typealias Status = DiffableTextKit.Status<Style>
    public typealias Commit = DiffableTextKit.Commit<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Use this method on view setup.
    @inlinable public init(_ status: Status, with cache: inout Cache, then update: inout Update) {
        self.init(deferring: status, with: &cache, then: &update)
        self.storage.layout?.autocorrect() // layout was deferred
    }
    
    /// Use this method to defer layout selection.
    @inlinable init(deferring status: Status, with cache: inout Cache, then update: inout Update) {
        update += .text
        //=----------------------------------=
        // Active
        //=----------------------------------=
        if  status.focus == true {
            let commit = status.interpret(with: &cache)
            let layout = Layout(deferring:(
            snapshot:/**/commit.snapshot,
            preference:  commit.selection))
            
            update += .selection
            update += .value(status.value != commit.value)
            
            self.storage = Storage(status,nil,layout)
            self.storage.status.value = commit.value
        //=----------------------------------=
        // Inactive
        //=----------------------------------=
        } else {
            let  backup  = status.format(with:&cache)
            self.storage = Storage(status,backup,nil)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func unique() {
        if !isKnownUniquelyReferenced(&storage) { self.storage = storage.copy() }
    }
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*
    
    @usableFromInline final class Storage {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var status: Status
        @usableFromInline var backup: String?
        @usableFromInline var layout: Layout?
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ status: Status, _ backup: String?, _ layout: Layout?) {
            self.status = status
            self.backup = backup
            self.layout = layout
            //=----------------------------------=
            // Invariants
            //=----------------------------------=
            assert((status.focus ==  true) == (layout != nil))
            assert((status.focus == false) == (backup != nil))
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable func copy() -> Self {
            Self(status, backup, layout)
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
        let selection = layout?.selection.map(\.character).range()
        return selection ?? Selection(backup! .startIndex).range()
    }
    
    @inlinable public func selection<T>(as type: T.Type = T.self) -> Range<Offset<T>> {
        layout.map({ $0.snapshot.range(to: $0.selection .range()) }) ?? 0 ..< 0
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Context {
    
    //=------------------------------------------------------------------------=
    // MARK: Status
    //=------------------------------------------------------------------------=
    
    /// Use this method on view update.
    ///
    /// Merges inputs unless an optional constraint is broken.
    ///
    /// - Throws: A message describing the optional constraint that was broken.
    ///
    @inlinable @inline(never) public mutating func merge(_ status: Status,
    with cache: inout Cache, and options: Synchronize) throws -> Update {
        var update = Update()
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        var values = self.status
        if !values.merge(status) { return update }
        let next = Self(deferring: values, with: &cache, then: &update)
        //=--------------------------------------=
        // Validation
        //=--------------------------------------=
        if  options.contains(.acyclical), update.contains(.value) {
            let  input = Info.init([.note(status.value), "[input]"])
            let output = Info.init([.note(next  .value),"[output]"])
            throw Info([.mark("cyclical"), "\(input) != \(output)"])
        }
        //=--------------------------------------=
        // Update x Active == 2
        //=--------------------------------------=
        if  layout != nil, next.layout != nil {
            self.unique()
            self.storage.status = next.status
            self.storage.layout!.merge(next.layout!.snapshot, and: next.layout!.preference)
        //=--------------------------------------=
        // Update x Active <= 1
        //=--------------------------------------=
        } else {
            self = next // layout was deferred
            self.storage.layout?.autocorrect()
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return update
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Text
    //=------------------------------------------------------------------------=
    
    /// Use this method on changes to text.
    @inlinable @inline(never) public mutating func merge<T>(_ text: String,
    in range: Range<Offset<T>>, with cache: inout Cache) throws -> Update {
        var update = Update()
        //=--------------------------------------=
        // Layout
        //=--------------------------------------=
        guard layout != nil else { return update }
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let proposal = Proposal(layout!.snapshot, with: text, in: range)
        let commit = try status.resolve(proposal, with: &cache)
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        update += .text
        update += .selection
        update += .value(value != commit.value)
        
        self.unique()
        self.storage.status.value = commit.value
        self.storage.layout!.selection.collapse()
        self.storage.layout!.merge(commit.snapshot, and: commit.selection)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return update
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    /// Use this method on changes to selection.
    @inlinable @inline(never) public mutating func merge<T>(
    _ selection: Range<Offset<T>>, with options: Resolve) -> Update {
        var update = Update()
        //=--------------------------------------=
        // Layout
        //=--------------------------------------=
        guard layout != nil else { return update }
        //=--------------------------------------=
        // Values
        //=--------------------------------------=
        let selection = Selection(layout!.snapshot.range(at: selection))
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.unique()
        self.storage.layout!.merge(selection, with: options)
        update += .selection(layout!.selection != selection)
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return update
    }
}
