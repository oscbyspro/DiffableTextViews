//
//  Selection.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-22.
//

// MARK: - Selection

@usableFromInline struct Selection<Scheme: DiffableTextViews.Scheme> {
    @usableFromInline typealias Carets = DiffableTextViews.Carets<Scheme>
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>
    
    // MARK: Properties
    
    @usableFromInline var range: Range<Carets.Index>
    
    // MARK: Initializers
    
    @inlinable init(_ range: Range<Carets.Index>) {
        self.range = range
    }
    
    // MARK: Getters
    
    @inlinable @inline(__always) var lowerBound: Carets.Index {
        range.lowerBound
    }
    
    @inlinable @inline(__always) var upperBound: Carets.Index {
        range.upperBound
    }
        
    @inlinable var offsets: Range<Offset> {
        range.lowerBound.offset ..< range.upperBound.offset
    }
    
    // MARK: Transformations
    
    @inlinable func transforming(_ transformation: (Carets.Index, Direction) -> Carets.Index) -> Self {
        let upperBound = transformation(range.upperBound, .backwards)
        var lowerBound = upperBound

        if !range.isEmpty {
            lowerBound = transformation(range.lowerBound,  .forwards)
            lowerBound = min(lowerBound, upperBound)
        }
        
        return .init(lowerBound ..< upperBound)
    }
}
