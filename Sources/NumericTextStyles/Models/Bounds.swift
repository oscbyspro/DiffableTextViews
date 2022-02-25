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

public struct Bounds<Value: NumericTextValue>: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let min: Value
    @usableFromInline let max: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: (min: Value, max: Value)) {
        (self.min, self.max) = unchecked; precondition(min <= max, "min < max")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self = .unchecked()
    }
    
    @inlinable init(_ limits: PartialRangeFrom<Value>) {
        self = .unchecked(min: Self.interpret(min: limits.lowerBound))
    }
    
    @inlinable init(_ limits: PartialRangeThrough<Value>) {
        self = .unchecked(max: Self.interpret(max: limits.upperBound))
    }
    
    @inlinable init(_ limits: ClosedRange<Value> = Value.bounds) {
        self = .unchecked(min: Self.interpret(min: limits.lowerBound),
                          max: Self.interpret(max: limits.upperBound))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static func unchecked(
    min: Value = Value.bounds.lowerBound,
    max: Value = Value.bounds.upperBound) -> Self {
        Self(unchecked: (min, max))
    }
    
    @inlinable static func interpret(min: Value) -> Value {
        Swift.max(min,  Value.bounds.lowerBound)
    }
    
    @inlinable static func interpret(max: Value) -> Value {
        Swift.min(max,  Value.bounds.upperBound)
    }
}
