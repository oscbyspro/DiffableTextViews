//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bounds
//*============================================================================*

/// A model that constrains values to a closed range.
public struct Bounds<Value: NumericTextValue>: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let min: Value
    @usableFromInline let max: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(min: Value = Value.bounds.lowerBound, max: Value = Value.bounds.upperBound) {
        precondition(min <= max, "min > max"); (self.min, self.max) = (min, max)
    }
    
    //*========================================================================*
    // MARK: * Location
    //*========================================================================*
    
    /// A model describing whether a value is maxed out or not.
    @usableFromInline enum Location { case body, edge }
}
