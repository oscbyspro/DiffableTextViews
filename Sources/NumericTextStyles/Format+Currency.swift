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

extension Decimal.FormatStyle.Currency: Format, Formats.Currency {
    @inlinable public func translation() -> some NumericTextTranslation {
        Translations.Currency.reuseable(self)
    }
}

//*============================================================================*
// MARK: * Floating Point
//*============================================================================*

extension FloatingPointFormatStyle.Currency: Format, Formats.Currency where Value: NumericTextValue {
    @inlinable public func translation() -> some NumericTextTranslation {
        Translations.Currency.reuseable(self)
    }
}

//*============================================================================*
// MARK: * Integer
//*============================================================================*

extension IntegerFormatStyle.Currency: Format, Formats.Currency where Value: NumericTextValue {
    @inlinable public func translation() -> some NumericTextTranslation {
        Translations.Currency.reuseable(self)
    }
}
