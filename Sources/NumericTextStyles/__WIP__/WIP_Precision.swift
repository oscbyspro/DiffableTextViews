//
//  Precision.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-17.
//

#warning("Add djustment method.")

import DiffableTextViews
import Foundation

//*============================================================================*
// MARK: * Precision
//*============================================================================*

public struct WIP_Precision<Value: Precise> {
    @usableFromInline typealias Namespace = _WIP_Precision
    @usableFromInline typealias Style = NumberFormatStyleConfiguration.Precision
    @usableFromInline typealias Kind = Namespace.Kind
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let kind: Kind
    @usableFromInline var min: Count
    @usableFromInline var max: Count
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(kind: Kind, min: Count, max: Count) {
        self.kind = kind
        self.min  = min
        self.max  = max
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Showcase
    //=------------------------------------------------------------------------=
    
    @inlinable func showcase() -> Style {
        switch kind {
        case .value:
            let value = min.value ... max.value
            return .significantDigits(value)
        case .lengths:
            let integer  = min.integer  ... max.integer
            let fraction = min.fraction ... max.fraction
            return .integerAndFractionLength(integerLimits: integer, fractionLimits: fraction)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Editable
    //=------------------------------------------------------------------------=
    
    @inlinable func editable() -> Style {
        let  integer = Swift.max(Namespace.lowerBound.integer,  max .integer)
        let fraction = Swift.max(Namespace.lowerBound.fraction, max.fraction)
        return .integerAndFractionLength(integer: integer, fraction: fraction)
    }
    
    @inlinable func editable(number: Number) -> Style {
        let  integer = Swift.max(Namespace.lowerBound.integer,  number .integer.count)
        let fraction = Swift.max(Namespace.lowerBound.fraction, number.fraction.count)
        return .integerAndFractionLength(integer: integer, fraction: fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Capacity
    //=------------------------------------------------------------------------=
    
    @inlinable func capacity(count: Count) throws -> Count {
        let integer = max.integer - count.integer
        guard integer >= 0 else {
            throw Namespace.failure(excess: .integer, max: max.integer)
        }
        
        let fraction = max.fraction - count.fraction
        guard fraction >= 0 else {
            throw Namespace.failure(excess: .fraction, max: max.fraction)
        }
        
        let value = max.value - count.fraction
        guard value >= 0 else {
            throw Namespace.failure(excess: .value, max: max.value)
        }
        
        return Count(value: value, integer: integer, fraction: fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Format
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func adapt<F: Format>(to format: F) {
        format.process(count: &min)
        format.process(count: &max)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Precision - Initializers - Value
//=----------------------------------------------------------------------------=

#warning("WIP")
extension WIP_Precision {
    
}

//=----------------------------------------------------------------------------=
// MARK: Precision - Initializers - Lengths
//=----------------------------------------------------------------------------=

#warning("WIP")
extension WIP_Precision where Value: PreciseFloatingPoint {
    
}

//*============================================================================*
// MARK: * Precision x Namespace
//*============================================================================*

#warning("Clean this up.")
@usableFromInline enum _WIP_Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let lowerBound = Count(value: 1, integer: 1, fraction: 0)
    
    //=------------------------------------------------------------------------=
    // MARK: Errors
    //=------------------------------------------------------------------------=
    
    @inlinable static func failure(excess component: Component, max: Int) -> Info {
        Info([.mark(component), "digits exceed precision capacity of", .mark(max)])
    }
    
    //*========================================================================*
    // MARK: * Components
    //*========================================================================*
    
    @usableFromInline enum Component: String {
        case value
        case integer
        case fraction
    }
    
    @usableFromInline enum Kind {
        case value
        case lengths
    }
}


