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
// MARK: * Decimal
//*============================================================================*

extension Decimal.FormatStyle: Format, Formats.Number,
Formats.Currencyable, Formats.Percentable {
    
    //=------------------------------------------------------------------------=
    // MARK: Scheme
    //=------------------------------------------------------------------------=
    
    @inlinable public func scheme() -> some NumericTextScheme {
        Schemes.Standard.reuse(self)
    }
}

//*============================================================================*
// MARK: * Floating Point
//*============================================================================*

extension FloatingPointFormatStyle: Format, Formats.Number,
Formats.Currencyable, Formats.Percentable where FormatInput: NumericTextValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Scheme
    //=------------------------------------------------------------------------=
    
    @inlinable public func scheme() -> some NumericTextScheme {
        Schemes.Standard.reuse(self)
    }
}

//*============================================================================*
// MARK: * Integer
//*============================================================================*

extension IntegerFormatStyle: Format, Formats.Number,
Formats.Currencyable where FormatInput: NumericTextValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Scheme
    //=------------------------------------------------------------------------=
    
    @inlinable public func scheme() -> some NumericTextScheme {
        Schemes.Standard.reuse(self)
    }
}
