//
//  Precise.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

// MARK: - Precise

public protocol Precise {
    @inlinable static var maxLosslessDigits:        Int { get }
    @inlinable static var maxLosslessIntegerDigits: Int { get }
    @inlinable static var maxLosslessDecimalDigits: Int { get }
}

// MARK: - Precise: Descriptions

extension Precise {
    @inlinable static var isFloat:   Bool { maxLosslessDecimalDigits >= 0 }
    @inlinable static var isInteger: Bool { maxLosslessDecimalDigits == 0 }
}

// MARK: - Specialization: Integer

public protocol Integer: Precise { }
public extension Integer {
    @inlinable static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable static var maxLosslessDecimalDigits: Int { 0 }
}

// MARK: - Specialization: Float

public protocol Float: Precise { }
public extension Float {
    @inlinable static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable static var maxLosslessDecimalDigits: Int { maxLosslessDigits }
}
