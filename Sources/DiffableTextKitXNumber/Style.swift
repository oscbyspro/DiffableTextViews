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

//*============================================================================*
// MARK: * Style
//*============================================================================*

public struct _NumberTextStyle<Format: NumberTextFormat>: NumberTextStyleProtocol {
    public typealias Adapter = NumberTextAdapter<Format>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var adapter: Adapter
    public var bounds: Bounds
    public var precision: Precision
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ format: Format) {
        self.adapter = Adapter(format)
        self.bounds = adapter.preferred()
        self.precision = adapter.preferred()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var result = self; result.adapter.update(locale); return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension _NumberTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Value, with cache: inout Void) -> String {
        format.precision(precision.inactive()).format(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Active
    //=------------------------------------------------------------------------=
    
    @inlinable public func interpret(_ value: Value, with cache: inout Void) -> Commit<Value> {
        let style = format.precision(precision.active())
        var value = value
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&value)
        //=--------------------------------------=
        // Number
        //=--------------------------------------=
        let formatted = style.format(value)
        let parseable = adapter.snapshot(formatted)
        var number = try! adapter.number(parseable, as: Value.self)!
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds   .autocorrect(&number)
        precision.autocorrect(&number)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        value = try! adapter.value(number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return commit(style, value, number)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func resolve(_ proposal: Proposal, with cache: inout Void) throws -> Commit<Value> {
        try resolve(adapter.number(proposal, as: Value.self)!)
    }
    
    /// The resolve method body, also used by styles such as: optional.
    @inlinable func resolve(_ number: Number) throws -> Commit<Value> {
        let count  = number.count()
        var number = number
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds   .autovalidate(&number)
        try precision.autovalidate(&number, count)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        let value = try adapter.value(number)
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(value, &number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        let style = format.precision(precision.interactive(count))
        return commit(style, value, number)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Helpers
//=----------------------------------------------------------------------------=

extension _NumberTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Commit
    //=------------------------------------------------------------------------=
    
    @inlinable func commit(_ style: Format, _ value: Value, _ number: Number) -> Commit<Value> {
        let style = style.sign(number.sign).separator(number.separator)
        var characters = style.format(value)
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        let signs = adapter.reader.components.signs
        if number.sign == .negative, value == .zero,
        let index = characters.firstIndex(of: signs[.positive]) {
            //=----------------------------------=
            // Make Positive Zero Negative
            //=----------------------------------=
            let replacement = String(signs[.negative])
            characters.replaceSubrange(index...index, with: replacement)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Commit(value, adapter.snapshot(characters))
    }
}
