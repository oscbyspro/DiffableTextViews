//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Caret
//*============================================================================*

public struct Caret<Position: Comparable>: Comparable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var position: Position
    public let affinity: Direction
    public var momentum: Direction?
    
    //=------------------------------------------------------------------------=
    // MARK: Initilizers
    //=------------------------------------------------------------------------=
    
    @inlinable init(  _ position: Position, affinity: Direction) {
        self.position = position
        self.affinity = affinity
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func lower(_ position: Position) -> Self {
        Self(position, affinity:  .forwards)
    }
    
    @inlinable static func upper(_ position: Position) -> Self {
        Self(position, affinity: .backwards)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Comparable (!)
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.position == rhs.position
    }
    
    @inlinable public static func <  (lhs: Self, rhs: Self) -> Bool {
        lhs.position <  rhs.position
    }
}
