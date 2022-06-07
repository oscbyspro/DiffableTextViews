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
// MARK: * Format x Number
//*============================================================================*
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension Decimal.FormatStyle:
NumberTextFormat,
NumberTextFormatXNumber,
NumberTextFormatXCurrencyable,
NumberTextFormatXPercentable {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func scheme() -> some NumberTextScheme {
        NumberTextSchemeXStandard.reuse(self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Floating Point
//=----------------------------------------------------------------------------=

extension FloatingPointFormatStyle:
NumberTextFormat,
NumberTextFormatXNumber,
NumberTextFormatXCurrencyable,
NumberTextFormatXPercentable
where FormatInput: NumberTextValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func scheme() -> some NumberTextScheme {
        NumberTextSchemeXStandard.reuse(self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Integer
//=----------------------------------------------------------------------------=

extension IntegerFormatStyle:
NumberTextFormat,
NumberTextFormatXNumber,
NumberTextFormatXCurrencyable
where FormatInput: NumberTextValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func scheme() -> some NumberTextScheme {
        NumberTextSchemeXStandard.reuse(self)
    }
}