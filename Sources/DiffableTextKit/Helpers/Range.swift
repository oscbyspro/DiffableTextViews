//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Range
//*============================================================================*

extension Range {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func empty(_ location: Bound) -> Self {
        Self(uncheckedBounds: (location, location))
    }
    
    @inlinable static func unchecked(_ bounds: (lower: Bound, upper: Bound)) -> Self {
        Self(uncheckedBounds: bounds)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Index
//=----------------------------------------------------------------------------=

extension Range where Bound: _Index {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var positions: Range<Bound.Position> {
        .unchecked((lowerBound.position, upperBound.position))
    }
    
    @inlinable var subindices: Range<Bound.Subindex> {
        .unchecked((lowerBound.subindex, upperBound.subindex))
    }
}
