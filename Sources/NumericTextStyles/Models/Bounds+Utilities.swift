//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Support

//=----------------------------------------------------------------------------=
// MARK: + Components
//=----------------------------------------------------------------------------=

extension Bounds {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ components: inout Components) {
        autocorrect(&components.sign)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Validate
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(_ components: Components) throws {
        try validate(components.sign)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Components x Sign
//=----------------------------------------------------------------------------=
    
extension Bounds {

    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ sign: inout Sign) {
        switch sign {
        case .positive: if max <= .zero, min != .zero { sign.toggle() }
        case .negative: if min >= .zero               { sign.toggle() }
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Validate
    //=------------------------------------------------------------------------=
    
    @inlinable func validate(_ sign: Sign) throws {
        guard sign == sign.transform(autocorrect) else {
            throw Info([.mark(sign), "is not in", .mark(self)])
        }
    }
}

//=----------------------------------------------------------------------------=
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
    
    @inlinable func validate(_ value: Value, _ components: Components) throws {
        if try location(value) == .edge, components.hasSeparatorAsSuffix {
            throw Info([.mark(components), "does not fit a fraction separator."])
        }
    }
    
    @inlinable func location(_ value: Value) throws -> Location {
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
