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
// MARK: * Value x Float(s)
//*============================================================================*

private protocol _Float: BinaryFloatingPoint,
NumberTextValueXSigned,
NumberTextValueXFloatingPoint,
NumberTextValueXNumberable,
NumberTextValueXCurrencyable,
NumberTextValueXPercentable where
NumberTextStyle == _NumberTextStyle<FloatingPointFormatStyle<Self>> { }

//=----------------------------------------------------------------------------=
// MARK: + Double
//=----------------------------------------------------------------------------=

extension Double: _Float {
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Int = 15
    public static let bounds: ClosedRange<Self> = Self.bounds(abs: 999_999_999_999_999)
}
