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
// MARK: * Precision
//*============================================================================*

@usableFromInline enum Precision<Value: _Input>: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    case total(Total<Value>)
    case sides(Sides<Value>)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self = .total(Total())
    }
    
    @inlinable init(_ digits: some RangeExpression<Int>) {
        self = .total(Total(digits: digits))
    }
    
    @inlinable init(integer: some RangeExpression<Int>) {
        self = .sides(Sides(integer: integer))
    }
    
    @inlinable init(fraction: some RangeExpression<Int>) {
        self = .sides(Sides(fraction: fraction))
    }
    
    @inlinable init(integer: some RangeExpression<Int>, fraction: some RangeExpression<Int>) {
        self = .sides(Sides(integer: integer, fraction: fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func lower() -> Count {
        switch self {
        case .total(let total): return total.lower()
        case .sides(let sides): return sides.lower() }
    }
    
    @inlinable func upper() -> Count {
        switch self {
        case .total(let total): return total.upper()
        case .sides(let sides): return sides.upper() }
    }
    
    @inlinable func inactive() -> _NFSC.Precision {
        switch self {
        case .total(let total): return total.inactive()
        case .sides(let sides): return sides.inactive() }
    }
    
    @inlinable func active() -> _NFSC.Precision {
        .integerAndFractionLength(
         integerLimits: ClosedRange(uncheckedBounds: (1, Int.max)),
        fractionLimits: ClosedRange(uncheckedBounds: (0, Int.max)))
    }
    
    @inlinable func interactive(_ count: Count) -> _NFSC.Precision {
        .integerAndFractionLength(
         integerLimits: ClosedRange(uncheckedBounds: (max(1, count .integer), Int.max)),
        fractionLimits: ClosedRange(uncheckedBounds: (max(0, count.fraction), Int.max)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static var digits: ClosedRange<Int> {
        ClosedRange(uncheckedBounds: (1, Value.precision))
    }
    
    @inlinable static var integer: ClosedRange<Int> {
        ClosedRange(uncheckedBounds: (1, Value.precision))
    }
    
    @inlinable static var fraction: ClosedRange<Int> {
        let max = Value.integer ? 0 : Value.precision
        return ClosedRange(uncheckedBounds: (0, max))
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
        let limits = upper()
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
        let limits = upper()
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

//*============================================================================*
// MARK: * Precision x Sides
//*============================================================================*

@usableFromInline struct Sides<Value: _Input>: Equatable {
    @usableFromInline typealias P = Precision<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var integer:  ClosedRange<Int> = P.integer
    @usableFromInline private(set) var fraction: ClosedRange<Int> = P.fraction
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() { }
    
    @inlinable init(integer: some RangeExpression<Int>) {
        self.integer  = integer .clamped(to: self.integer)
    }
    
    @inlinable init(fraction: some RangeExpression<Int>) {
        self.fraction = fraction.clamped(to: self.fraction)
    }
    
    @inlinable init(integer: some RangeExpression<Int>, fraction: some RangeExpression<Int>) {
        self.integer  = integer .clamped(to: self.integer )
        self.fraction = fraction.clamped(to: self.fraction)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func lower() -> Count {
        Count(digits: P.digits.lowerBound,
        integer:       integer.lowerBound,
        fraction:     fraction.lowerBound)
    }
    
    @inlinable func upper() -> Count {
        Count(digits: P.digits.upperBound,
        integer:       integer.upperBound,
        fraction:     fraction.upperBound)
    }
    
    @inlinable func inactive() -> _NFSC.Precision {
        .integerAndFractionLength(
         integerLimits: ClosedRange(uncheckedBounds: (integer .lowerBound, Int.max)),
        fractionLimits: ClosedRange(uncheckedBounds: (fraction.lowerBound, Int.max)))
    }
}

//*============================================================================*
// MARK: * Precision x Total
//*============================================================================*

@usableFromInline struct Total<Value: _Input>: Equatable {
    @usableFromInline typealias P = Precision<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var digits: ClosedRange<Int> = P.digits
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() { }
    
    @inlinable init(digits: some RangeExpression<Int>) {
        self.digits = digits.clamped(to:  self.digits)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func lower() -> Count {
        Count(digits: digits.lowerBound,
        integer:  P .integer.lowerBound,
        fraction: P.fraction.lowerBound)
    }
    
    @inlinable func upper() -> Count {
        Count(digits: digits.upperBound,
        integer:  P .integer.upperBound,
        fraction: P.fraction.upperBound)
    }
    
    @inlinable func inactive() -> _NFSC.Precision {
        .significantDigits(ClosedRange(uncheckedBounds: (digits.lowerBound, Int.max)))
    }
}
