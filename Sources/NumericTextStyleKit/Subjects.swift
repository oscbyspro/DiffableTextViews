//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

#warning("WIP, move each subject to its own file.")

public protocol BoundsSubject: Comparable {
    @inlinable static var zero:             Self { get }
    @inlinable static var minLosslessValue: Self { get }
    @inlinable static var maxLosslessValue: Self { get }
}

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
extension IntegerSubject {
    @inlinable static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable static var maxLosslessDecimalDigits: Int { 0 }
}

// MARK: - Specialization: Float

public protocol FloatSubject: PrecisionSubject { }
extension FloatSubject {
    @inlinable public static var maxLosslessIntegerDigits: Int { maxLosslessDigits }
    @inlinable public static var maxLosslessDecimalDigits: Int { maxLosslessDigits }
}


#warning("WIP")

import struct Foundation.Locale
import protocol Foundation.FormatStyle
import enum Foundation.NumberFormatStyleConfiguration

@usableFromInline protocol FormatSubject {
    associatedtype FormatStyle: Foundation.FormatStyle where FormatStyle.FormatInput == Self, FormatStyle.FormatOutput == String
    
    // MARK: Aliases
    
    typealias Precision = NumberFormatStyleConfiguration.Precision
    typealias Separator = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy
    
    // MARK: Utilities
    
    @inlinable static func value(_ components: Components) -> Self?
    @inlinable static func style(_ locale: Locale, precision: Precision, separator: Separator) -> FormatStyle
}
