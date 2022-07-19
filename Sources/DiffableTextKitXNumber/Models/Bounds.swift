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

@usableFromInline struct _Bounds<Input: _Input>: CustomStringConvertible, Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let min: Input
    @usableFromInline let max: Input
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: (min: Input,  max: Input)) {
        (self.min, self.max) = unchecked; assert(min <= max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.init(unchecked: (Input.min, Input.max))
    }
    
    @inlinable init(_ limits: PartialRangeFrom<Input>) {
        self.init(unchecked: (Self.clamping(limits.lowerBound), Input.max))
    }
    
    @inlinable init(_ limits: PartialRangeThrough<Input>) {
        self.init(unchecked: (Input.min, Self.clamping(limits.upperBound)))
    }
    
    @inlinable init(_ limits: ClosedRange<Input>) {
        self.init(unchecked: (Self.clamping(limits.lowerBound), Self.clamping(limits.upperBound)))
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func clamping(_  input:  Input) -> Input {
        Swift.min(Swift.max(Input.min, input), Input.max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func full(_ input: Input) -> Bool? {
        if min < input  && input < max { return false }
        if input == max { return input > .zero || min == max }
        if input == min { return input < .zero }; return nil
    }
    
    @inlinable func autocorrect(_ sign: inout Sign) {
        guard let correct = self .sign, sign != correct else { return }
        Brrr.autocorrection << Info([.mark(sign), "is not in \(self)"])
        sign = correct
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream
//=----------------------------------------------------------------------------=

extension _Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Input
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ input: inout Input) {
        //=--------------------------------------=
        // Lower
        //=--------------------------------------=
        if  input < min {
            Brrr.autocorrection << Info([.mark(input), "is less than \(min)"])
            input = min; return
        }
        //=--------------------------------------=
        // Upper
        //=--------------------------------------=
        if  input > max {
            Brrr.autocorrection << Info([.mark(input), "is more than \(max)"])
            input = max; return
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ number: inout Number) {
        autocorrect(&number.sign)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Downstream
//=----------------------------------------------------------------------------=

extension _Bounds {

    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ number: inout Number) throws {
        autocorrect(&number.sign)
    }

    //=------------------------------------------------------------------------=
    // MARK: Input
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ input: Input, _ number: inout Number) throws {
        //=--------------------------------------=
        // Location
        //=--------------------------------------=
        guard let full = full(input) else {
            throw Info([.mark(input), "is not in \(self)"])
        }
        //=--------------------------------------=
        // Remove Separator On Value Is Maxed Out
        //=--------------------------------------=
        if  full, number.removeSeparatorAsSuffix() {
            Brrr.autocorrection << Info([.mark(number), "does not fit a fraction separator"])
        }
    }
}
