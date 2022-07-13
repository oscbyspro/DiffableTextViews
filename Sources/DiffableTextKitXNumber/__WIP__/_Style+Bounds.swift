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

public protocol _Style_Bounds: _Style {
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable func bounds(_ limits: ClosedRange<Value>) -> Self
    
    @inlinable func bounds(_ limits: PartialRangeFrom<Value>) -> Self
    
    @inlinable func bounds(_ limits: PartialRangeThrough<Value>) -> Self
}

//*============================================================================*
// MARK: * Style x Bounds x Internal
//*============================================================================*

@usableFromInline protocol _Internal_Style_Bounds: _Style_Bounds {
    typealias Bounds = NumberTextBounds<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var bounds: Bounds? { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Internal_Style_Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func bounds(_ bounds: Bounds) -> Self {
        var result = self; result.bounds = bounds; return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Limits
    //=------------------------------------------------------------------------=
    
    @inlinable public func bounds(_ limits: ClosedRange<Value>) -> Self {
        bounds(Bounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeFrom<Value>) -> Self {
        bounds(Bounds(limits))
    }
    
    @inlinable public func bounds(_ limits: PartialRangeThrough<Value>) -> Self {
        bounds(Bounds(limits))
    }
}
