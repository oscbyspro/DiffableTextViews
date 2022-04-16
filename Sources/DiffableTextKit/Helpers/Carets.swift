//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Carets
//*============================================================================*

/// Up to two carets represented by a lower and upper bound.
///
/// When its bounds are equal, it represents a single upper caret.
/// This distinction matters to transformations such as map(lower:upper:).
///
@usableFromInline struct Carets<Bound: Comparable>: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let bounds: Range<Bound>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ bounds: Range<Bound>) {
        self.bounds = bounds
    }
    
    @inlinable init(_ bound: Bound) {
        self.init(Range(uncheckedBounds: (bound, bound)))
    }
    
    @inlinable static func unchecked(_ bounds: (lower: Bound, upper: Bound)) -> Self {
        Self.init(Range(uncheckedBounds: bounds))
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var lowerBound: Bound {
        bounds.lowerBound
    }
    
    @inlinable var upperBound: Bound {
        bounds.upperBound
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func map<T>(caret: (Bound) -> T) -> Carets<T> {
        self.map(lower: caret, upper: caret)
    }
    
    @inlinable func map<T>(lower: (Bound) -> T, upper: (Bound) -> T) -> Carets<T> {
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = upper(bounds.upperBound)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !bounds.isEmpty {
            lowerBound = lower(bounds.lowerBound)
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return .unchecked((lowerBound, upperBound))
    }
}
