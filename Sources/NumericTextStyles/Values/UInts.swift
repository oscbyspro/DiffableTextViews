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
    // MARK: Boundable, Precise - Values, Digits
    //=------------------------------------------------------------------------=
        
    /// Apple, please fix IntegerFormatStyle«UInt» because it uses an Int.
    public static let maxLosslessValue: UInt = UInt(Int.maxLosslessValue)

    /// Apple, please fix IntegerFormatStyle«UInt» because it uses an Int.
    public static let maxLosslessSignificantDigits: Int = Int.maxLosslessSignificantDigits
}

//*============================================================================*
// MARK: * UInt8
//*============================================================================*

extension UInt8: ValuableUInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Precise - Digits
    //=------------------------------------------------------------------------=

    public static let maxLosslessSignificantDigits: Int = 3
}

//*============================================================================*
// MARK: * UInt16
//*============================================================================*

extension UInt16: ValuableUInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Precise - Digits
    //=------------------------------------------------------------------------=
    
    public static let maxLosslessSignificantDigits: Int = 5
}

//*============================================================================*
// MARK: * UInt32
//*============================================================================*

extension UInt32: ValuableUInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Precise - Digits
    //=------------------------------------------------------------------------=
    
    public static let maxLosslessSignificantDigits: Int = 10
}

//*============================================================================*
// MARK: * UInt64
//*============================================================================*

extension UInt64: ValuableUInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Boundable, Precise - Values, Digits
    //=------------------------------------------------------------------------=
    
    /// Apple, please fix IntegerFormatStyleU«Int64» because it uses an Int64.
    public static let maxLosslessValue: UInt64 = UInt64(Int64.maxLosslessValue)

    /// Apple, please fix IntegerFormatStyleU«Int64» because it uses an Int64.
    public static let maxLosslessSignificantDigits: Int = Int64.maxLosslessSignificantDigits
}
