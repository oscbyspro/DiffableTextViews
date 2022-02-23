//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Accessors
//=----------------------------------------------------------------------------=

public extension Snapshot {
    
    //=------------------------------------------------------------------------=
    // MARK: Count
    //=------------------------------------------------------------------------=
    
    /// - Complexity: O(1).
    @inlinable var count: Int {
        _attributes.count
    }
    
    /// - Complexity: O(1).
    @inlinable var underestimatedCount: Int {
        _attributes.underestimatedCount
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Element
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(position: Index) -> Symbol {
        Symbol(character: _characters[position.character],
               attribute: _attributes[position.attribute])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable var startIndex: Index {
        Index(_characters.startIndex,
              _attributes.startIndex)
    }

    @inlinable var endIndex: Index {
        Index(_characters.endIndex,
              _attributes.endIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices - After / Before
    //=------------------------------------------------------------------------=
    
    @inlinable func index(after position: Index) -> Index {
        Index(_characters.index(after: position.character),
              _attributes.index(after: position.attribute))
    }
    
    @inlinable func index(before position: Index) -> Index {
        Index(_characters.index(before: position.character),
              _attributes.index(before: position.attribute))
    }
}
