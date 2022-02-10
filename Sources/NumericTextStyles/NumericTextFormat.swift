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

public protocol NumericTextFormat: ParseableFormatStyle where
FormatInput: NumericTextValue, FormatOutput == String {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    typealias Precision = NumberFormatStyleConfiguration.Precision
    typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
        
    @inlinable func sign(style: Sign.Style) -> Self
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
        sign: Sign.Style = .automatic) -> Self {
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

@usableFromInline protocol Standard: NumericTextFormat {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    typealias Configuration = NumberFormatStyleConfiguration
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: Configuration.SignDisplayStrategy) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Standard {
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: Sign.Style) -> Self {
        self.sign(strategy: style.standard())
    }
}

//*============================================================================*
// MARK: * Format x Currency
//*============================================================================*

@usableFromInline protocol Currency: NumericTextFormat {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    typealias Configuration = CurrencyFormatStyleConfiguration
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: Configuration.SignDisplayStrategy) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Currency {
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: Sign.Style) -> Self {
        self.sign(strategy: style.currency())
    }
}

//*============================================================================*
// MARK: * Format x Percent
//*============================================================================*

/// - Note: To use this format, the value must support at least two exponent digits.
@usableFromInline protocol Percent: NumericTextFormat where FormatInput: FloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    typealias Configuration = NumberFormatStyleConfiguration
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: Configuration.SignDisplayStrategy) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension Percent {
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: Sign.Style) -> Self {
        self.sign(strategy: style.standard())
    }
}
