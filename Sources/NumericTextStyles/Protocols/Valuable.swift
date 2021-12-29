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

// MARK: - Valuable x Float

@usableFromInline protocol ValuableFloat: Valuable, FormattableFloatingPoint, BoundableFloatingPoint, PreciseFloatingPoint { }
extension ValuableFloat {
    
    // MARK: Implementation
    
    @inlinable public static var options: Options { .floatingPoint }
}

// MARK: - Valuable x Int

@usableFromInline protocol ValuableInt: Valuable, FormattableInteger, BoundableInteger, PreciseInteger { }
extension ValuableInt {
    
    // MARK: Implementation
    
    @inlinable public static var options: Options { .integer }
}

// MARK: - Valuable x UInt

@usableFromInline protocol ValuableUInt: Valuable, FormattableInteger, BoundableInteger, PreciseInteger { }
extension ValuableUInt {
    
    // MARK: Implementation
    
    @inlinable public static var options: Options { .unsignedInteger }
}
