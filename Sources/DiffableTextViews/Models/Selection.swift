//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

//*============================================================================*
// MARK: * Selection
//*============================================================================*

/// Represents the user's selection in a text view.
///
/// It encapsulates the different behaviors of the lower and upper bound.
///
/// - Preferences: (lower, upper) == (.forwards, .backwards).
///
@usableFromInline struct Selection<Scheme: DiffableTextViews.Scheme> {
    @usableFromInline typealias Carets = DiffableTextViews.Carets<Scheme>
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=

    @usableFromInline var range: Range<Carets.Index>
    
    //
    // MARK: Properties - Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var isEmpty: Bool {
        range.isEmpty
    }
    
    @inlinable var lowerBound: Carets.Index {
        range.lowerBound
    }
    
    @inlinable var upperBound: Carets.Index {
        range.upperBound
    }
        
    @inlinable var offsets: Range<Offset> {
        range.lowerBound.offset ..< range.upperBound.offset
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(range: Range<Carets.Index>) {
        self.range = range
    }
    
    @inlinable init(position: Carets.Index) {
        self.range = position ..< position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func preferred(_ position: (Carets.Index, Direction) -> Carets.Index) -> Self {
        let upperBound = position(self.upperBound, .backwards)
        var lowerBound = upperBound

        if !isEmpty {
            lowerBound = position(self.lowerBound,  .forwards)
            lowerBound = min(lowerBound, upperBound)
        }
        
        return Self(range: lowerBound ..< upperBound)
    }
}
