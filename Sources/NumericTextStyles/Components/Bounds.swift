//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Support

//*============================================================================*
// MARK: * Bounds
//*============================================================================*

/// A model that constrains values to a closed range.
public struct Bounds<Value: Boundable>: Equatable {

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
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect - Value
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ value: inout Value) {
        value = Swift.min(Swift.max(min, value), max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect - Number
    //=------------------------------------------------------------------------=

    @inlinable func autocorrect(_ number: inout Number) {
        do { try validate(sign: number.sign) } catch { number.sign.toggle() }
        print(number.sign)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validate - Value
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(value: Value) throws -> Location {
        //=--------------------------------------=
        // MARK: Body
        //=--------------------------------------=
        if min < value && value < max { return .body }
        //=--------------------------------------=
        // MARK: Edge
        //=--------------------------------------=
        if min == value || value == max {
            //=----------------------------------=
            // MARK: Special Cases About Zero
            //=----------------------------------=
            return value != .zero || min == max ? .edge : .body
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        throw Info([.mark(value), "is not in", .mark(self)])
    }

    //=------------------------------------------------------------------------=
    // MARK: Validate - Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(sign: Sign) throws {
        switch sign {
        case .positive: if max > .zero || min == max { return }
        case .negative: if min < .zero               { return }
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        throw Info([.mark(sign), "is not in", .mark(self)])
    }
    
    //*========================================================================*
    // MARK: * Location
    //*========================================================================*
    
    /// A model describing whether a value maxed out or not.
    @usableFromInline enum Location { case body, edge }
}

//=----------------------------------------------------------------------------=
// MARK: Bounds - CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Bounds: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Descriptions
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        "[\(min),\(max)]"
    }
}
