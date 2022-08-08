//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Count [...]
//*============================================================================*

public extension Sequence {
    
    @inlinable func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        var S0 = 0; for x in self { if try predicate(x) { S0 += 1 } }; return S0
    }
    
    @inlinable func count(while predicate: (Element) throws -> Bool) rethrows -> Int {
        var S0 = 0; for x in self { if try predicate(x) { S0 += 1 } else { break } }; return S0
    }
}
