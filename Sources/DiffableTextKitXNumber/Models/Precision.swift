//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Precision
//*============================================================================*

@usableFromInline struct Precision<Value: _Input>: Equatable {
    @usableFromInline typealias Limits = ClosedRange<Int>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let integer:  Limits
    @usableFromInline let fraction: Limits
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked:(integer: Limits, fraction: Limits)) {
        (self.integer, self.fraction) = unchecked
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.init(unchecked:(Self.integer,Self.fraction))
    }
    
    @inlinable init(integer: some RangeExpression<Int>) {
        let integer  = Self.clamping(integer,  to: Self.integer )
        self.init(unchecked:(integer,Self.fraction))
    }
    
    @inlinable init(fraction: some RangeExpression<Int>) {
        let fraction = Self.clamping(fraction, to: Self.fraction)
        self.init(unchecked:(Self.integer,fraction))
    }
    
    @inlinable init(integer: some RangeExpression<Int>, fraction: some RangeExpression<Int>) {
        let integer  = Self.clamping(integer,  to: Self.integer )
        let fraction = Self.clamping(fraction, to: Self.fraction)
        self.init(unchecked:(integer,fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func limits() -> Count {
        Count(digits: Value.precision,
        integer:  integer .upperBound,
        fraction: fraction.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func inactive() -> _NFSC.Precision {
        .integerAndFractionLength(
         integerLimits:  integer.lowerBound ... Int.max,
        fractionLimits: fraction.lowerBound ... Int.max)
    }
    
    @inlinable func active() -> _NFSC.Precision {
        .integerAndFractionLength(
         integerLimits: 1 ... Int.max,
        fractionLimits: 0 ... Int.max)
    }
    
    @inlinable func interactive(_ count: Count) -> _NFSC.Precision {
        .integerAndFractionLength(
         integerLimits: max(1, count .integer) ... Int.max,
        fractionLimits: max(0, count.fraction) ... Int.max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static var integer: Limits {
        ClosedRange(uncheckedBounds:(1, Value.precision))
    }
    
    @inlinable static var fraction: Limits {
        let max = Value.integer ? 0 : Value.precision
        return ClosedRange(uncheckedBounds: (0, max))
    }
    
    /// - Requires a nonempty range expression.
    @inlinable static func clamping(_ range: some RangeExpression<Int>, to limits: Limits) -> Limits {
        ClosedRange(range.relative(to:Range(uncheckedBounds: (Int.min, Int.max)))).clamped(to: limits)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ number: inout Number) {
        let limits = limits()
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        if  number.trim(to: limits) {
            Brrr.autocorrection << Info([.mark("number"), "exceeded precision \(limits)"])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ number: inout Number, _ count: Count) throws {
        let limits = limits()
        //=--------------------------------------=
        // Validate
        //=--------------------------------------=
        if  count.digits > limits.digits {
            throw Info([.mark("digits"),   "exceeded max precision \(limits  .digits)"])
        }
        
        if  count.integer > limits.integer {
            throw Info([.mark("integer"),  "exceeded max precision \(limits .integer)"])
        }
        
        if  count.fraction > limits.fraction {
            throw Info([.mark("fraction"), "exceeded max precision \(limits.fraction)"])
        }
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        let full = count.digits == limits.digits || count.fraction == limits.fraction
        
        if  full, number.removeSeparatorAsSuffix() {
            Brrr.autocorrection << Info([.mark(number), "does not fit a fraction separator"])
        }
    }
}
