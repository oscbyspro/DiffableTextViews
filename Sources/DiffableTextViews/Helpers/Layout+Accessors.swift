//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: Accessors
//=----------------------------------------------------------------------------=

extension Layout {
    
    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
 
    @inlinable func nonpassthrough(_ position: Index) -> Bool {
        !snapshot.attributes[position.attribute].contains(.passthrough)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Element
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(position: Index) -> Symbol {
        snapshot[position.snapshot]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices
    //=------------------------------------------------------------------------=
    
    @inlinable var startIndex: Index {
        range.lowerBound
    }
    
    @inlinable var endIndex: Index {
        range.upperBound
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Indices - After / Before
    //=------------------------------------------------------------------------=

    @inlinable func index(after  index: Index) -> Index {
        let character = snapshot.characters[index.character]
        let after = snapshot.index(after: index.snapshot)
        return Index(after, at: index.position.after(character))
    }

    @inlinable func index(before index: Index) -> Index {
        let before = snapshot.index(before: index.snapshot)
        let character = snapshot.characters[before.character]
        return Index(before, at: index.position.before(character))
    }
}
