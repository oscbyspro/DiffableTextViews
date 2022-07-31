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

@usableFromInline struct Bounds<Value: _Input>: CustomStringConvertible, Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let min: Value
    @usableFromInline let max: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: (min: Value, max: Value)) {
        (self.min, self.max) = unchecked; assert(min <= max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.init(unchecked: (Value.min, Value.max))
    }
    
    @inlinable init(_ limits: PartialRangeFrom<Value>) {
        self.init(unchecked: (limits.lowerBound.clamped(), Value.max))
    }
    
    @inlinable init(_ limits: PartialRangeThrough<Value>) {
        self.init(unchecked: (Value.min, limits.upperBound.clamped()))
    }
    
    @inlinable init(_ limits: ClosedRange<Value>) {
        self.init(unchecked: (limits.lowerBound.clamped(), limits.upperBound.clamped()))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var sign: Sign? {
        if      min >= .zero { return .positive }
        else if max <= .zero { return .negative }
        else {  return  nil  }
    }
    
    public var description: String {
        "\(min) to \(max)"
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ value: inout Value) {
        //=--------------------------------------=
        // Lower Bound
        //=--------------------------------------=
        if  value < min {
            Brrr.autocorrection << Info([.mark(value), "is less than \(min)"])
            value = min; return
        }
        //=--------------------------------------=
        // Upper Bound
        //=--------------------------------------=
        if  value > max {
            Brrr.autocorrection << Info([.mark(value), "is more than \(max)"])
            value = max; return
        }
    }
    
    @inlinable func autocorrect(_ number: inout Number) {
        autocorrect(&number.sign)
    }

    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ number: inout Number) throws {
        autocorrect(&number.sign)
    }

    @inlinable func autovalidate(_ value: Value, _ number: inout Number) throws {
        //=--------------------------------------=
        // Full, Or Not Full, Or Out Of Bounds
        //=--------------------------------------=
        guard let full = full(value) else {
            throw Info([.mark(value), "is not in \(self)"])
        }
        //=--------------------------------------=
        // Remove Separator When Value Is Full
        //=--------------------------------------=
        if  full, number.removeSeparatorAsSuffix() {
            Brrr.autocorrection << Info([.mark(number), "does not fit a fraction separator"])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream, Downstream x Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func full(_ value: Value) -> Bool? {
        if min < value  && value < max { return false }
        if value == max { return value > .zero || min == max }
        if value == min { return value < .zero }; return nil
    }
    
    @inlinable func autocorrect(_ sign: inout Sign) {
        guard let correct = self .sign, sign != correct else { return }
        Brrr.autocorrection << Info([.mark(sign), "is not in \(self)"])
        sign = correct
    }
}
