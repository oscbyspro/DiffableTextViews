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

extension Decimal: Valuable, BoundableFloatingPoint, PreciseFloatingPoint {
    
    //=------------------------------------------------------------------------=
    // MARK: Options
    //=------------------------------------------------------------------------=
    
    public static let options: Options = .floatingPoint

    //=------------------------------------------------------------------------=
    // MARK: Precision
    //=------------------------------------------------------------------------=
    
    public static let precision: Capacity = precision(38)
    
    //=------------------------------------------------------------------------=
    // MARK: Bounds
    //=------------------------------------------------------------------------=

    public static let bounds: ClosedRange<Self> = bounds(limit: Self(string: String(repeating: "9", count: 38))!)
    
    //=------------------------------------------------------------------------=
    // MARK: Make
    //=------------------------------------------------------------------------=
    
    @inlinable public static func make(description: String) -> Optional<Self> {
        .init(string: description)
    }

    //=------------------------------------------------------------------------=
    // MARK: Styles
    //=------------------------------------------------------------------------=
    
    @inlinable public static func style(locale: Locale, precision: PrecisionStyle, separator: SeparatorStyle) -> FormatStyle {
        .init(locale: locale).precision(precision).decimalSeparator(strategy: separator)
    }
}
