//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Anchor
//=----------------------------------------------------------------------------=

public extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Index
    //=------------------------------------------------------------------------=

    /// Removes the appropriate lookability of this attribute and the attribute before it.
    ///
    /// - Parameter position: A subscriptable index of the collection.
    ///
    @inlinable mutating func anchor(_ position: Index) {
        let position = position.attribute
        //=--------------------------------------=
        // MARK: Ahead
        //=--------------------------------------=
        if position != _attributes.endIndex {
            _attributes[position].subtract(.lookaheadable)
        }
        //=--------------------------------------=
        // MARK: Behind
        //=--------------------------------------=
        if  position != _attributes.startIndex {
            _attributes[_attributes.index(before: position)].subtract(.lookbehindable)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Index - Optional
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func anchor(_ position: Index?) {
        if let position = position { anchor(position) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Element(s)
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func anchor(_ element: Symbol) {
        let anchorIndex = endIndex
        self.append(element)
        self.anchor(anchorIndex)
    }
    
    @inlinable mutating func anchor<S: Sequence>(contentsOf elements: S) where S.Element == Symbol {
        let anchorIndex = endIndex
        self.append(contentsOf: elements)
        self.anchor(anchorIndex)
    }
}
