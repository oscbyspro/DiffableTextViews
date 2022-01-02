//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

//*============================================================================*
// MARK: * Selection
//*============================================================================*

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
    
    #warning("Rename.")
    @inlinable func preferential(_ transformation: (Carets.Index, Direction) -> Carets.Index) -> Self {
        let nextUpperBound = transformation(upperBound, .backwards)
        var nextLowerBound = nextUpperBound

        if !isEmpty {
            nextLowerBound = transformation(lowerBound,  .forwards)
            nextLowerBound = min(nextLowerBound,    nextUpperBound)
        }
        
        return Self(range: nextLowerBound ..< nextUpperBound)
    }
}
