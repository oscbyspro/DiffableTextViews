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
// MARK: * Format
//*============================================================================*

public protocol NumberTextFormat: ParseableFormatStyle where FormatOutput == String,
FormatInput: DiffableTextKitXNumber.NumberTextValue {
    associatedtype NumberTextRoundingIncrement
    associatedtype NumberTextSign: NumberTextFormatXSignRepresentable
    associatedtype NumberTextScheme: DiffableTextKitXNumber.NumberTextScheme

    typealias NFSC = NumberFormatStyleConfiguration
    typealias CFSC = CurrencyFormatStyleConfiguration
    
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
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumberTextFormat {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(_ sign: Sign) -> Self {
        self.sign(strategy: .init(sign == .negative ? .always : .automatic))
    }
    
    @inlinable func separator(_ separator: Separator?) -> Self {
        self.decimalSeparator(strategy: separator != nil ? .always : .automatic)
    }
    
    @inlinable func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        self.rounded(rule: rule, increment: nil)
    }
}

//*============================================================================*
// MARK: * Format x Number
//*============================================================================*

public protocol NumberTextFormatXNumber: NumberTextFormat
where NumberTextSign == NFSC.SignDisplayStrategy {

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale)
}

//*============================================================================*
// MARK: * Format x Currency
//*============================================================================*

public protocol NumberTextFormatXCurrency: NumberTextFormat
where NumberTextSign == CFSC.SignDisplayStrategy {
    
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

public protocol NumberTextFormatXPercent: NumberTextFormat
where NumberTextSign == NFSC.SignDisplayStrategy {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(locale: Locale)    
}

//*============================================================================*
// MARK: * Format x Branchable(s)
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
