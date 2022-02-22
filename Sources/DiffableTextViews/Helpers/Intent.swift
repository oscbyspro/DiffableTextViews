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

@usableFromInline struct Intent {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let upper: Direction?
    @usableFromInline let lower: Direction?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(lower: Direction? = nil, upper: Direction? = nil) {
        self.upper = upper
        self.lower = lower
    }
    
    @inlinable init<T: Comparable>(_ start: Range<T>, to end: Range<T>) {
        self.upper = Direction(from: start.upperBound, to: end.upperBound)
        self.lower = Direction(from: start.lowerBound, to: end.lowerBound)
    }
}
