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
    @usableFromInline typealias Name = _Precision
    @usableFromInline typealias Mode = NumberFormatStyleConfiguration.Precision
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let integer:  ClosedRange<Int>
    @usableFromInline let fraction: ClosedRange<Int>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: (integer: ClosedRange<Int>, fraction: ClosedRange<Int>)) {
        (self.integer, self.fraction) = unchecked
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self.init(unchecked: (Self.integer, Self.fraction))
    }
    
    @inlinable public init<I>(integer:  I) where I: RangeExpression, I.Bound == Int {
        self.init(unchecked: (Self.integer(integer), Self.fraction))
    }
    
    @inlinable public init<F>(fraction: F) where F: RangeExpression, F.Bound == Int {
        self.init(unchecked: (Self.integer, Self.fraction(fraction)))
    }
    
    @inlinable public init<I, F>(integer: I, fraction: F) where
    I: RangeExpression, I.Bound == Int, F: RangeExpression, F.Bound == Int {
        self.init(unchecked: (Self.integer(integer), Self.fraction(fraction)))
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var lower: Count {
        Count(value: Name.lower.value,
        integer:  integer .lowerBound,
        fraction: fraction.lowerBound)
    }
    
    @inlinable var upper: Count {
        Count(value: Value.precision,
        integer:  integer .upperBound,
        fraction: fraction.upperBound)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable static var integer: ClosedRange<Int> {
        ClosedRange(uncheckedBounds: (Name.lower.integer, Value.precision))
    }
    
    @inlinable static var fraction: ClosedRange<Int> {
        let min = Name.lower.fraction
        let max = Value.isInteger ? min : Value.precision
        return ClosedRange(uncheckedBounds: (min, max))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func inactive() -> Mode {
        .integerAndFractionLength(
         integerLimits:  integer.lowerBound ... Int.max,
        fractionLimits: fraction.lowerBound ... Int.max)
    }

    @inlinable func active() -> Mode {
        .integerAndFractionLength(
         integerLimits: Name.lower.integer  ...  integer.upperBound,
        fractionLimits: Name.lower.fraction ... fraction.upperBound)
    }
    
    @inlinable func interactive(_ count: Count) -> Mode {
        .integerAndFractionLength(
         integerLimits: max(Name.lower.integer,  count.integer)  ... count.integer,
        fractionLimits: max(Name.lower.fraction, count.fraction) ... count.fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func integer<I>(_ limits: I) -> ClosedRange<Int>
    where I: RangeExpression, I.Bound == Int {
        Name.clamping(limits, to: integer)
    }
    
    @inlinable static func fraction<F>(_ limits: F) -> ClosedRange<Int>
    where F: RangeExpression, F.Bound == Int {
        Name.clamping(limits, to: fraction)
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
    
    @inlinable static func clamping<R: RangeExpression>(_ expression: R,
    to limits: ClosedRange<Int>) -> ClosedRange<Int> where R.Bound == Int {
        let range = expression.relative(to: Int.min ..< Int.max)
        let lower = min(max(limits.lowerBound, range.lowerBound),     limits.upperBound)
        let upper = min(max(limits.lowerBound, range.upperBound - 1), limits.upperBound)
        return lower...upper
    }
}
