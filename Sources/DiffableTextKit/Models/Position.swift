//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Position
//*============================================================================*

public struct Position<Offset: DiffableTextKit.Offset>: Comparable {
    @inlinable public static var offset: Offset.Type { Offset.self }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    public let offset: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ offset: Int = 0) {
        self.offset = offset
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=

    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.offset == rhs.offset
    }
    
    @inlinable public static func <  (lhs: Self, rhs: Self) -> Bool {
        lhs.offset <  rhs.offset
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension Position {

    //=------------------------------------------------------------------------=
    // MARK: Range
    //=------------------------------------------------------------------------=
    
    @inlinable public static func range(_ range: NSRange) -> Range<Self> {
        Self(range.lowerBound) ..< Self(range.upperBound)
    }
}
