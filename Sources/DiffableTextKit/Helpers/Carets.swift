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

/// One or two carets, represented by a range.
///
/// An empty range represents an upper caret.
///
@usableFromInline struct Carets<Caret: Comparable>: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let range: Range<Caret>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ range: Range<Caret>) {
        self.range  = range
    }
    
    @inlinable init(_ bound: Caret) {
        self.init(Range(uncheckedBounds: (bound, bound)))
    }
    
    @inlinable static func unchecked(_ bounds: (Caret, Caret)) -> Self {
        Self.init(Range(uncheckedBounds: bounds))
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var lower: Caret {
        range.lowerBound
    }
    
    @inlinable var upper: Caret {
        range.upperBound
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
    
    @inlinable func map<T>(caret: (Caret) -> T) -> Carets<T> {
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        self.map(lower: caret, upper: caret)
    }
    
    @inlinable func map<T>(lower: (Caret) -> T, upper: (Caret) -> T) -> Carets<T> {
        //=--------------------------------------=
        // Single
        //=--------------------------------------=
        let max = upper(self.upper); var min = max
        //=--------------------------------------=
        // Double
        //=--------------------------------------=
        if !range.isEmpty {
            min = Swift.min(lower(self.lower), max)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return .unchecked((min, max))
    }
}
