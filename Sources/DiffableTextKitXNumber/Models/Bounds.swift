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

public struct NumberTextBounds<Value: NumberTextValue>: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var bounds: ClosedRange<Value>
 
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable internal init(unchecked: (lower: Value, upper: Value)) {
        self.bounds = ClosedRange(uncheckedBounds: unchecked)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self.init(unchecked: (Self.min, Self.max))
    }
    
    @inlinable public init(_ limits: PartialRangeFrom<Value>) {
        self.init(unchecked: (Self.clamping(limits.lowerBound), Self.max))
    }
    
    @inlinable public init(_ limits: PartialRangeThrough<Value>) {
        self.init(unchecked: (Self.min, Self.clamping(limits.upperBound)))
    }
    
    @inlinable public init(_ limits: ClosedRange<Value>) {
        self.init(unchecked: (Self.clamping(limits.lowerBound), Self.clamping(limits.upperBound)))
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
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable static var min: Value {
        Value.bounds.lowerBound
    }
    
    @inlinable static var max: Value {
        Value.bounds.upperBound
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func clamping(_ value:  Value) -> Value {
        Swift.min(Swift.max(Self.min, value), Self.max)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Description
//=----------------------------------------------------------------------------=

extension NumberTextBounds: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        "\(min) to \(max)"
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Location
//=----------------------------------------------------------------------------=

extension NumberTextBounds {
    
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
    // MARK: * Location
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
// MARK: + Upstream
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
            Info.print(autocorrection: [.mark(value), "is less than", .note(min)])
            value = min; return
        }
        //=--------------------------------------=
        // Upper Bound
        //=--------------------------------------=
        if  value > max {
            Info.print(autocorrection: [.mark(value), "is more than", .note(max)])
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
// MARK: + Downstream
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
// MARK: + Upstream, Downstream
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
