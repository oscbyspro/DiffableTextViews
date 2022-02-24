//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bounds
//*============================================================================*

/// A model that constrains values to a closed range.
public struct Bounds<Value: NumericTextValue>: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let min: Value
    @usableFromInline let max: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked  limits: (Value, Value)) {
        (self.min, self.max) = limits
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self = .unchecked()
    }
    
    @inlinable init(_ limits: PartialRangeFrom<Value>) {
        self = .unchecked(min: Self.clamped(limits.lowerBound))
    }
    
    @inlinable init(_ limits: PartialRangeThrough<Value>) {
        self = .unchecked(max: Self.clamped(limits.upperBound))
    }
    
    @inlinable init(_ limits: ClosedRange<Value> = Value.bounds) {
        self = .unchecked(min: Self.clamped(limits.lowerBound),
                          max: Self.clamped(limits.upperBound))
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static func unchecked(
    min: Value = Value.bounds.lowerBound,
    max: Value = Value.bounds.upperBound) -> Self {
        Self(unchecked: (min, max))
    }
    
    @inlinable static func clamped(_ value: Value) -> Value {
        Swift.min(Swift.max(Value.bounds.lowerBound,  value), Value.bounds.upperBound)
    }
}
