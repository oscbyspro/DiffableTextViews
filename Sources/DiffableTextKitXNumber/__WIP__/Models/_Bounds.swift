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
    
    @usableFromInline var bounds: ClosedRange<Input>
 
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: (lower: Input,  upper: Input)) {
        self.bounds = ClosedRange(uncheckedBounds: unchecked)
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
    
    @inlinable var min: Input {
        bounds.lowerBound
    }
    
    @inlinable var max: Input {
        bounds.upperBound
    }
    
    @inlinable var sign: Sign? {
        if      bounds.lowerBound >= .zero { return .positive }
        else if bounds.upperBound <= .zero { return .negative }
        else {  return nil }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    public var description: String {
        "\(min) to \(max)"
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func clamping(_ input:  Input) -> Input {
        Swift.min(Swift.max(Input.min, input), Input.max)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Location
//=----------------------------------------------------------------------------=

extension _Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func location(of input: Input) -> Location? {
        //=--------------------------------------=
        // Value Is Not Maxed Out
        //=--------------------------------------=
        if min < input && input < max { return .body }
        //=--------------------------------------=
        // Value == Max
        //=--------------------------------------=
        if input == max { return Location(edge: input > .zero || min == max) }
        //=--------------------------------------=
        // Value == Min
        //=--------------------------------------=
        if input == min { return Location(edge: input < .zero) }
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
        guard let location = location(of: input) else {
            throw Info([.mark(input), "is not in \(self)"])
        }
        //=--------------------------------------=
        // Remove Separator On Value Is Maxed Out
        //=--------------------------------------=
        if location == .edge, number.removeSeparatorAsSuffix() {
            Brrr.autocorrection << Info([.mark(number), "does not fit a fraction separator"])
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream, Downstream
//=----------------------------------------------------------------------------=

extension _Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ sign: inout Sign) {
        guard let correct = self .sign, sign != correct else { return }
        Brrr.autocorrection << Info([.mark(sign), "is not in \(self)"])
        sign = correct
    }
}
