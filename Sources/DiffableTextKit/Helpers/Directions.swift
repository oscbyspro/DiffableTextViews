//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Directions
//*============================================================================*

@usableFromInline struct Directions {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let none = Self()
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let lowerBound: Direction?
    @usableFromInline let upperBound: Direction?

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(lowerBound: Direction? = nil, upperBound: Direction? = nil) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }
    
    @inlinable init<T>(from start: Range<T>, to end: Range<T>) where T: Comparable {
        self.lowerBound = Direction(start.lowerBound, to: end.lowerBound)
        self.upperBound = Direction(start.upperBound, to: end.upperBound)
    }
}
