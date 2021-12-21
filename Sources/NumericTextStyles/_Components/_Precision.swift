//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import enum Foundation.NumberFormatStyleConfiguration

// MARK: - Precision

#warning("WIP")
#warning("Remake: Total & Parts, maybe.")
public struct _Precision<Value: Precise> {
    @usableFromInline typealias Defaults = _PrecisionDefaults
    
    // MARK: Properties
    
    @usableFromInline let integer: ClosedRange<Int>
    @usableFromInline let fraction: ClosedRange<Int>
    
    // MARK: Initializers
    
    #warning("Precondition or transformations, maybe.")
    @inlinable init(integer: ClosedRange<Int>, fraction: ClosedRange<Int>) {
        self.integer = integer
        self.fraction = fraction
    }
    
    // MARK: Showcase: Styles
    
    @inlinable func showcaseStyle() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }
    
    // MARK: Editable: Styles
    
    @inlinable func editableStyle() -> NumberFormatStyleConfiguration.Precision {
        let integer = Defaults.integerLowerBound...Value.maxLosslessIntegerDigits
        let fraction = Defaults.fractionLowerBound...Value.maxLosslessDecimalDigits

        return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
    }

    #warning("Maybe could take a _Number instead.")
    @inlinable func editableStyle(numberOfDigits: NumberOfDigits) -> NumberFormatStyleConfiguration.Precision {
        let integerUpperBound = Swift.max(Defaults.integerLowerBound, numberOfDigits.upper)
        let fractionLowerBound = Swift.max(Defaults.fractionLowerBound, numberOfDigits.lower)

        let upper = Defaults.integerLowerBound...integerUpperBound
        let lower = fractionLowerBound...fractionLowerBound

        return .integerAndFractionLength(integerLimits: upper, fractionLimits: lower)
    }
    
    // MARK: Editable: Validation
    
    #warning("Should not be optional, probably.")
    @inlinable func editableValidationWithCapacity(numberOfDigits: NumberOfDigits) -> NumberOfDigits? {
        let totalCapacity = Value.maxLosslessDigits - numberOfDigits.upper - numberOfDigits.lower
        guard totalCapacity >= 0 else { return nil }
        
        let integerCapacity = integer.upperBound - numberOfDigits.upper
        guard integerCapacity >= 0 else { return nil }
        
        let fractionCapacity = fraction.upperBound - numberOfDigits.lower
        guard fractionCapacity >= 0 else { return nil }
        
        return NumberOfDigits(upper: integerCapacity, lower: fractionCapacity)
    }
}

// MARK: - Defaults

#warning("Removable, kinda.")
@usableFromInline enum _PrecisionDefaults {
    @usableFromInline static let totalLowerBound: Int = 1
    @usableFromInline static let integerLowerBound: Int = 1
    @usableFromInline static let fractionLowerBound: Int = 0
}
