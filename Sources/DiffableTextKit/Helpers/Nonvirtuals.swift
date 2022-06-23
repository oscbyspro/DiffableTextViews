//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Nonvirtuals
//*============================================================================*

/// A lazy sequence of nonvirtual characters.
///
/// It's basically a more optimizable version of the following sequence:
///
/// ```swift
/// snapshot.lazy.filter(\.nonvirtual).map(\.character)
/// ```
///
@usableFromInline struct Nonvirtuals: LazySequenceProtocol {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let snapshot: Snapshot
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(_ snapshot: Snapshot) {
        self.snapshot = snapshot
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    public __consuming func makeIterator() -> Iterator {
        Iterator(snapshot)
    }
    
    //*========================================================================*
    // MARK: * Iterator
    //*========================================================================*
    
    @usableFromInline struct Iterator: IteratorProtocol {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let snapshot: Snapshot
        @usableFromInline var position: Snapshot.Index
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable @inline(__always)
        init(_ snapshot: Snapshot) {
            self.snapshot = snapshot
            self.position = snapshot.startIndex
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable public mutating func next() -> Character? {
            search: while position != snapshot.endIndex {
                defer {
                    snapshot.formIndex(after: &position)
                }
                //=------------------------------=
                // Next
                //=------------------------------=
                if  snapshot.attributes[position.attribute].contains(.virtual) {
                    continue search
                }
                //=------------------------------=
                // Done
                //=------------------------------=
                return snapshot.characters[position.character]
            }
            //=----------------------------------=
            // None
            //=----------------------------------=
            return nil
        }
    }
}

//*============================================================================*
// MARK: * Nonvirtuals x Snapshot
//*============================================================================*

extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A lazy sequence of nonvirtual characters.
    ///
    /// It's basically a more optimizable version of the following sequence:
    ///
    /// ```swift
    /// snapshot.lazy.filter(\.nonvirtual).map(\.character)
    /// ```
    ///
    @inlinable @inline(__always)
    public var nonvirtuals: some Sequence<Character> {
        Nonvirtuals(self)
    }
}
