//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Style x Bounds
//*============================================================================*

public protocol _Style_Bounds {
    associatedtype Value: NumberTextValue
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ limits: ClosedRange<Value>) -> Self
    
    @inlinable func bounds(_ limits: PartialRangeFrom<Value>) -> Self
    
    @inlinable func bounds(_ limits: PartialRangeThrough<Value>) -> Self
}

//*============================================================================*
// MARK: * Style x Bounds x Internal
//*============================================================================*

@usableFromInline protocol _Style_Bounds_Internal: _Style_Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ bounds: NumberTextBounds<Value>) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Style_Bounds_Internal {
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public func bounds(_ limits: ClosedRange<Value>) -> Self {
        self.bounds(NumberTextBounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeFrom<Value>) -> Self {
        self.bounds(NumberTextBounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeThrough<Value>) -> Self {
        self.bounds(NumberTextBounds(limits))
    }
}
