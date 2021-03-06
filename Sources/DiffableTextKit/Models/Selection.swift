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
public struct Selection<Bound: Comparable>: Equatable {
    public typealias Caret = DiffableTextKit.Caret<Bound>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let lower: Bound
    public let upper: Bound
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(unchecked:(lower: Bound, upper: Bound)) {
        (self.lower, self.upper) = unchecked; assert(lower <= upper)
    }
    
    @inlinable public init(_ position: Bound) {
        self.init(unchecked:(position, position))
    }
    
    @inlinable public init(_ positions: Range<Bound>) {
        self.init(unchecked:(positions.lowerBound, positions.upperBound))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func initial(_ snapshot: Snapshot) -> Self where Bound == Snapshot.Index {
        Self(snapshot.resolve(.upper(snapshot.endIndex)))
    }
    
    @inlinable static func max<T>(_ collection: T) -> Self where T: Collection, T.Index == Bound {
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
    
    @inlinable public func map<T>(_ caret: (Bound) -> T) -> Selection<T> {
        return map(lower: caret, upper: caret)
    }
    
    @inlinable public func map<T>(lower: (Bound) -> T, upper: (Bound) -> T) -> Selection<T> {
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
    
    @inlinable public func detached() -> (lower: Bound, upper: Bound) {
        (lower, upper)
    }

    @inlinable public func positions() -> Range<Bound> {
        Range(uncheckedBounds: (lower, upper))
    }
}
