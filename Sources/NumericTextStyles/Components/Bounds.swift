//
//  Bounds.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import DiffableTextViews
import Support

//*============================================================================*
// MARK: * Bounds
//*============================================================================*

/// A model that constrains values to a closed range.
public struct Bounds<Value: Boundable> {

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let limits: ClosedRange<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties - Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var min: Value {
        limits.lowerBound
    }
    
    @inlinable var max: Value {
        limits.upperBound
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(min: Value = Value.bounds.lowerBound, max: Value = Value.bounds.upperBound) {
        self.limits = min...max
    }
    
    //
    // MARK: Initialiers: Static
    //=------------------------------------------------------------------------=
    
    @inlinable public static var standard: Self {
        .init()
    }
    
    @inlinable public static func limits(_ limits: ClosedRange<Value>) -> Self {
        .init(min: limits.lowerBound, max: limits.upperBound)
    }
    
    @inlinable public static func limits(_ limits: PartialRangeFrom<Value>) -> Self {
        .init(min: limits.lowerBound)
    }
    
    @inlinable public static func limits(_ limits: PartialRangeThrough<Value>) -> Self {
        .init(max: limits.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func clamp(_ value: inout Value) {
        value = Swift.max(min, Swift.min(value, max))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Bounds - Validate
//=----------------------------------------------------------------------------=

extension Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(value: Value) throws {
        guard limits.contains(value) else {
            throw Info([.mark(value), "is not in", .mark(self)])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(sign: Sign) throws {
        switch sign {
        case .positive: if max >= .zero { return }
        case .negative: if min <  .zero { return }
        }
        
        throw Info([.mark(sign), "is not in", .mark(self)])
    }
}

//=----------------------------------------------------------------------------=
// MARK: Bounds - CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Bounds: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Descriptions
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        "[\(min),\(max)]"
    }
}
