//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Initializers
//=----------------------------------------------------------------------------=

extension Range {
    
    //=------------------------------------------------------------------------=
    // MARK: Convenience
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
    // MARK: Map
    //=------------------------------------------------------------------------=
    
    /// Maps the bounds of another instance.
    @inlinable static func map<T>(_ source: Range<T>,
    bound: (T) -> Bound) -> Range<Bound> {
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        Self.map(source, lower: bound, upper: bound)
    }
    
    /// Maps the bounds of another instance. It maps the upper bound when it is empty.
    @inlinable static func map<T>(_ source: Range<T>,
    lower: (T) -> Bound, upper: (T) -> Bound) -> Range<Bound> {
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        let upperBound = upper(source.upperBound)
        var lowerBound = upperBound
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        if !source.isEmpty {
            lowerBound = lower(source.lowerBound)
            lowerBound = Swift.min(lowerBound, upperBound)
        }
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        return Self(uncheckedBounds: (lowerBound, upperBound))
    }
}
