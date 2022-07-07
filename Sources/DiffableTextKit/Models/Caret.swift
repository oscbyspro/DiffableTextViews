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

/// A position with special characteristics.
///
/// - It SHOULD only compare positions.
///
public protocol Caret<Position>: Comparable {
    associatedtype Position: Comparable
    
    //=------------------------------------------------------------------------=
    // MARK: Requirements
    //=------------------------------------------------------------------------=
    
    @inlinable var position:   Position  { get }
    @inlinable var preference: Direction { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

public extension Caret {
    
    //=------------------------------------------------------------------------=
    // MARK: Uilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.position == rhs.position
    }
    
    @inlinable static func <  (lhs: Self, rhs: Self) -> Bool {
        lhs.position <  rhs.position
    }
}

//*============================================================================*
// MARK: * Caret x Lower
//*============================================================================*

@usableFromInline struct Lower<Position: Comparable>: Caret {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var position: Position
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) init(_ position: Position) {
        self.position = position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) var preference: Direction {  .forwards }
}

//*============================================================================*
// MARK: * Caret x Upper
//*============================================================================*

@usableFromInline struct Upper<Position: Comparable>: Caret {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var position: Position
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) init(_ position: Position) {
        self.position = position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) var preference: Direction { .backwards }
}

//*============================================================================*
// MARK: * Caret x Detached
//*============================================================================*

public struct Detached<Position: Comparable>: Caret {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let position: Position
    public let preference: Direction
    public var momentum: Direction?

    //=------------------------------------------------------------------------=
    // MARK: Initilizers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(_ caret: some Caret<Position>, momentum: Direction? = nil) {
        self.position = caret.position
        self.preference = caret.preference
        self.momentum = momentum
    }
}
