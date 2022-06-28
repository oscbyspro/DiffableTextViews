//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * State
//*============================================================================*

/// A set of values describing the state of a diffable text view.
///
/// - Uses copy-on-write semantics.
///
@usableFromInline struct State<Style: DiffableTextStyle> {
    public typealias Cache = Style.Cache
    public typealias Value = Style.Value
    
    public typealias Status = DiffableTextKit.Status<Style>
    public typealias Commit = DiffableTextKit.Commit<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline private(set) var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Upstream
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ status: Status, _ cache: inout Cache) {
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
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Downstream
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ status: Status, _ proposal: Proposal, _ cache: inout Cache) throws {
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
    
    @inlinable mutating func collapse() {
        self.write({$0.layout.selection.collapse()})
    }
    
    @inlinable mutating func merge<T>(selection: Carets<Offset<T>>, momentums: Bool) {
        self.write({$0.layout.merge(selection:selection, momentums: momentums)})
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
