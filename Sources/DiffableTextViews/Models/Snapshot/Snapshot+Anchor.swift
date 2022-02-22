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

#warning("Make separate optional methods.")
public extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: After
    //=------------------------------------------------------------------------=
    
    #warning("Clean this up.")
    /// Removes the appropriate lookability of this attribute and the attribute after it.
    ///
    /// - Parameter position: A subscriptable index of the collection.
    ///
    @inlinable mutating func anchor(after position: Index?) {
        guard let position = position?.attribute else { return }
        //=--------------------------------------=
        // MARK: Ahead
        //=--------------------------------------=
        if  position <  _attributes.endIndex - 1 {
            _attributes[_attributes.index(after: position)].subtract(.lookaheadable)
        }
        //=--------------------------------------=
        // MARK: Behind
        //=--------------------------------------=
        if position != _attributes.endIndex {
            _attributes[position].subtract(.lookbehindable)
        }
    }
    
    #warning("Clean this up.")
    //=------------------------------------------------------------------------=
    // MARK: Before
    //=------------------------------------------------------------------------=
    
    /// Removes the appropriate lookability of this attribute and the attribute before it.
    ///
    /// - Parameter position: A subscriptable index of the collection.
    ///
    @inlinable mutating func anchor(before position: Index?) {
        guard let position = position?.attribute else { return }
        //=--------------------------------------=
        // MARK: Behind
        //=--------------------------------------=
        if  position != _attributes.startIndex {
            _attributes[_attributes.index(before: position)].subtract(.lookbehindable)
        }
        //=--------------------------------------=
        // MARK: Ahead
        //=--------------------------------------=
        if position != _attributes.endIndex {
            _attributes[position].subtract(.lookaheadable)
        }
    }
}
