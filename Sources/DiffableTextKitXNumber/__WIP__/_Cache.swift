//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

#warning("WIP")
#warning("WIP")
#warning("WIP")

//*============================================================================*
// MARK: * Cache
//*============================================================================*

public protocol _Cache {
    associatedtype Input: Equatable
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_ input: Input) -> String
    
    @inlinable func interpret(_ input: Input) -> Commit<Input>
    
    @inlinable func resolve(_ proposal: Proposal) throws -> Commit<Input>
    
    @inlinable func resolve(_ proposal: Proposal) throws -> Commit<Input?>
}
