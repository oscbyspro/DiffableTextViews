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
// MARK: * Format x Decimal
//*============================================================================*

extension Decimal.FormatStyle: Format.Number {
    @inlinable public func specialization() -> some NumericTextSpecialization {
        NumericTextStyles.Standard.cached(self)
    }
}

extension Decimal.FormatStyle.Currency: Format.Currency {
    @inlinable public func specialization() -> some NumericTextSpecialization {
        NumericTextStyles.Currency.cached(self)
    }
}

extension Decimal.FormatStyle.Percent: Format.Percent {
    @inlinable public func specialization() -> some NumericTextSpecialization {
        NumericTextStyles.Standard.cached(self)
    }
}

//*============================================================================*
// MARK: * Format x Float
//*============================================================================*

extension FloatingPointFormatStyle: Format, Format.Number where FormatInput: NumericTextFloatValue {
    @inlinable public func specialization() -> some NumericTextSpecialization {
        NumericTextStyles.Standard.cached(self)
    }
}

extension FloatingPointFormatStyle.Currency: Format, Format.Currency where FormatInput: NumericTextFloatValue {
    @inlinable public func specialization() -> some NumericTextSpecialization {
        NumericTextStyles.Currency.cached(self)
    }
}

extension FloatingPointFormatStyle.Percent: Format, Format.Percent where FormatInput: NumericTextFloatValue {
    @inlinable public func specialization() -> some NumericTextSpecialization {
        NumericTextStyles.Standard.cached(self)
    }
}

//*============================================================================*
// MARK: * Format x Integer
//*============================================================================*

extension IntegerFormatStyle: Format, Format.Number where FormatInput: NumericTextIntegerValue {
    @inlinable public func specialization() -> some NumericTextSpecialization {
        NumericTextStyles.Standard.cached(self)
    }
}

extension IntegerFormatStyle.Currency: Format, Format.Currency where FormatInput: NumericTextIntegerValue {
    @inlinable public func specialization() -> some NumericTextSpecialization {
        NumericTextStyles.Currency.cached(self)
    }
}
