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

public struct _Precision<Value: _Input>: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let option: Option
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() {
        self.option = .total(Total())
    }
    
    @inlinable public init(_ digits: some RangeExpression<Int>) {
        self.option = .total(Total(digits: digits))
    }
    
    @inlinable public init(integer: some RangeExpression<Int>) {
        self.option = .sides(Sides(integer: integer))
    }
    
    @inlinable public init(fraction: some RangeExpression<Int>) {
        self.option = .sides(Sides(fraction: fraction))
    }
    
    @inlinable public init(integer: some RangeExpression<Int>, fraction: some RangeExpression<Int>) {
        self.option = .sides(Sides(integer: integer, fraction: fraction))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func lower() -> Count {
        switch option {
        case .total(let total): return total.lower()
        case .sides(let sides): return sides.lower() }
    }
    
    @inlinable func upper() -> Count {
        switch option {
        case .total(let total): return total.upper()
        case .sides(let sides): return sides.upper() }
    }
    
    @inlinable func inactive() -> _NFSC.Precision {
        switch option {
        case .total(let total): return total.inactive()
        case .sides(let sides): return sides.inactive() }
    }
    
    @inlinable func active() -> _NFSC.Precision {
        .integerAndFractionLength(
         integerLimits: PartialRangeFrom(1),
        fractionLimits: PartialRangeFrom(0))
    }
    
    @inlinable func interactive(_ count: Count) -> _NFSC.Precision {
        .integerAndFractionLength(
         integerLimits: PartialRangeFrom(max(1, count .integer)),
        fractionLimits: PartialRangeFrom(max(0, count.fraction)))
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
    
    //*========================================================================*
    // MARK: * Option [...]
    //*========================================================================*
    
    @usableFromInline enum Option: Equatable {
        case total(Total)
        case sides(Sides)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension _Precision {
    
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
            throw Info([.mark("digits"),   "exceeded max precision \(limits.digits  )"])
        }
        
        if  count.integer > limits.integer {
            throw Info([.mark("integer"),  "exceeded max precision \(limits.integer )"])
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


//=----------------------------------------------------------------------------=
// MARK: + Option(s)
//=----------------------------------------------------------------------------=

extension _Precision {
    
    //*========================================================================*
    // MARK: * Total [...]
    //*========================================================================*
    
    @usableFromInline struct Total: Equatable {
    
        //=--------------------------------------------------------------------=
        
        @usableFromInline private(set) var digits: ClosedRange<Int> = _Precision.digits
        
        //=--------------------------------------------------------------------=
        
        @inlinable init() { }
        
        @inlinable init(digits: some RangeExpression<Int>) {
            self.digits = digits.clamped(to:  self.digits)
        }
        
        @inlinable func lower() -> Count {
            Count(digits: digits.lowerBound,
            integer:  _Precision.integer .lowerBound,
            fraction: _Precision.fraction.lowerBound)
        }
        
        @inlinable func upper() -> Count {
            Count(digits: digits.upperBound,
            integer:  _Precision.integer .upperBound,
            fraction: _Precision.fraction.upperBound)
        }
        
        @inlinable func inactive() -> _NFSC.Precision {
            .significantDigits(PartialRangeFrom(digits.lowerBound))
        }
    }
    
    //*========================================================================*
    // MARK: * Sides [...]
    //*========================================================================*
    
    @usableFromInline struct Sides: Equatable {
    
        //=--------------------------------------------------------------------=
        
        @usableFromInline private(set) var integer:  ClosedRange<Int> = _Precision.integer
        @usableFromInline private(set) var fraction: ClosedRange<Int> = _Precision.fraction
        
        //=--------------------------------------------------------------------=
        
        @inlinable init() { }
        
        @inlinable init(integer: some RangeExpression<Int>) {
            self.integer  = integer .clamped(to: self.integer )
        }
        
        @inlinable init(fraction: some RangeExpression<Int>) {
            self.fraction = fraction.clamped(to: self.fraction)
        }
        
        @inlinable init(integer: some RangeExpression<Int>, fraction: some RangeExpression<Int>) {
            self.integer  = integer .clamped(to: self.integer )
            self.fraction = fraction.clamped(to: self.fraction)
        }
        
        @inlinable func lower() -> Count {
            Count(digits: _Precision.digits.lowerBound,
            integer:  integer .lowerBound,
            fraction: fraction.lowerBound)
        }
        
        @inlinable func upper() -> Count {
            Count(digits: _Precision.digits.upperBound,
            integer:  integer .upperBound,
            fraction: fraction.upperBound)
        }
        
        @inlinable func inactive() -> _NFSC.Precision {
            .integerAndFractionLength(
             integerLimits: PartialRangeFrom(integer .lowerBound),
            fractionLimits: PartialRangeFrom(fraction.lowerBound))
        }
    }
}
