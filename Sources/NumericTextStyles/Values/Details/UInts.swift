//
//  UInts.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

//*============================================================================*
// MARK: * UInt
//*============================================================================*

extension UInt: IntegerValue, UnsignedValue {
    typealias Limitation = Int
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Count = Limitation.precision
    public static let bounds: ClosedRange<Self> = 0...Self(Limitation.bounds.upperBound)
}

//*============================================================================*
// MARK: * UInt8
//*============================================================================*

extension UInt8: IntegerValue, UnsignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = precision(3)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * UInt16
//*============================================================================*

extension UInt16: IntegerValue, UnsignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = precision(5)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * UInt32
//*============================================================================*

extension UInt32: IntegerValue, UnsignedValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = precision(10)
    public static let bounds: ClosedRange<Self> = bounds()
}

//*============================================================================*
// MARK: * UInt64
//*============================================================================*

extension UInt64: IntegerValue, UnsignedValue {
    typealias Limitation = Int64
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Count = Limitation.precision
    public static let bounds: ClosedRange<Self> = 0...Self(Limitation.bounds.upperBound)
}
