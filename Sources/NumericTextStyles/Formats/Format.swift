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
    typealias PrecisionStyle = NumberFormatStyleConfiguration.Precision
    typealias SeparatorStyle = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    @inlinable func precision(_ precision: PrecisionStyle) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Separator
    //=------------------------------------------------------------------------=
    
    @inlinable func decimalSeparator(strategy: SeparatorStyle) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(style: Sign.Style) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Process
    //=------------------------------------------------------------------------=
    
    @inlinable func process(count: inout Count)
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
    
    //=------------------------------------------------------------------------=
    // MARK: Process
    //=------------------------------------------------------------------------=
    
    @inlinable public func process(count: inout Count) { }
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
    
    //=------------------------------------------------------------------------=
    // MARK: Process
    //=------------------------------------------------------------------------=
    
    @inlinable public func process(count: inout Count) { }
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
    
    @inlinable public func process(count: inout Count) {
        count.downshift(by: 2)
    }
}
