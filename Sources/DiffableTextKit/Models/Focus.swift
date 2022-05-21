//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Focus
//*============================================================================*

/// A focused/unfocused model.
@frozen public struct Focus: Equatable, ExpressibleByBooleanLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let wrapped: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ wrapped: Bool) {
        self.wrapped = wrapped
    }
    
    @inlinable public init(booleanLiteral wrapped: Bool) {
        self.wrapped = wrapped
    }
}
