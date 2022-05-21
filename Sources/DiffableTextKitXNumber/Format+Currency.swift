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
// MARK: * Format x Currency
//*============================================================================*
// MARK: + Decimal
//=----------------------------------------------------------------------------=

extension Decimal.FormatStyle.Currency: NumberTextFormat,
NumberTextFormatXCurrency {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func scheme() -> some NumberTextScheme {
        NumberTextSchemeXCurrency.reuse(self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Floating Point
//=----------------------------------------------------------------------------=

extension FloatingPointFormatStyle.Currency: NumberTextFormat,
NumberTextFormatXCurrency where Value: NumberTextValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func scheme() -> some NumberTextScheme {
        NumberTextSchemeXCurrency.reuse(self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Integer
//=----------------------------------------------------------------------------=

extension IntegerFormatStyle.Currency: NumberTextFormat,
NumberTextFormatXCurrency where Value: NumberTextValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func scheme() -> some NumberTextScheme {
        NumberTextSchemeXCurrency.reuse(self)
    }
}
