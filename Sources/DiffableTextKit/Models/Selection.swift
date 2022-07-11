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

/// One or two bounds.
///
/// Equal bounds represent an upper bound.
///
public struct Selection<Position: Comparable>: Equatable {
    public typealias Caret = DiffableTextKit.Caret<Position>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let lower: Position
    public let upper: Position
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(unchecked: (lower: Position, upper: Position)) {
        (self.lower, self.upper) = unchecked; assert(lower <= upper)
    }
    
    @inlinable public init(_ position: Position) {
        self.init(unchecked:(position, position))
    }
    
    @inlinable public init(_ positions: Range<Position>) {
        self.init(unchecked:(positions.lowerBound, positions.upperBound))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func initial(_ snapshot: Snapshot) -> Self where Position == Snapshot.Index {
        Self(snapshot.resolve(.upper(snapshot.endIndex)))
    }
    
    @inlinable static func max<T>(_ collection: T) -> Self where T: Collection, T.Index == Position {
        Self(unchecked: (collection.startIndex, collection.endIndex))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func collapse() {
        self = Self(upper)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func map<T>(_ caret: (Position) -> T) -> Selection<T> {
        return map(lower: caret, upper: caret)
    }
    
    @inlinable public func map<T>(lower: (Position) -> T, upper: (Position) -> T) -> Selection<T> {
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func carets() -> Selection<Caret> {
        Selection<Caret>(unchecked: (.lower(lower), .upper(upper)))
    }
    
    @inlinable public func detached() -> (lower: Position, upper: Position) {
        (lower, upper)
    }

    @inlinable public func positions() -> Range<Position> {
        Range(uncheckedBounds: (lower, upper))
    }
}
