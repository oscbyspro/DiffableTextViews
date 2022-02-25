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
        (self.min, self.max) = unchecked; precondition(min <= max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self = .unchecked()
    }
    
    @inlinable init(_ limits: PartialRangeFrom<Value>) {
        self = .unchecked(min: Self.interpret(limits.lowerBound))
    }
    
    @inlinable init(_ limits: PartialRangeThrough<Value>) {
        self = .unchecked(max: Self.interpret(limits.upperBound))
    }
    
    @inlinable init(_ limits: ClosedRange<Value> = Value.bounds) {
        self = .unchecked(min: Self.interpret(limits.lowerBound),
                          max: Self.interpret(limits.upperBound))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static var min: Value {
        Value.bounds.lowerBound
    }
    
    @inlinable static var max: Value {
        Value.bounds.upperBound
    }
    
    @inlinable static func interpret(_ value: Value) -> Value {
        Swift.min(Swift.max(min, value), max)
    }
    
    @inlinable static func unchecked(min: Value = min, max: Value = max) -> Self {
        Self(unchecked: (min, max))
    }
}
