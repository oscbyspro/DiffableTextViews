//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: Declaration
//*============================================================================*

public struct Trigger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var action: () -> Void
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ action: @escaping () -> Void) {
        self.action = action
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func callAsFunction() {
        self.action()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func += (lhs: inout Self, rhs: Self) {
        lhs.action = { [lhs] in lhs(); rhs() }
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

extension Optional where Wrapped == Trigger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable public static func &+= (lhs: inout Self, rhs: Self) {
        guard let rhs = rhs else { return lhs = nil }; (lhs? += rhs) ?? (lhs = rhs)
    }
}
