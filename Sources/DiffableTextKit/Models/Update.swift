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

/// Used to cache state differentiation results in order to avoid multiple comparisons.
public struct Update {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let style: Bool
    public let value: Bool
    public let focus: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    public init() {
        self.style = true
        self.value = true
        self.focus = true
    }

    @inlinable init?<S>(_ lhs: Remote<S>, _ rhs: Remote<S>) {
        //=--------------------------------------=
        // Compare
        //=--------------------------------------=
        self.style = lhs.style != rhs.style
        self.value = lhs.value != rhs.value
        self.focus = lhs.focus != rhs.focus
        //=--------------------------------------=
        // At Least One Must Have Changed
        //=--------------------------------------=
        guard style || value || focus else { return nil }
    }
}
