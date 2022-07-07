//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Detached
//*============================================================================*

@usableFromInline struct Detached<Position: Comparable>: Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let position: Position
    @usableFromInline let affinity: Direction
    @usableFromInline let momentum: Direction?

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(position: Position, momentum: Direction?, affinity: Direction) {
        self.position = position
        self.momentum = momentum
        self.affinity = affinity
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func lower(_ position: Position, momentum: Direction? = nil) -> Self {
        .init(position: position,  momentum: momentum, affinity: .forwards)
    }
    
    @inlinable static func upper(_ position: Position, momentum: Direction? = nil) -> Self {
        .init(position: position,  momentum: momentum, affinity:.backwards)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.position < rhs.position
    }
    
    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.position < rhs.position
    }
}
