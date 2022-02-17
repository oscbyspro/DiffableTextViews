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
// MARK: * Table of Contents
//*============================================================================*

@usableFromInline typealias Format = NumericTextFormat
@usableFromInline typealias NumberFormat = NumericTextNumberFormat
@usableFromInline typealias CurrencyFormat = NumericTextCurrencyFormat
@usableFromInline typealias PercentFormat = NumericTextPercentFormat

//*============================================================================*
// MARK: * Format
//*============================================================================*

public protocol NumericTextFormat: ParseableFormatStyle where FormatInput: NumericTextValue, FormatOutput == String {
    associatedtype SignDisplayStrategy: NumericTextSignDisplayStrategyRepresentable =
    NumberFormatStyleConfiguration.SignDisplayStrategy
    typealias NumericTextStyle = NumericTextStyles.NumericTextStyle<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: SignDisplayStrategy) -> Self
    @inlinable func precision(_ precision: NumberFormatStyleConfiguration.Precision) -> Self
    @inlinable func decimalSeparator(strategy: NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Specialization
    //=------------------------------------------------------------------------=
    
    associatedtype Specialization: NumericTextSpecialization = Standard
    @inlinable func specialization(_ locale: Locale) -> Specialization
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
        self.sign(strategy: SignDisplayStrategy(strategy: strategy))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Standard
//=----------------------------------------------------------------------------=

extension NumericTextFormat where Specialization == Standard {
    
    //=------------------------------------------------------------------------=
    // MARK: Specialization
    //=------------------------------------------------------------------------=
    
    @inlinable public func specialication(_ locale: Locale) -> Specialization {
        Specialization(locale: locale)
    }
}

//*============================================================================*
// MARK: * Format x Number
//*============================================================================*

public protocol NumericTextNumberFormat: NumericTextFormat { }

//*============================================================================*
// MARK: * Format x Currency
//*============================================================================*

public protocol NumericTextCurrencyFormat: NumericTextFormat where Specialization == Currency,
SignDisplayStrategy == CurrencyFormatStyleConfiguration.SignDisplayStrategy {
    
    //=------------------------------------------------------------------------=
    // MARK: Requirements
    //=------------------------------------------------------------------------=
    
    @inlinable var currencyCode: String { get }
}


//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextCurrencyFormat {
    
    //=------------------------------------------------------------------------=
    // MARK: Specialization
    //=------------------------------------------------------------------------=
    
    @inlinable public func specialication(_ locale: Locale) -> Specialization {
        Specialization(code: currencyCode,  locale: locale)
    }
}

//*============================================================================*
// MARK: * Format x Percent
//*============================================================================*

/// To use this format, the value must support at least two exponent digits.
public protocol NumericTextPercentFormat: NumericTextFormat where FormatInput: NumericTextFloatingPointValue { }
