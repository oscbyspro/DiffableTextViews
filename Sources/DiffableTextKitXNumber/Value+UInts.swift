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
// MARK: * Value x UInt(s)
//*============================================================================*

private protocol __UInt: BinaryInteger,
NumberTextValueXUnsigned,
NumberTextValueXInteger,
NumberTextValueXNumberable,
NumberTextValueXCurrencyable where
NumberTextStyle == _NumberTextStyle<IntegerFormatStyle<Self>> { }

//=----------------------------------------------------------------------------=
// MARK: + UInt
//=----------------------------------------------------------------------------=

extension UInt: __UInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Int = Int.precision
    public static let bounds: ClosedRange<Self> = 0...Self(Int.bounds.upperBound)
}

//=----------------------------------------------------------------------------=
// MARK: + UInt8
//=----------------------------------------------------------------------------=

extension UInt8: __UInt {

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Int = 3
    public static let bounds: ClosedRange<Self> = bounds()
}

//=----------------------------------------------------------------------------=
// MARK: + UInt16
//=----------------------------------------------------------------------------=

extension UInt16: __UInt {

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Int = 5
    public static let bounds: ClosedRange<Self> = bounds()
}

//=----------------------------------------------------------------------------=
// MARK: + UInt32
//=----------------------------------------------------------------------------=

extension UInt32: __UInt {    

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Int = 10
    public static let bounds: ClosedRange<Self> = bounds()
}

//=----------------------------------------------------------------------------=
// MARK: + UInt64
//=----------------------------------------------------------------------------=

extension UInt64: __UInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=

    public static let precision: Int = Int64.precision
    public static let bounds: ClosedRange<Self> = 0...Self(Int64.bounds.upperBound)
}
