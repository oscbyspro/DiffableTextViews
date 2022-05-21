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
// MARK: * Value x Int(s)
//*============================================================================*

private protocol _Int: BinaryInteger,
NumberTextValueXSigned,
NumberTextValueXInteger,
NumberTextValueXNumberable,
NumberTextValueXCurrencyable where
NumberTextStyle == _NumberTextStyle<IntegerFormatStyle<Self>> { }

//=----------------------------------------------------------------------------=
// MARK: + Int
//=----------------------------------------------------------------------------=

extension Int: _Int {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Int = String(max).count
    public static let bounds: ClosedRange<Self> = bounds()
}

//=----------------------------------------------------------------------------=
// MARK: + Int8
//=----------------------------------------------------------------------------=

extension Int8: _Int {

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Int = 3
    public static let bounds: ClosedRange<Self> = bounds()
}

//=----------------------------------------------------------------------------=
// MARK: + Int16
//=----------------------------------------------------------------------------=

extension Int16: _Int {

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Int = 5
    public static let bounds: ClosedRange<Self> = bounds()
}

//=----------------------------------------------------------------------------=
// MARK: + Int32
//=----------------------------------------------------------------------------=

extension Int32: _Int {

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Int = 10
    public static let bounds: ClosedRange<Self> = bounds()
}

//=----------------------------------------------------------------------------=
// MARK: + Int64
//=----------------------------------------------------------------------------=

extension Int64: _Int {

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Int = 19
    public static let bounds: ClosedRange<Self> = bounds()
}
