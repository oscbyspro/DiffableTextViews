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
public struct Bounds<Value: NumericTextValue>: Equatable {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=

    @inlinable static var zero: Self {
        Self(unchecked: (.zero, .zero))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let min: Value
    @usableFromInline let max: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked: (Value, Value)) {
        self.min = unchecked.0
        self.max = unchecked.1
    }
    
    @inlinable init(min: Value = Value.bounds.lowerBound, max: Value = Value.bounds.upperBound) {
        precondition(min <= max, "min > max"); (self.min, self.max) = (min, max)
    }
    
    //*========================================================================*
    // MARK: * Location
    //*========================================================================*
    
    /// A model describing whether a value is maxed out or not.
    @usableFromInline enum Location { case body, edge }
}

//=-----------------------------------------------b-----------------------------=
// MARK: + Value
//=----------------------------------------------------------------------------=

extension Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ value: inout Value) {
        value = Swift.min(Swift.max(min, value), max)
    }

    //=------------------------------------------------------------------------=
    // MARK: Validate
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(_ value: Value) throws -> Location {
        if min < value && value < max { return .body }
        //=--------------------------------------=
        // MARK: Value == Max
        //=--------------------------------------=
        if value == max {
            return value > .zero || min == max ? .edge : .body
        }
        //=--------------------------------------=
        // MARK: Value == Min
        //=--------------------------------------=
        if value == min {
            return value < .zero || min == max ? .edge : .body
        }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        throw Info([.mark(value), "is not in", .mark(self)])
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Components
//=----------------------------------------------------------------------------=

extension Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ sign: inout Sign) {
        switch sign {
        case .positive: if max > .zero || self == .zero { return }
        case .negative: if min < .zero                  { return }
        }
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        sign.toggle()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validate
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(_ components: Components, with location: Location) throws {
        if location == .edge, components.hasSeparatorAsSuffix {
            throw Info([.mark(components), "has reached its limit and does not fit a fraction separator."])
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validate - Sign
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(_ sign: Sign) throws {
        var autocorrectable = sign
        autocorrect(&autocorrectable)
        if autocorrectable == sign { return }
        //=--------------------------------------=
        // MARK: Failure
        //=--------------------------------------=
        throw Info([.mark(sign), "is not in", .mark(self)])
    }
}

//=----------------------------------------------------------------------------=
// MARK: + CustomStringConvertible
//=----------------------------------------------------------------------------=

extension Bounds: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Descriptions
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        "\(min) to \(max)"
    }
}
