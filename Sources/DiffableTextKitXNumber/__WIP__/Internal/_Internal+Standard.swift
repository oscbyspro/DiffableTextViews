//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

#warning("WIP.................................................................")
//*============================================================================*
// MARK: * Internal x Style
//*============================================================================*

@usableFromInline protocol _Internal_Standard: _Internal_Style where Value == Input {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var key: Cache.Key { get set }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Internal_Standard {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var result = self; result.key.locale = locale; return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func cache() -> Cache {
        Cache(key)
    }
    
    @inlinable public func update(_ cache: inout Cache) {
        if cache.key != key { cache = self.cache() }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Internal_Style {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=

    @inlinable public func format(_ value: Input, with cache: inout Cache) -> String {
        //=--------------------------------------=
        // Limits
        //=--------------------------------------=
        let precision = precision ?? cache.preferences.precision
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return cache.format.precision(precision.inactive()).format(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Active
    //=------------------------------------------------------------------------=
    
    @inlinable public func interpret(_ value: Input, with cache: inout Cache) -> Commit<Input> {
        var value = value
        //=--------------------------------------=
        // Limits
        //=--------------------------------------=
        let bounds    = bounds    ?? cache.preferences.bounds
        let precision = precision ?? cache.preferences.precision
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&value)
        //=--------------------------------------=
        // Number
        //=--------------------------------------=
        let format = cache.format.precision(precision.active())
        
        let formatted = format.format(value)
        let parseable = cache.snapshot(formatted)
        var number = try! cache.number(parseable)
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds   .autocorrect(&number)
        precision.autocorrect(&number)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        value = try! cache.value(number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return cache.commit(value, number, format)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func resolve(_ proposal: Proposal, with cache: inout Cache) throws -> Commit<Input> {
        let number = try cache.number(proposal)
        return try resolve(number, with:&cache)
    }

    /// The resolve method body, also used by styles such as: optional.
    @inlinable func resolve(_ number: Number, with cache: inout Cache) throws -> Commit<Input> {
        var number = number; let count = number.count()
        //=--------------------------------------=
        // Limits
        //=--------------------------------------=
        let bounds    = bounds    ?? cache.preferences.bounds
        let precision = precision ?? cache.preferences.precision
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds   .autovalidate(&number)
        try precision.autovalidate(&number, count)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        let value = try cache.value(number)
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(value, &number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        let format = cache.format.precision(precision.interactive(count))
        return cache.commit(value, number, format)
    }
}
