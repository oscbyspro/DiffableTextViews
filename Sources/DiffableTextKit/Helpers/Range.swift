//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Range
//*============================================================================*

extension Range {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates an empty instance with its lower and upper bound set at the location.
    @inlinable static func empty(_ location: Bound) -> Self {
        Self(uncheckedBounds: (location, location))
    }
    
    /// Creates an instance with the given bounds.
    @inlinable static func unchecked(_ bounds: (lower: Bound, upper: Bound)) -> Self {
        Self(uncheckedBounds: bounds)
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Maps the bounds of this instance.
    @inlinable func map<T>(bound: (Bound) -> T) -> Range<T> {
        self.map(lower: bound, upper: bound)
    }
    
    /// Maps the bounds of this instance. It only maps the upper bound when it is empty.
    @inlinable func map<T>(lower: (Bound) -> T, upper: (Bound) -> T) -> Range<T> {
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = upper(self.upperBound)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !isEmpty {
            lowerBound = lower(self.lowerBound)
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return .unchecked((lowerBound, upperBound))
    }
}
