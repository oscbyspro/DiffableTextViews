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
        self.value = value;  self.snapshot = snapshot
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() where Value: RangeReplaceableCollection {
        self.init(Value(), Snapshot())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable public init() where Value: ExpressibleByNilLiteral {
        self.init(nil, Snapshot())
    }
    
    @inlinable public init<T>(_ commit: Commit<T>) where Value == Optional<T> {
        self.init(commit.value, commit.snapshot)
    }    
}
