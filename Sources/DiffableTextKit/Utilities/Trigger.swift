//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Trigger [...]
//*============================================================================*

public struct Trigger {
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline var action: () -> Void
    
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    @inlinable public func callAsFunction() {
        self.action()
    }
    
    @inlinable public static func += (lhs: inout Self, rhs: Self) {
        lhs.action = { [lhs] in lhs(); rhs() }
    }
}

//*============================================================================*
// MARK: * Trigger x Optional [...]
//*============================================================================*

extension Optional where Wrapped == Trigger {
    
    @inlinable public init(_ action: @escaping () -> Void) {
        self = Trigger(action)
    }
    
    @inlinable public func callAsFunction() {
        if case let .some(wrapped) = self { wrapped() }
    }
    
    @inlinable public static func += (lhs: inout Self, rhs: Self) {
        (lhs != nil && rhs != nil) ? (lhs! += rhs!) : (lhs = rhs)
    }
}
