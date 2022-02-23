//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Accessors
//=----------------------------------------------------------------------------=

public extension Symbol {
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) func contains(_ character: Character) -> Bool {
        self.character == character
    }

    @inlinable @inline(__always) func contains(_ attribute: Attribute) -> Bool {
        self.attribute.contains(attribute)
    }

    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=

    @inlinable @inline(__always) var virtual: Bool {
        self.attribute.contains(.virtual)
    }

    @inlinable @inline(__always) var nonvirtual: Bool {
        self.attribute.contains(.virtual) == false
    }
}
