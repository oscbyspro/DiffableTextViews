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

public protocol Format: ParseableFormatStyle {
    typealias Precision = NumberFormatStyleConfiguration.Precision
    typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ precision: Precision) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Separator
    //=------------------------------------------------------------------------=
    
    @inlinable func decimalSeparator(strategy: Separator) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(style: Sign.Style) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Process
    //=------------------------------------------------------------------------=
    
    @inlinable static func process(precision: inout Count)
}

//=----------------------------------------------------------------------------=
// MARK: Format - Details
//=----------------------------------------------------------------------------=

extension Format {
    
    //=------------------------------------------------------------------------=
    // MARK: Process
    //=------------------------------------------------------------------------=
    
    @inlinable public static func process(precision: inout Count) { }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func style(precision: Precision, separator: Separator = .automatic, sign: Sign.Style = .automatic) -> Self {
        self.precision(precision).decimalSeparator(strategy: separator).sign(style: sign)
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

@usableFromInline protocol PercentFormat: Format {
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
    
    //=------------------------------------------------------------------------=
    // MARK: Process
    //=------------------------------------------------------------------------=
    
    @inlinable public static func process(precision: inout Count) {
        precision.integer  =        precision.integer  + 2
        precision.fraction = max(0, precision.fraction - 2)
    }
}
