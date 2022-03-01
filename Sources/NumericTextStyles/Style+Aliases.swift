//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NumericTextStyle x Aliases
//*============================================================================*

public typealias NumericTextStyle<Value: NumericTextValue_Numberable> =
_NumericTextStyle<Value.NumericTextFormat_Number>

//*============================================================================*
// MARK: * NumericTextStyle x Aliases x Number
//*============================================================================*

extension NumericTextStyle where Value: NumericTextValue_Numberable {
    public typealias Number = _NumericTextStyle<Value.NumericTextFormat_Number>
}

//*============================================================================*
// MARK: * NumericTextStyle x Aliases x Currency
//*============================================================================*

extension NumericTextStyle where Value: NumericTextValue_Currencyable {
    public typealias Number = _NumericTextStyle<Value.NumericTextFormat_Currency>
}

//*============================================================================*
// MARK: * NumericTextStyle x Aliases x Percent
//*============================================================================*

extension NumericTextStyle where Value: NumericTextValue_Percentable {
    public typealias Number = _NumericTextStyle<Value.NumericTextFormat_Percent>
}

