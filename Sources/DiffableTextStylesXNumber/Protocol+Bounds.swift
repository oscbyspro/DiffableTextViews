//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: Details
//=----------------------------------------------------------------------------=

public extension NumberTextStyleProtocol {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ bounds: Bounds) -> Self {
        var result = self; result.bounds = bounds; return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: Bounds
//=----------------------------------------------------------------------------=

public extension NumberTextStyleProtocol {
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ limits: ClosedRange<Format.FormatInput>) -> Self {
        bounds(Bounds(limits))
    }
    
    @inlinable func bounds(_ limits: PartialRangeFrom<Format.FormatInput>) -> Self {
        bounds(Bounds(limits))
    }
    
    @inlinable func bounds(_ limits: PartialRangeThrough<Format.FormatInput>) -> Self {
        bounds(Bounds(limits))
    }
}
