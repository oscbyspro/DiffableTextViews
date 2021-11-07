//
//  PrecisionSubject.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

// MARK: - PrecisionSubject

public protocol PrecisionSubject {
    @inlinable static var maxLosslessDigits:        Int { get }
    @inlinable static var maxLosslessIntegerDigits: Int { get }
    @inlinable static var maxLosslessDecimalDigits: Int { get }
}

// MARK: - Descriptions: Internal

extension PrecisionSubject {
    @inlinable static var float:   Bool { maxLosslessDecimalDigits != 0 }
    @inlinable static var integer: Bool { maxLosslessDecimalDigits == 0 }
}

// MARK: - Specialization: Integer

public protocol IntegerSubject: PrecisionSubject { }
public extension IntegerSubject {
    @inlinable static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable static var maxLosslessDecimalDigits: Int { 0 }
}

// MARK: - Specialization: Float

public protocol FloatSubject: PrecisionSubject { }
public extension FloatSubject {
    @inlinable static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable static var maxLosslessDecimalDigits: Int { maxLosslessDigits }
}
