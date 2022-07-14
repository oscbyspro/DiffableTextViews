//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Optional
//*============================================================================*

#warning("Conformances........................................")
public struct _Optional<Style: _Style>: DiffableTextStyleWrapper {
    public typealias Cache = Style.Cache
    public typealias Value = Style.Value?
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var style: Style
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    init(_ style: Style) {
        self.style  = style
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) public func resolve(_ proposal:
    Proposal, with cache: inout Cache) throws -> Commit<Value> {
        try cache.optional(proposal)
    }
}
