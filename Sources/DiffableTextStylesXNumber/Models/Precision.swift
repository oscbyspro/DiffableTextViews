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
// MARK: Declaration
//*============================================================================*

public struct NumberTextPrecision<Value: NumberTextValue>: Equatable {
    @usableFromInline typealias Namespace = _Precision
    @usableFromInline typealias Limits = ClosedRange<Int>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let integer:  Limits
    @usableFromInline let fraction: Limits
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: (integer: Limits, fraction: Limits)) {
        (self.integer, self.fraction) = unchecked
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var lower: Count {
        Count(value: Namespace.lower.value,
        integer:  integer .lowerBound,
        fraction: fraction.lowerBound)
    }
    
    @inlinable var upper: Count {
        Count(value: Value.precision,
        integer:  integer .upperBound,
        fraction: fraction.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Modes
    //=------------------------------------------------------------------------=
    
    @inlinable func inactive() -> NFSC.Precision {
        .integerAndFractionLength(
         integerLimits:  integer.lowerBound ... Int.max,
        fractionLimits: fraction.lowerBound ... Int.max)
    }

    @inlinable func active() -> NFSC.Precision {
        .integerAndFractionLength(
         integerLimits: Namespace.lower.integer  ...  integer.upperBound,
        fractionLimits: Namespace.lower.fraction ... fraction.upperBound)
    }
    
    @inlinable func interactive(_ count: Count) -> NFSC.Precision {
        .integerAndFractionLength(
         integerLimits: max(Namespace.lower.integer,  count.integer)  ... count.integer,
        fractionLimits: max(Namespace.lower.fraction, count.fraction) ... count.fraction)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Initializers
//=----------------------------------------------------------------------------=

internal extension NumberTextPrecision {

    //=------------------------------------------------------------------------=
    // MARK: Indirect
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self = .unchecked()
    }
    
    @inlinable init<R>(integer: R)  where R: RangeExpression, R.Bound == Int {
        self = .unchecked(integer:  Self .integer( integer))
    }
    
    @inlinable init<R>(fraction: R) where R: RangeExpression, R.Bound == Int {
        self = .unchecked(fraction: Self.fraction(fraction))
    }
    
    @inlinable init<R0, R1>(integer: R0, fraction: R1) where
    R0: RangeExpression, R0.Bound == Int, R1: RangeExpression, R1.Bound == Int {
        self = .unchecked(integer:  Self .integer( integer),
                          fraction: Self.fraction(fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static func unchecked(
    integer:  ClosedRange<Int> =  integer,
    fraction: ClosedRange<Int> = fraction) -> Self {
        Self(unchecked: (integer, fraction))
    }

    @inlinable static var integer: ClosedRange<Int> {
        Namespace.lower.integer ... Value.precision
    }
    
    @inlinable static var fraction: ClosedRange<Int> {
        Namespace.lower.fraction ... (Value.isInteger ? 0 : Value.precision)
    }
    
    @inlinable static func integer<R>(_ limits: R) -> ClosedRange<Int>
    where R: RangeExpression, R.Bound == Int {
        Namespace.interpret(limits, in: integer)
    }
    
    @inlinable static func fraction<R>(_ limits: R) -> ClosedRange<Int>
    where R: RangeExpression, R.Bound == Int {
        Namespace.interpret(limits, in: fraction)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Upstream
//=----------------------------------------------------------------------------=

extension NumberTextPrecision {
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ number: inout Number) {
        number.trimToFit(upper)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Downstream
//=----------------------------------------------------------------------------=

extension NumberTextPrecision {
    
    //=------------------------------------------------------------------------=
    // MARK: Number
    //=------------------------------------------------------------------------=
    
    @inlinable func autovalidate(_ number: inout Number, _ count: Count) throws {
        let capacity = try capacity(count)
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        if capacity.fraction <= 0 || capacity.value <= 0, number.removeSeparatorAsSuffix() {
            Info.print(autocorrection: [.mark(number), "does not fit a fraction separator"])
        }
    }
    
    @inlinable func capacity(_ count: Count) throws -> Count {
        let capacity = upper.map((&-, count))
        //=--------------------------------------=
        // Validate Each Component
        //=--------------------------------------=
        if let component = capacity.first(where: (.<, 0)) {
            throw Info([.mark(component), "digits exceed max precision", .note(upper[component])])
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return capacity
    }
}

//*============================================================================*
// MARK: Namespace
//*============================================================================*

@usableFromInline enum _Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let lower = Count(value: 1, integer: 1, fraction: 0)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func interpret<R: RangeExpression>(_ expression: R,
    in limits: ClosedRange<Int>) -> ClosedRange<Int> where R.Bound == Int {
        let range = expression.relative(to: Int.min ..< Int.max)
        let lower = min(max(limits.lowerBound, range.lowerBound),     limits.upperBound)
        let upper = min(max(limits.lowerBound, range.upperBound - 1), limits.upperBound)
        return lower...upper
    }
}
