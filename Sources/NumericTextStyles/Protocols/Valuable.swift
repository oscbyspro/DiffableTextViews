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

// MARK: - ValuableFloatingPoint

@usableFromInline protocol ValuableFloatingPoint: Valuable, FormattableFloatingPoint, BoundableFloatingPoint, PreciseFloatingPoint { }

// MARK: - ValuableFloatingPoint: Details

extension ValuableFloatingPoint {
    
    // MARK: Implementation
    
    @inlinable public static var options: Options {
        .floatingPoint
    }
}

// MARK: - ValuableTextInteger

@usableFromInline protocol ValuableTextInteger: Valuable, FormattableInteger, BoundableInteger, PreciseInteger { }
extension ValuableTextInteger {
    
    // MARK: Implementation
    
    @inlinable public static var options: Options {
        .integer
    }
}

// MARK: - ValuableUnsignedInteger

@usableFromInline protocol ValuableUnsignedInteger: Valuable, FormattableInteger, BoundableInteger, PreciseInteger { }

// MARK: - ValuableUnsignedInteger: Details

extension ValuableUnsignedInteger {
    
    // MARK: Implementation
    
    @inlinable public static var options: Options {
        .unsignedInteger
    }
}
