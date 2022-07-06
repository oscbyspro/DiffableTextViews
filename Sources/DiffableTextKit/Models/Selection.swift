//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Selection
//*============================================================================*

/// One or two carets.
///
/// Equal carets represents an upper caret.
///
@usableFromInline struct Selection<Caret: Comparable>: Equatable {
    
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
    
    @inlinable init(_ caret: Caret) {
        self.init(unchecked: (caret, caret))
    }
    
    @inlinable init(_ range: Range<Caret>) {
        self.init(unchecked: (range.lowerBound, range.upperBound))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func max<T>(_ collection: T) -> Self where T: Collection, T.Index == Caret {
        Self(unchecked: (collection.startIndex, collection.endIndex))
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
    
    @inlinable func map<T>(caret: (Caret) -> T) -> Selection<T> {
        return map(lower:  caret, upper: caret)
    }
    
    @inlinable func map<T>(lower: (Caret) -> T, upper: (Caret) -> T) -> Selection<T> {
        let max = upper(self.upper); var min = max
        //=--------------------------------------=
        // Double
        //=--------------------------------------=
        if  self.lower != self.upper {
            min = Swift.min(lower(self.lower),max)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Selection<T>(unchecked: (min, max))
    }
}
