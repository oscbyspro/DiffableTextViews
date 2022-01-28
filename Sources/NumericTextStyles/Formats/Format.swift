//
//  Format.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import Foundation

//*============================================================================*
// MARK: * Format
//*============================================================================*

public protocol Format: ParseableFormatStyle where FormatInput: NumericTextStyles.Value, FormatOutput == String {
    typealias Precision = NumberFormatStyleConfiguration.Precision
    typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
        
    @inlinable func precision(_ precision: Precision) -> Self
    @inlinable func decimalSeparator(strategy: Separator) -> Self
    @inlinable func sign(style: Sign.Style) -> Self
    @inlinable func rounded(rule: FloatingPointRoundingRule) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: Format - Details
//=----------------------------------------------------------------------------=

extension Format {
    @usableFromInline typealias Value = FormatInput

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func style(precision: Precision, separator: Separator = .automatic, sign: Sign.Style = .automatic) -> Self {
        self.precision(precision).decimalSeparator(strategy: separator).sign(style: sign).rounded(rule: .towardZero)
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func parse(_ characters: String) throws -> Value {
        try parseStrategy.parse(characters)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrections
    //=------------------------------------------------------------------------=
        
    @inlinable func autocorrect(_ value: inout Value) {
        value = (try? parseStrategy.parse(format(value))) ?? value
    }
}

//*============================================================================*
// MARK: * Format x Number
//*============================================================================*

@usableFromInline protocol NumberFormat: Format {
    typealias Configuration = NumberFormatStyleConfiguration
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: Configuration.SignDisplayStrategy) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: Format x Number - Details
//=----------------------------------------------------------------------------=

extension NumberFormat {
    
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

@usableFromInline protocol CurrencyFormat: Format {
    typealias Configuration = CurrencyFormatStyleConfiguration
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: Configuration.SignDisplayStrategy) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: Format x Currency - Details
//=----------------------------------------------------------------------------=

extension CurrencyFormat {
    
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

/// - Note: To use this format, the value must support a shift of at least 2 digits.
@usableFromInline protocol PercentFormat: Format where FormatInput: FloatingPointValue {
    typealias Configuration = NumberFormatStyleConfiguration
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(strategy: Configuration.SignDisplayStrategy) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: Format x Percent - Details
//=----------------------------------------------------------------------------=

extension PercentFormat {
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable public func sign(style: Sign.Style) -> Self {
        self.sign(strategy: style.standard())
    }
}

//*============================================================================*
// MARK: * Format x Roundable
//*============================================================================*

@usableFromInline protocol RoundableByIncrementFormat: Format {
    associatedtype Increment
    
    //=------------------------------------------------------------------------=
    // MARK: Round
    //=------------------------------------------------------------------------=
    
    @inlinable func rounded(rule: FloatingPointRoundingRule, increment: Increment?) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: Format x Roundable - Details
//=----------------------------------------------------------------------------=

extension RoundableByIncrementFormat {
    
    //=------------------------------------------------------------------------=
    // MARK: Round
    //=------------------------------------------------------------------------=
    
    @inlinable public func rounded(rule: FloatingPointRoundingRule) -> Self {
        rounded(rule: rule, increment: nil)
    }
}
