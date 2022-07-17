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
// MARK: * Input x Decimal(s)
//*============================================================================*

private protocol _Decimal:
_Input_Signed,
_Input_Float,
_Value_Numberable,
_Value_Percentable,
_Value_Currencyable { }

//=----------------------------------------------------------------------------=
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension Decimal: _Decimal {
    public typealias NumberTextStyle = _DefaultGraph_Standard<Decimal.FormatStyle>.Style

    //=------------------------------------------------------------------------=
    // MARK: Precision, Bounds
    //=------------------------------------------------------------------------=
    
    public static let precision: Int = 38
    public static let bounds: ClosedRange<Self> = Self.bounds(
    abs: Self(string: String(repeating: "9", count: precision))!)
}

//=----------------------------------------------------------------------------=
// MARK: + Format
//=----------------------------------------------------------------------------=

extension Decimal.FormatStyle:
_Format,
_Format_Standard,
_Format_Number,
_Format_Currencyable,
_Format_Percentable {    
    public typealias NumberTextGraph = _DefaultGraph_Standard<Self>
}

extension Decimal.FormatStyle.Percent:
_Format,
_Format_Standard,
_Format_Percent {
    public typealias NumberTextGraph = _DefaultGraph_Standard<Self>
}

extension Decimal.FormatStyle.Currency:
_Format,
_Format_Currency {
    public typealias NumberTextGraph = _DefaultGraph_Currency<Self>
}
