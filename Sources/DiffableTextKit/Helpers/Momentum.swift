//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Intent
//*============================================================================*

@usableFromInline struct Momentum {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let lower: Direction?
    @usableFromInline let upper: Direction?

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(lower: Direction? = nil, upper: Direction? = nil) {
        self.lower = lower
        self.upper = upper
    }
    
    @inlinable init<T>(_ start: Range<T>, to end: Range<T>) where T: Comparable {
        self.lower = Direction(start.lowerBound, to: end.lowerBound)
        self.upper = Direction(start.upperBound, to: end.upperBound)
    }
}
