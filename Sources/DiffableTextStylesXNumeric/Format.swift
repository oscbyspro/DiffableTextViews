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
// MARK: * Content
//*============================================================================*

@usableFromInline typealias Format = NumericTextFormat; @usableFromInline enum Formats {
    //=------------------------------------------=
    // MARK: Types
    //=------------------------------------------=
    @usableFromInline typealias Number   = NumericTextFormatXNumber
    @usableFromInline typealias Currency = NumericTextFormatXCurrency
    @usableFromInline typealias Percent  = NumericTextFormatXPercent
    //=------------------------------------------=
    // MARK: Branches
    //=------------------------------------------=
    @usableFromInline typealias Numberable   = NumericTextFormatXNumberable
    @usableFromInline typealias Currencyable = NumericTextFormatXCurrencyable
    @usableFromInline typealias Percentable  = NumericTextFormatXPercentable
}

//*============================================================================*
// MARK: * Format
//*============================================================================*

public protocol NumericTextFormat: ParseableFormatStyle where FormatInput: NumericTextValue, FormatOutput == String {
    associatedtype NumericTextScheme: DiffableTextStylesXNumeric.NumericTextScheme
    associatedtype SignDisplayStrategy: NumericTextSignDisplayStrategyRepresentable
    associatedtype RoundingIncrement
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: Self.SignDisplayStrategy) -> Self
    @inlinable func precision(_ precision: NumberFormatStyleConfiguration.Precision) -> Self
    @inlinable func decimalSeparator(strategy: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> Self
    @inlinable func rounded(rule: FloatingPointRoundingRule, increment: Self.RoundingIncrement?) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Scheme
    //=------------------------------------------------------------------------=
    
    @inlinable func scheme() -> NumericTextScheme    
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextFormat {
    @usableFromInline typealias Value = FormatInput
    @usableFromInline typealias Precision = NumberFormatStyleConfiguration.Precision
    @usableFromInline typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    @usableFromInline typealias Rounded = FloatingPointRoundingRule
    @usableFromInline typealias Sign = NumericTextSignDisplayStrategy

    //=------------------------------------------------------------------------=
    // MARK: Parse
    //=------------------------------------------------------------------------=
    
    @inlinable func parse(_ characters: String) throws -> Value {
        try parseStrategy.parse(characters)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    /// The format should always round towards zero.
    @inlinable func autocorrect() -> Self {
        self.rounded(.towardZero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(_ strategy: Self.Sign) -> Self {
        self.sign(strategy: SignDisplayStrategy(strategy))
    }
    
    @inlinable func separator(_ strategy: Self.Separator) -> Self {
        self.decimalSeparator(strategy: strategy)
    }
    
    @inlinable func rounded(_ strategy: Self.Rounded) -> Self {
        self.rounded(rule: strategy, increment: nil)
    }
}

//*============================================================================*
// MARK: * Format x Number
//*============================================================================*

public protocol NumericTextFormatXNumber: NumericTextFormat where
SignDisplayStrategy == NumberFormatStyleConfiguration.SignDisplayStrategy {

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale)
}

//*============================================================================*
// MARK: * Format x Currency
//*============================================================================*

public protocol NumericTextFormatXCurrency: NumericTextFormat where
SignDisplayStrategy == CurrencyFormatStyleConfiguration.SignDisplayStrategy {
    
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

public protocol NumericTextFormatXPercent: NumericTextFormat where
SignDisplayStrategy == NumberFormatStyleConfiguration.SignDisplayStrategy {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale)    
}

//*============================================================================*
// MARK: * Format x Branches x Number
//*============================================================================*

public protocol NumericTextFormatXNumberable: NumericTextFormat {
    associatedtype Number: NumericTextFormatXNumber where Number.FormatInput == FormatInput
}

//*============================================================================*
// MARK: * Format x Branches x Currency
//*============================================================================*

public protocol NumericTextFormatXCurrencyable: NumericTextFormat {
    associatedtype Currency: NumericTextFormatXCurrency where Currency.FormatInput == FormatInput
}

//*============================================================================*
// MARK: * Format x Branches x Percent
//*============================================================================*

public protocol NumericTextFormatXPercentable: NumericTextFormat {
    associatedtype Percent: NumericTextFormatXPercent where Percent.FormatInput == FormatInput
}
