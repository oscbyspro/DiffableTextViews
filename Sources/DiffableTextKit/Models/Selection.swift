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
    
    @inlinable init(_ caret: Position) {
        self.init(unchecked: (caret, caret))
    }
    
    @inlinable init(_ range: Range<Position>) {
        self.init(unchecked: (range.lowerBound, range.upperBound))
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
    
    @inlinable func detached(_ momentums: Momentums) -> Selection<Detached<Position>> {
        Selection<Detached<Position>>(unchecked:(
        Detached(lower,momentum:momentums.lower),
        Detached(upper,momentum:momentums.upper)))
    }
    
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
}

//=----------------------------------------------------------------------------=
// MARK: + Position == Snapshot.Index
//=----------------------------------------------------------------------------=

extension Selection where Position == Snapshot.Index {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func max(_ snapshot:  Snapshot) -> Self {
        Self(unchecked:(snapshot.startIndex,snapshot.endIndex))
    }
    
    @inlinable static func initial(_ snapshot: Snapshot) -> Self {
        Self(snapshot.caret(Detached(Upper(snapshot.endIndex))))
    }
}
