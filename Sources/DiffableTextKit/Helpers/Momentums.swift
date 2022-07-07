//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Momentums
//*============================================================================*

@usableFromInline struct Momentums {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let none = Self(lower: nil, upper: nil)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let lower: Direction?
    @usableFromInline let upper: Direction?

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(lower: Direction?, upper: Direction?) {
        self.lower = lower
        self.upper = upper
    }
    
    @inlinable init<T>(from start: Selection<T>,  to  end: Selection<T>) {
        self.lower = Direction(from: start.lower, to: end.lower)
        self.upper = Direction(from: start.upper, to: end.upper)
    }
}
