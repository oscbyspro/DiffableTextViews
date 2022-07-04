//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Transformable
//*============================================================================*

public protocol  Transformable { }
public extension Transformable {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    mutating func transform(_ transform: (inout Self) throws -> Void) rethrows {
        try transform(&self)
    }
    
    @inlinable @inline(__always)
    func transformed(_ transform: (inout Self) throws -> Void) rethrows -> Self  {
        var instance = self; try transform(&instance);  return instance
    }
}
