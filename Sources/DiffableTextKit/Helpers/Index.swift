//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*========================================================================*
// MARK: * Index
//*========================================================================*

public struct Index: Comparable {
    
    //=--------------------------------------------------------------------=
    // MARK: State
    //=--------------------------------------------------------------------=
    
    @usableFromInline let character: String.Index
    @usableFromInline let attribute: Int

    //=--------------------------------------------------------------------=
    // MARK: Initializers
    //=--------------------------------------------------------------------=

    @inlinable init(_ character: String.Index, _ attribute: Int) {
        self.character = character
        self.attribute = attribute
    }

    //=--------------------------------------------------------------------=
    // MARK: Comparisons
    //=--------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.attribute == rhs.attribute
    }
    
    @inlinable public static func <  (lhs: Self, rhs: Self) -> Bool {
        lhs.attribute <  rhs.attribute
    }
}
