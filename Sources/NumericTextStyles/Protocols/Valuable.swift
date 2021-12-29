//
//  Valuable.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

// MARK: - Valuable

public protocol Valuable: Formattable, Boundable, Precise {
    
    // MARK: Requirements
    
    @inlinable static var options: Options { get }
}

// MARK: - ValuableFloat

@usableFromInline protocol ValuableFloat: Valuable, FormattableFloat, BoundableFloat, PreciseFloat { }

// MARK: - ValuableFloat: Details

extension ValuableFloat {
    
    // MARK: Implementation
    
    @inlinable public static var options: Options {
        .floatingPoint
    }
}

// MARK: - ValuableInt

@usableFromInline protocol ValuableInt: Valuable, FormattableInteger, BoundableInteger, PreciseInteger { }
extension ValuableInt {
    
    // MARK: Implementation
    
    @inlinable public static var options: Options {
        .integer
    }
}

// MARK: - ValuableUInt

@usableFromInline protocol ValuableUInt: Valuable, FormattableInteger, BoundableInteger, PreciseInteger { }

// MARK: - ValuableUInt: Details

extension ValuableUInt {
    
    // MARK: Implementation
    
    @inlinable public static var options: Options {
        .unsignedInteger
    }
}
