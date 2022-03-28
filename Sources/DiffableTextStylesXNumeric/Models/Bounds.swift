//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

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
}

//=----------------------------------------------------------------------------=
// MARK: + Initializers
//=----------------------------------------------------------------------------=

extension Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Indirect
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
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static func unchecked(
    min: Value = Value.bounds.lowerBound,
    max: Value = Value.bounds.upperBound) -> Self {
        Self(unchecked: (min, max))
    }
    
    @inlinable static func interpret(_ value: Value) -> Value {
        Swift.min(Swift.max(Value.bounds.lowerBound, value), Value.bounds.upperBound)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension Bounds: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        "\(min) to \(max)"
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream - Autocorrect
//=----------------------------------------------------------------------------=

extension Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ value: inout Value) {
        value = Swift.min(Swift.max(min, value), max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ number: inout Number) {
        autocorrect(&number.sign)
    }

    //=------------------------------------------------------------------------=
    // MARK: Number - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ sign: inout Sign) {
        switch sign.enumeration {
        case .positive: if max <= .zero, min != .zero { sign.toggle() }
        case .negative: if min >= .zero               { sign.toggle() }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Downstream - Autovalidate
//=----------------------------------------------------------------------------=

extension Bounds {

    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ number: Number) throws {
        try autovalidate(number.sign)
    }

    //=------------------------------------------------------------------------=
    // MARK: Number - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ sign: Sign) throws {
        guard sign == sign.transformed(autocorrect) else {
            throw Info([.mark(sign), "is not in", .mark(self)])
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ value: Value, _ number: inout Number) throws {
        if try edge(value), number.removeSeparatorAsSuffix() {
            Info.print([.autocorrection, .mark(number), "does not fit a fraction separator"])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Value - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func edge(_ value: Value) throws -> Bool {
        if min < value  && value < max { return false }
        //=--------------------------------------=
        // MARK: Value == Max
        //=--------------------------------------=
        if value == max { return value > .zero || min == max }
        //=--------------------------------------=
        // MARK: Value == Min
        //=--------------------------------------=
        if value == min { return value < .zero }
        //=--------------------------------------=
        // MARK: Value Is Out Of Bounds
        //=--------------------------------------=
        throw Info([.mark(value), "is not in", .mark(self)])
    }
}
