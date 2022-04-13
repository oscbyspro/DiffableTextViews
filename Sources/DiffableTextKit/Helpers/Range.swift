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
    // MARK: Convenience
    //=------------------------------------------------------------------------=
    
    @inlinable static func empty(_ location: Bound) -> Self {
        Self(uncheckedBounds: (location, location))
    }
    
    @inlinable static func unchecked(_ bounds: (lower: Bound, upper: Bound)) -> Self {
        Self(uncheckedBounds: bounds)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Map
    //=------------------------------------------------------------------------=

    @inlinable static func from<T>(_ source: Range<T>,
    map bound: (T) -> Bound) -> Range<Bound> {
        //=--------------------------------------=
        // MARK: Return
        //=--------------------------------------=
        from(source, lower: bound, upper: bound)
    }
    
    @inlinable static func from<T>(_ source: Range<T>,
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
        return .unchecked((lowerBound, upperBound))
    }
}
