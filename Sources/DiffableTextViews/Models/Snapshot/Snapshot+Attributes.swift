//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Attributes
//=----------------------------------------------------------------------------=

public extension Snapshot {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(attributes position: Index,
    with transform: (inout Attribute) -> Void) {
        transform(&_attributes[position.attribute])
    }
    
    @inlinable mutating func update<S: Sequence>(attributes sequence: S,
    with transform: (inout Attribute) -> Void) where S.Element == Index {
        for position in sequence {
            transform(&_attributes[position.attribute])
        }
    }
    
    @inlinable mutating func update<R: RangeExpression>(attributes range: R,
    with transform: (inout Attribute) -> Void) where R.Bound == Index {
        for position in indices[range.relative(to: self)] {
            transform(&_attributes[position.attribute])
        }
    }
}
