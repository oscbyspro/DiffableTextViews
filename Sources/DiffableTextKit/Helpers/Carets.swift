//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: Declaration
//*============================================================================*

/// Up to two carets represented by the bounds in a range.
///
/// An instance with equal bounds represents a single upper caret.
/// This distinction matters for transformations such as map(lower:upper:).
///
@usableFromInline struct Carets<Bound: Comparable>: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let range: Range<Bound>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ range: Range<Bound>) {
        self.range  = range
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
        range.lowerBound
    }
    
    @inlinable var upperBound: Bound {
        range.upperBound
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func map<T>(caret: (Bound) -> T) -> Carets<T> {
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        self.map(lower: caret, upper: caret)
    }
    
    @inlinable func map<T>(lower: (Bound) -> T, upper: (Bound) -> T) -> Carets<T> {
        //=--------------------------------------=
        // Single
        //=--------------------------------------=
        let upperBound = upper(range.upperBound)
        var lowerBound = upperBound
        //=--------------------------------------=
        // Double
        //=--------------------------------------=
        if !range.isEmpty {
            lowerBound = lower(range.lowerBound)
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return .unchecked((lowerBound, upperBound))
    }
}
