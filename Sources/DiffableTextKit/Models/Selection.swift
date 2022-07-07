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
public struct Selection<Position: Comparable>: Equatable {
    @usableFromInline typealias Lower = DiffableTextKit.Lower<Position>
    @usableFromInline typealias Upper = DiffableTextKit.Upper<Position>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let lower: Lower
    @usableFromInline let upper: Upper
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: (lower: Position, upper: Position)) {
        self.lower = Lower(unchecked.lower)
        self.upper = Upper(unchecked.upper)
    }
    
    @inlinable init(_ position: Position) {
        self.init(unchecked: (position, position))
    }
    
    @inlinable init(_ positions: Range<Position>) {
        self.init(unchecked: (positions.lowerBound, positions.upperBound))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable static func max<T>(_ collection: T) -> Self where T: Collection, T.Index == Position {
        Self(unchecked: (collection.startIndex, collection.endIndex))
    }
    
    @inlinable static func initial(_ collection: Snapshot) -> Self where Position == Snapshot.Index {
        Self(collection.caret(Detached(Upper(collection.endIndex)))) // O(n)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var single: Bool {
        lower.position == upper.position
    }
    
    @inlinable var range: Range<Position> {
        Range(uncheckedBounds: (lower.position, upper.position))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func collapse() {
        self = Self(upper.position)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func map<T>(_ position:  (Position) -> T) -> Selection<T> {
        return map(lower: {  position($0.position) }, upper: { position($0.position) })
    }
    
    @inlinable func map<T>(lower: (Lower) -> T, upper: (Upper) -> T) -> Selection<T> {
        let max = upper(self.upper); var min = max
        //=--------------------------------------=
        // Double
        //=--------------------------------------=
        if !self.single {
            min = Swift.min(lower(self.lower),max)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Selection<T>(unchecked: (min, max))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func detached(_ momentums: Momentums = .none) -> Selection<Detached<Position>> {
        Selection<Detached<Position>>(unchecked:(
        Detached(lower,momentum:momentums.lower),
        Detached(upper,momentum:momentums.upper)))
    }
}
