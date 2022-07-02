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
        status.style.update(&cache)
        //=--------------------------------------=
        // Active
        //=--------------------------------------=
        if  status.focus == true {
            let commit = status.style.interpret(status.value, with: &cache)
            let status = Status(status.style,   commit.value, status.focus)
            self.storage = Storage(status, Layout(commit.snapshot),    nil)
        //=--------------------------------------=
        // Inactive
        //=--------------------------------------=
        } else {
            let backup = status.style.format(status.value, with: &cache)
            self.storage = Storage(status, nil, backup)
        }
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
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func merge(_ other: Self) {
        //=--------------------------------------=
        // Active
        //=--------------------------------------=
        if  layout != nil, other.layout != nil {
            self.write {
                $0.status = other.status
                $0.layout!.merge(snapshot: other.layout!.snapshot)
            }
        //=--------------------------------------=
        // Inactive
        //=--------------------------------------=
        } else { self = other }
    }
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*

    /// It contains text when in focus, it contains a layout otherwise.
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
            //=--------------------------------------=
            // Invariants
            //=--------------------------------------=
            assert((status.focus ==  true) == (layout != nil))
            assert((status.focus == false) == (backup != nil))
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
    // MARK: Layout, Backup
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public var text: String {
        layout?.snapshot.characters ?? backup!
    }
    
    @inlinable @inline(__always)
    public func selection<T>(as encoding: T.Type = T.self) -> Range<Offset<T>> {
        layout?.selection().range ?? .zero ..< .zero
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
        var status = status
        let result = status.merge(remote)
        
        if result.isEmpty { return .none }
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.merge(Self(status, with: &cache))
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        if focus == false { return .text }
        
        return [.text, .selection, .value(value != remote.value)]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    /// Call this on changes to text.
    @inlinable public mutating func merge<T>(_ characters: String, in range:
    Range<Offset<T>>, with cache: inout Cache) throws -> Update {
        //=--------------------------------------=
        // Interactive
        //=--------------------------------------=
        if  let layout {
            let carets = layout.indices(at: Carets(range))
            let proposal = Proposal(update: layout.snapshot,
            with: Snapshot(characters), in: carets.range)
            //=----------------------------------=
            // Commit
            //=----------------------------------=
            status.style.update(&cache)
            
            let commit = try status.style.resolve(proposal, with: &cache)
            let value = Update.value(value != commit.value)
            //=----------------------------------=
            // Update
            //=----------------------------------=
            self.write {
                $0.status.value = commit.value
                $0.layout!.selection.collapse()
                $0.layout!.merge(snapshot: commit.snapshot)
            }
            //=----------------------------------=
            // Return
            //=----------------------------------=
            return [.text, .selection, value]
        //=--------------------------------------=
        // Backup
        //=--------------------------------------=
        } else {
            //=----------------------------------=
            // Update
            //=----------------------------------=
            self.write {
                let lower = T.index(at: range.lowerBound, from: $0.backup!.startIndex, in: $0.backup!)
                let range = lower ..< T.index(at: range.upperBound,  from:      lower, in: $0.backup!)
                $0.backup!.replaceSubrange(range, with: characters)
            }
            //=----------------------------------=
            // Return
            //=----------------------------------=
            return .text
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    /// Call this on changes to selection.
    @inlinable public mutating func merge<T>(selection: Range<Offset<T>>, momentums: Bool) -> Update {
        guard layout != nil else { return .none }
        //=--------------------------------------=
        // Update
        //=--------------------------------------=
        self.write {
            $0.layout!.merge(
            selection: Carets(selection),
            momentums: momentums)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Update.selection(self.selection() != selection)
    }
}
