//
//  UInts.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-25.
//

//*============================================================================*
// MARK: * UInt
//*============================================================================*

extension UInt: ValuableUInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Precise, Boundable
    //=------------------------------------------------------------------------=
    
    /// Apple, please fix IntegerFormatStyle«UInt» because it uses an Int.
    public static let precision: Capacity = Int.precision
    
    /// Apple, please fix IntegerFormatStyle«UInt» because it uses an Int.
    public static let maxLosslessValue: UInt = UInt(Int.maxLosslessValue)
}

//*============================================================================*
// MARK: * UInt8
//*============================================================================*

extension UInt8: ValuableUInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Precise
    //=------------------------------------------------------------------------=

    public static let precision: Capacity = precision(3)
}

//*============================================================================*
// MARK: * UInt16
//*============================================================================*

extension UInt16: ValuableUInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Precise
    //=------------------------------------------------------------------------=

    public static let precision: Capacity = precision(5)
}

//*============================================================================*
// MARK: * UInt32
//*============================================================================*

extension UInt32: ValuableUInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Precise
    //=------------------------------------------------------------------------=

    public static let precision: Capacity = precision(10)
}

//*============================================================================*
// MARK: * UInt64
//*============================================================================*

extension UInt64: ValuableUInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Precise, Boundable
    //=------------------------------------------------------------------------=

    /// Apple, please fix IntegerFormatStyleU«Int64» because it uses an Int64.
    public static let precision: Capacity = Int64.precision
    
    /// Apple, please fix IntegerFormatStyleU«Int64» because it uses an Int64.
    public static let maxLosslessValue: UInt64 = UInt64(Int64.maxLosslessValue)
}
