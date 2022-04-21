//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Trigger
//*============================================================================*

public struct Trigger<Context> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var action: (Context) -> Void
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ action: @escaping (Context) -> Void = { _ in }) {
        self.action = action
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func callAsFunction(_ context: Context) {
        self.action(context)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func append(_ other: Self) {
        self.action = { [self] context in
            //=----------------------------------=
            // MARK: Call This Then Other
            //=----------------------------------=
            self .action(context)
            other.action(context)
        }
    }
    
    @inlinable public static func += (lhs: inout Self, rhs: Self) {
        lhs.append(rhs)
    }
}
