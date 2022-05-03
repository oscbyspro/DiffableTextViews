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

public protocol NumberTextFormat: ParseableFormatStyle where FormatOutput == String,
FormatInput: DiffableTextStylesXNumber.NumberTextValue {
    associatedtype NumberTextRoundingIncrement
    associatedtype NumberTextSign: NumberTextFormatXSignRepresentable
    associatedtype NumberTextScheme: DiffableTextStylesXNumber.NumberTextScheme
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var locale: Locale { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: NumberTextSign) -> Self
    
    @inlinable func precision(_ precision: NFSC.Precision) -> Self
    
    @inlinable func decimalSeparator(
    strategy: NFSC.DecimalSeparatorDisplayStrategy) -> Self
    
    @inlinable func rounded(rule: FloatingPointRoundingRule,
    increment: Self.NumberTextRoundingIncrement?) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func scheme() -> NumberTextScheme
}

//=----------------------------------------------------------------------------=
// MARK: Details
//=----------------------------------------------------------------------------=

extension NumberTextFormat {
    @usableFromInline typealias Value = FormatInput
    @usableFromInline typealias Sign = NumberTextFormat_Sign
    @usableFromInline typealias Precision = NFSC.Precision
    @usableFromInline typealias Separator = NFSC.DecimalSeparatorDisplayStrategy
    @usableFromInline typealias Rounding = FloatingPointRoundingRule
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(_ strategy: Sign) -> Self {
        self.sign(strategy: .init(strategy))
    }
    
    @inlinable func separator(_ strategy: Separator) -> Self {
        self.decimalSeparator(strategy: strategy)
    }
    
    @inlinable func rounded(_ strategy: Rounding) -> Self {
        self.rounded(rule: strategy, increment: nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func parse(_ characters: String) throws -> Value {
        try parseStrategy.parse(characters)
    }
}

//*============================================================================*
// MARK: x Number
//*============================================================================*

public protocol NumberTextFormatXNumber: NumberTextFormat where
NumberTextSign == NFSC.SignDisplayStrategy {

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale)
}

//*============================================================================*
// MARK: x Currency
//*============================================================================*

public protocol NumberTextFormatXCurrency: NumberTextFormat where
NumberTextSign == CFSC.SignDisplayStrategy {
    
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
// MARK: x Percent
//*============================================================================*

public protocol NumberTextFormatXPercent: NumberTextFormat where
NumberTextSign == NFSC.SignDisplayStrategy {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale)    
}

//*============================================================================*
// MARK: x Branchables
//*============================================================================*

public protocol NumberTextFormatXNumberable: NumberTextFormat {
    associatedtype Number: NumberTextFormatXNumber
    where Number.FormatInput == FormatInput
}

public protocol NumberTextFormatXCurrencyable: NumberTextFormat {
    associatedtype Currency: NumberTextFormatXCurrency
    where Currency.FormatInput == FormatInput
}

public protocol NumberTextFormatXPercentable: NumberTextFormat {
    associatedtype Percent: NumberTextFormatXPercent
    where Percent.FormatInput == FormatInput
}