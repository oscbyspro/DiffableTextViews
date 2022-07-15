//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Internal x Bounds
//*============================================================================*

@usableFromInline protocol _Internal_Bounds: _Style {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var bounds: NumberTextBounds<Input>? { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Internal_Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ bounds: NumberTextBounds<Input>) -> Self {
        var result = self; result.bounds = bounds; return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public func bounds(_ limits: ClosedRange<Input>) -> Self {
        self.bounds(NumberTextBounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeFrom<Input>) -> Self {
        self.bounds(NumberTextBounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeThrough<Input>) -> Self {
        self.bounds(NumberTextBounds(limits))
    }
}
