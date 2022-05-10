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
// MARK: Declaration
//*============================================================================*

public struct NumberTextBounds<Value: NumberTextValue>: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var bounds: ClosedRange<Value>
 
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: (lower: Value, upper: Value)) {
        self.bounds = ClosedRange(uncheckedBounds: unchecked)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var min: Value {
        bounds.lowerBound
    }
    
    @inlinable var max: Value {
        bounds.upperBound
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func location(of value: Value) -> Location? {
        //=--------------------------------------=
        // Value Is Not Maxed Out
        //=--------------------------------------=
        if min < value && value < max { return .body }
        //=--------------------------------------=
        // Value == Max
        //=--------------------------------------=
        if value == max { return Location(edge: value > .zero || min == max) }
        //=--------------------------------------=
        // Value == Min
        //=--------------------------------------=
        if value == min { return Location(edge: value < .zero) }
        //=--------------------------------------=
        // Value Is Out Of Bounds
        //=--------------------------------------=
        return nil
    }
    
    //*========================================================================*
    // MARK: Declaration
    //*========================================================================*
    
    @usableFromInline enum Location {
        
        //=--------------------------------------------------------------------=
        // MARK: Instances
        //=--------------------------------------------------------------------=
        
        case body
        case edge
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(edge: Bool) { self = edge ? .edge : .body }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Initializers
//=----------------------------------------------------------------------------=

extension NumberTextBounds {
    
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
// MARK: Utilities
//=----------------------------------------------------------------------------=

extension NumberTextBounds: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Description
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        "\(min) to \(max)"
    }
}

//=----------------------------------------------------------------------------=
// MARK: Upstream
//=----------------------------------------------------------------------------=

extension NumberTextBounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ value: inout Value) {
        //=--------------------------------------=
        // Lower Bound
        //=--------------------------------------=
        if  value < min {
            Info.print(autocorrection: [.mark(value), "<", .note(min)])
            value = min; return
        }
        //=--------------------------------------=
        // Upper Bound
        //=--------------------------------------=
        if  value > max {
            Info.print(autocorrection: [.mark(value), ">", .note(max)])
            value = max; return
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_  number: inout Number) {
        autocorrectSignOnUnambigiousBounds(&number.sign)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Downstream
//=----------------------------------------------------------------------------=

extension NumberTextBounds {

    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ number: inout Number) throws {
        autocorrectSignOnUnambigiousBounds(&number.sign)
    }

    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ value: Value, _ number: inout Number) throws {
        //=--------------------------------------=
        // Location
        //=--------------------------------------=
        guard let location = location(of: value) else {
            throw Info([.mark(value), "is not in", .note(self)])
        }
        //=--------------------------------------=
        // Remove Separator On Value Is Maxed Out
        //=--------------------------------------=
        if location == .edge, number.removeSeparatorAsSuffix() {
            Info.print(autocorrection: [.mark(number), "does not fit a fraction separator"])
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: Upstream, Downstream
//=----------------------------------------------------------------------------=

extension NumberTextBounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrectSignOnUnambigiousBounds(_ sign: inout  Sign) {
        guard let correct = Sign(of: bounds), sign != correct else { return }
        Info.print(autocorrection: [.mark(sign),  "is not in",  .note(self)])
        sign = correct
    }
}
