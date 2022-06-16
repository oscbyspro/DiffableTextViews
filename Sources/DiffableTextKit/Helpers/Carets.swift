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

@usableFromInline struct Carets<Caret> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let lower: Caret
    @usableFromInline let upper: Caret
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: (lower: Caret, upper: Caret)) {
        (self.lower, self.upper) = unchecked
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Comparable
//=----------------------------------------------------------------------------=

extension Carets: Equatable where Caret: Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ caret: Caret) {
        self.init(unchecked: (caret, caret))
    }
    
    @inlinable init(_ range: Range<Caret>) {
        self.init(unchecked: (range.lowerBound, range.upperBound))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var range: Range<Caret> {
        Range(uncheckedBounds: (lower, upper))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func collapse() {
        self = Self(upper)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func map<T>(caret: (Caret) -> T) -> Carets<T> where T: Comparable {
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        self.map(lower: caret, upper: caret)
    }
    
    @inlinable func map<T>(lower: (Caret) -> T, upper: (Caret) -> T) -> Carets<T> where T: Comparable {
        //=--------------------------------------=
        // Single
        //=--------------------------------------=
        let max = upper(self.upper); var min = max
        //=--------------------------------------=
        // Double
        //=--------------------------------------=
        if  self.lower != self.upper {
            min = Swift.min(lower(self.lower), max)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Carets<T>(unchecked: (min, max))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Direction
//=----------------------------------------------------------------------------=

extension Carets where Caret == Optional<Direction> {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let none = Self(unchecked: (nil, nil))
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func directions<T>(from start: Carets<T>, to end: Carets<T>) -> Self where T: Comparable {
        let lower = Direction(from: start.lower, to: end.lower)
        let upper = Direction(from: start.upper, to: end.upper)
        return Self(unchecked: (lower, upper))
    }
}
