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
// MARK: * Cache
//*============================================================================*

public protocol _Cache: DiffableTextStyle where Cache == Void, Value: _Input {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func resolve(_ proposal: Proposal,
    with cache: inout Cache) throws -> Commit<Value?>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Cache where Cache == Void {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func resolve(_ proposal: Proposal) throws -> Commit<Value?> {
        var cache: Void = (); return try resolve(proposal, with: &cache)
    }
}
