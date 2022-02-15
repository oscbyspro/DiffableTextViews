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
// MARK: * Table of Contents
//*============================================================================*

@usableFromInline typealias Format = NumericTextFormat
@usableFromInline typealias Standard = NumericTextNumberFormat
@usableFromInline typealias Currency = NumericTextCurrencyFormat
@usableFromInline typealias Percent = NumericTextPercentFormat

//*============================================================================*
// MARK: * Format
//*============================================================================*

public protocol NumericTextFormat: ParseableFormatStyle where FormatInput: NumericTextValue, FormatOutput == String {
    typealias Precision = NumberFormatStyleConfiguration.Precision
    typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
        
    @inlinable func sign(style: NumericTextSignStyle) -> Self
    @inlinable func precision(_ precision: Precision) -> Self
    @inlinable func decimalSeparator(strategy: Separator) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextFormat {
    @usableFromInline typealias Value = FormatInput

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func style(precision: Precision,
        separator: Separator = .automatic,
        sign: SignStyle = .automatic) -> Self {
        self.precision(precision).decimalSeparator(strategy: separator).sign(style: sign)
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Parse
    //=------------------------------------------------------------------------=
    
    @inlinable func parse(_ characters: String) throws -> Value {
        try parseStrategy.parse(characters)
    }
}

//*============================================================================*
// MARK: * Format x Number
//*============================================================================*

public protocol NumericTextNumberFormat: NumericTextFormat {
    typealias Configuration = NumberFormatStyleConfiguration
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: Configuration.SignDisplayStrategy) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextNumberFormat {
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: NumericTextSignStyle) -> Self {
        self.sign(strategy: style.standard())
    }
}

//*============================================================================*
// MARK: * Format x Currency
//*============================================================================*

public protocol NumericTextCurrencyFormat: NumericTextFormat {
    typealias Configuration = CurrencyFormatStyleConfiguration
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: Configuration.SignDisplayStrategy) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextCurrencyFormat {
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: NumericTextSignStyle) -> Self {
        self.sign(strategy: style.currency())
    }
}

//*============================================================================*
// MARK: * Format x Percent
//*============================================================================*

/// - Note: To use this format, the value must support at least two exponent digits.
public protocol NumericTextPercentFormat: NumericTextFormat where FormatInput: NumericTextFloatingPointValue {
    typealias Configuration = NumberFormatStyleConfiguration
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: Configuration.SignDisplayStrategy) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NumericTextPercentFormat {
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: NumericTextSignStyle) -> Self {
        self.sign(strategy: style.standard())
    }
}
