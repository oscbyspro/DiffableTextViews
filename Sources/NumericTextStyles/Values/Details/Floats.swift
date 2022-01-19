//
//  Floats.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

//*============================================================================*
// MARK: * Float16
//*============================================================================*

extension Float16: FloatingPointValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(3)
    public static let bounds: ClosedRange<Self> = bounds(limit: 999)
}

//*============================================================================*
// MARK: * Float32
//*============================================================================*

extension Float32: FloatingPointValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(7)
    public static let bounds: ClosedRange<Self> = bounds(limit: 9_999_999)
}

//*============================================================================*
// MARK: * Float64
//*============================================================================*

extension Float64: FloatingPointValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = precision(15)
    public static let bounds: ClosedRange<Self> = bounds(limit: 999_999_999_999_999)
}