//
//  Decimal.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-10-18.
//

import Foundation

//*============================================================================*
// MARK: * Decimal
//*============================================================================*

extension Decimal: Valuable, PreciseFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Valuable - Options
    //=------------------------------------------------------------------------=
    
    public static let options: Options = .floatingPoint

    //=------------------------------------------------------------------------=
    // MARK: Precise - Digits
    //=------------------------------------------------------------------------=
 
    public static let maxLosslessSignificantDigits: Int = 38
    
    //=------------------------------------------------------------------------=
    // MARK: Boundable - Values
    //=------------------------------------------------------------------------=
        
    @inlinable public static var minLosslessValue: Self   { -maxLosslessLimit }
    @inlinable public static var maxLosslessValue: Self   {  maxLosslessLimit }
    @usableFromInline static let maxLosslessLimit: Self = {
        Decimal(string: String(repeating: "9", count: maxLosslessSignificantDigits))!
    }()

    //=------------------------------------------------------------------------=
    // MARK: Formattable - Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable public static func make(description: String) -> Optional<Self> {
        .init(string: description)
    }
    
    //
    // MARK: Formattable - Styles
    //=------------------------------------------------------------------------=
    
    @inlinable public static func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}
