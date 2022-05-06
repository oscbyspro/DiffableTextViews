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
// MARK: Declaration
//*============================================================================*

private protocol _Value:
NumberTextValueXNonoptional,
NumberTextValueXSigned,
NumberTextValueXFloatingPoint,
NumberTextValueXNumberable,
NumberTextValueXCurrencyable,
NumberTextValueXPercentable { }

//*============================================================================*
// MARK: Decimal
//*============================================================================*

extension Decimal: _Value {
    public typealias NumberTextStyle = _NumberTextStyle<FormatStyle>

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Int = 38
    public static let bounds: ClosedRange<Self> = Self.bounds(
    abs: Self(string: String(repeating: "9", count: precision))!)
}

//*============================================================================*
// MARK: Double
//*============================================================================*

extension Double: _Value {
    public typealias NumberTextStyle = _NumberTextStyle<FloatingPointFormatStyle<Self>>
    
    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Int = 15
    public static let bounds: ClosedRange<Self> = Self.bounds(abs: 999_999_999_999_999)
}
