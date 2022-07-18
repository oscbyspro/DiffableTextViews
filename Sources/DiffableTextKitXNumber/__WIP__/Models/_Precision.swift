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

@usableFromInline struct _Precision<Input: _Input>: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let integer:  ClosedRange<Int>
    @usableFromInline let fraction: ClosedRange<Int>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked:(integer: ClosedRange<Int>, fraction: ClosedRange<Int>)) {
        (self.integer, self.fraction) = unchecked
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.init(unchecked:(Self.integer,Self.fraction))
    }
    
    @inlinable init<I>(integer:  I) where
    I: RangeExpression, I.Bound == Int {
        let integer  = Self.clamping(integer,  to: Self.integer )
        self.init(unchecked:(integer,Self.fraction))
    }
    
    @inlinable init<F>(fraction: F) where
    F: RangeExpression, F.Bound == Int {
        let fraction = Self.clamping(fraction, to: Self.fraction)
        self.init(unchecked:(Self.integer,fraction))
    }
    
    @inlinable init<I, F>(integer: I, fraction: F) where
    I: RangeExpression, I.Bound == Int,
    F: RangeExpression, F.Bound == Int {
        let integer  = Self.clamping(integer,  to: Self.integer )
        let fraction = Self.clamping(fraction, to: Self.fraction)
        self.init(unchecked:(integer,fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var upper: Count {
        Count(value: Input.precision, integer: integer.upperBound, fraction: fraction.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func upstream() -> _NFSC.Precision {
        .integerAndFractionLength(
         integerLimits: 1 ... Int.max,
        fractionLimits: 0 ... Int.max)
    }
    
    @inlinable func downstream(_ count: Count) -> _NFSC.Precision {
        .integerAndFractionLength(
         integerLimits: max(1, count .integer) ... Int.max,
        fractionLimits: max(0, count.fraction) ... Int.max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static var integer: ClosedRange<Int> {
        ClosedRange(uncheckedBounds:(1, Input.precision))
    }
    
    @inlinable static var fraction: ClosedRange<Int> {
        let max = Input.integer ? 0 : Input.precision
        return ClosedRange(uncheckedBounds: (0, max))
    }
    
    @inlinable static func clamping<R: RangeExpression>(_ expression: R,
    to limits: ClosedRange<Int>) -> ClosedRange<Int> where R.Bound == Int {
        let range = expression.relative(to: Int.min ..< Int.max)
        let lower = min(max(limits.lowerBound, range.lowerBound),     limits.upperBound)
        let upper = min(max(limits.lowerBound, range.upperBound - 1), limits.upperBound)
        return lower...upper
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream
//=----------------------------------------------------------------------------=

extension _Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ number: inout Number) {
        if number.trim(to: upper) {
            Brrr.autocorrection << Info([.mark("number"), "exceeded precision \(upper)"])
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Downstream
//=----------------------------------------------------------------------------=

extension _Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ number: inout Number, _ count: Count) throws {
        let capacity = try capacity(count)
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        if capacity.fraction <= 0 || capacity.value <= 0, number.removeSeparatorAsSuffix() {
            Brrr.autocorrection << Info([.mark(number), "does not fit a fraction separator"])
        }
    }
    
    @inlinable func capacity(_ count: Count) throws -> Count {
        let capacity = upper.map((&-, count))
        //=--------------------------------------=
        // Validate Each Component
        //=--------------------------------------=
        if let component = capacity.first(where: (.<, 0)) {
            throw Info([.mark(component), "digits exceeded max precision \(upper[component])"])
        }
        
        return capacity
    }
}
