//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation
import DiffableTextViews

//*============================================================================*
// MARK: * Content
//*============================================================================*

@usableFromInline typealias Format = NumericTextFormat; extension Format {
    @usableFromInline typealias Number = NumericTextNumberFormat
    @usableFromInline typealias Currency = NumericTextCurrencyFormat
    @usableFromInline typealias Percent = NumericTextPercentFormat
}

//*============================================================================*
// MARK: * Format
//*============================================================================*

public protocol NumericTextFormat: ParseableFormatStyle where FormatInput: NumericTextValue, FormatOutput == String {
    associatedtype Translation: NumericTextTranslation
    associatedtype _Sign: NumericTextSignDisplayStrategyRepresentable
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: Self._Sign) -> Self
    @inlinable func precision(_ precision: NumberFormatStyleConfiguration.Precision) -> Self
    @inlinable func decimalSeparator(strategy: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Translation
    //=------------------------------------------------------------------------=
    
    @inlinable func translation() -> Translation
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextFormat {
    @usableFromInline typealias Value = FormatInput
    @usableFromInline typealias Precision = NumberFormatStyleConfiguration.Precision
    @usableFromInline typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    @usableFromInline typealias Sign = NumericTextSignDisplayStrategy
    
    //=------------------------------------------------------------------------=
    // MARK: Parse
    //=------------------------------------------------------------------------=
    
    @inlinable func parse(_ characters: String) throws -> Value {
        try parseStrategy.parse(characters)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func separator(_ strategy: Self.Separator) -> Self {
        self.decimalSeparator(strategy: strategy)
    }
    
    @inlinable func sign(_ strategy: Self.Sign) -> Self {
        self.sign(strategy: _Sign(strategy))
    }
}

//*============================================================================*
// MARK: * Format x Number
//*============================================================================*

public protocol NumericTextNumberFormat: NumericTextFormat where
_Sign == NumberFormatStyleConfiguration.SignDisplayStrategy {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale)
}

//*============================================================================*
// MARK: * Format x Currency
//*============================================================================*

public protocol NumericTextCurrencyFormat: NumericTextFormat where
_Sign == CurrencyFormatStyleConfiguration.SignDisplayStrategy {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var currencyCode: String { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(code: String, locale: Locale)
}

//*============================================================================*
// MARK: * Format x Percent
//*============================================================================*

public protocol NumericTextPercentFormat: NumericTextFormat where
_Sign == NumberFormatStyleConfiguration.SignDisplayStrategy, FormatInput: NumericTextFloatValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale)
}
