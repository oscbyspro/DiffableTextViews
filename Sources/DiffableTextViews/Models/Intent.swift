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
    // MARK: Instances
    //=------------------------------------------------------------------------=

    @usableFromInline static let none = Self(lower: nil, upper: nil)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let upper: Direction?
    @usableFromInline let lower: Direction?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(lower: Direction?, upper: Direction?) {
        self.upper = upper
        self.lower = lower
    }
    
    @inlinable init(upper: Direction?, lower: Direction?) {
        self.upper = upper
        self.lower = lower
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func momentum<T: Comparable>(from start: Range<T>, to end: Range<T>) -> Self {
        Self(upper: Direction(from: start.upperBound, to: end.upperBound),
             lower: Direction(from: start.lowerBound, to: end.lowerBound))
    }
}
