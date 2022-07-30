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
    
    @inlinable var upper: Count {
        .init(value: Value .precision,
         integer:  integer.upperBound,
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
    
    @inlinable static var integer: ClosedRange<Int> {
        ClosedRange(uncheckedBounds:(1, Value.precision))
    }
    
    @inlinable static var fraction: ClosedRange<Int> {
        let max = Value.integer ? 0 : Value.precision
        return ClosedRange(uncheckedBounds: (0, max))
    }
    
    /// - Requires a nonempty range expression.
    @inlinable static func clamping(_ expression: some RangeExpression<Int>,
    to limits: ClosedRange<Int>) -> ClosedRange<Int> {
        let range = expression.relative(to: Int.min ..< Int.max)
        let lower = min(max(limits.lowerBound, range.lowerBound),     limits.upperBound)
        let upper = min(max(limits.lowerBound, range.upperBound - 1), limits.upperBound)
        return lower...upper
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream
//=----------------------------------------------------------------------------=

extension Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ number: inout Number) {
        if  number.trim(to: upper) {
            Brrr.autocorrection << Info([.mark("number"), "exceeded precision \(upper)"])
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Downstream
//=----------------------------------------------------------------------------=

extension Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ number: inout Number, _ count: Count) throws {
        let capacity = try capacity(count)
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        if  capacity.fraction <= 0 || capacity.value <= 0, number.removeSeparatorAsSuffix() {
            Brrr.autocorrection << Info([.mark(number), "does not fit a fraction separator"])
        }
    }
    
    @inlinable func capacity(_ count: Count) throws -> Count {
        let capacity = upper.map((&-, count))
        //=--------------------------------------=
        // Validate Each Component
        //=--------------------------------------=
        if  let component = capacity.first(where: (.<, 0)) {
            throw Info([.mark(component), "digits exceeded max precision \(upper[component])"])
        }
        
        return capacity
    }
}
