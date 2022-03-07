//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Commit
//*============================================================================*

/// A value and a snapshot describing it.
public struct Commit<Value> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var value: Value
    public var snapshot: Snapshot
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ value: Value, _ snapshot: Snapshot) {
        self.value = value
        self.snapshot = snapshot
    }

    @inlinable public init() where Value: RangeReplaceableCollection {
        self.init(Value(), Snapshot())
    }
}
