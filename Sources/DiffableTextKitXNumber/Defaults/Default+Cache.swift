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
// MARK: * Cache
//*============================================================================*

public final class _DefaultCache<ID: _DefaultID>: _Cache {
    public typealias Style = ID.Style
    public typealias Input = ID.Input
    
    //=------------------------------------------------------------------------=
    // MARK: Aliases
    //=------------------------------------------------------------------------=
    
    @usableFromInline typealias Adapter     = _Adapter<ID.Format>
    @usableFromInline typealias Preferences = _Preferences<Input>
    @usableFromInline typealias Interpreter = _Interpreter
    @usableFromInline typealias Adjustments = (inout Snapshot) -> Void
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style
    @usableFromInline let adapter: Adapter
    @usableFromInline let preferences: Preferences
    
    @usableFromInline let interpreter: Interpreter
    @usableFromInline let adjustments: Adjustments?

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ style: Style) where ID: _Standard {
        self.style = style
        self.adapter = .init(unchecked: ID.format(style.id))
        self.preferences = .standard()
        //=--------------------------------------=
        // Formatter
        //=--------------------------------------=
        let formatter = NumberFormatter()
        formatter.locale = style.id.locale
        //=--------------------------------------=
        // Formatter x None
        //=--------------------------------------=
        assert(formatter.numberStyle == .none)
        self.interpreter = .standard(formatter)
        self.adjustments = .none
    }

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ style: Style) where ID: _Currency {
        self.style = style
        self.adapter = .init(unchecked: ID.format(style.id))
        //=--------------------------------------=
        // Formatter
        //=--------------------------------------=
        let formatter = NumberFormatter()
        formatter.locale = style.id.locale
        formatter.currencyCode = style.id.currencyCode
        //=--------------------------------------=
        // Formatter x None
        //=--------------------------------------=
        assert(formatter.numberStyle == .none)
        self.interpreter = .currency(formatter)
        //=--------------------------------------=
        // Formatter x Currency
        //=--------------------------------------=
        formatter.numberStyle = .currency
        self.preferences = .currency(formatter)
        //=--------------------------------------=
        // Formatter x Currency x Fractionless
        //=--------------------------------------=
        formatter.maximumFractionDigits = .zero
        let label = Label.currency(formatter, interpreter.components)
        self.adjustments = label?.autocorrect(_:)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var bounds: _Bounds<Input> {
        style.bounds ?? preferences.bounds
    }

    @inlinable var precision: _Precision<Input> {
        style.precision ?? preferences.precision
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension _DefaultCache {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Input) -> String {
        adapter.format.precision(precision.inactive()).format(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Active
    //=------------------------------------------------------------------------=
    
    @inlinable public func interpret(_ input: Input) -> Commit<Input> {
        var input = input
        //=--------------------------------------=
        // Adapter
        //=--------------------------------------=
        var adapter = adapter; adapter.transform(precision.active())
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&input)
        //=--------------------------------------=
        // Number
        //=--------------------------------------=
        let parseable = snapshot(adapter.format(input))
        var number = try! interpreter.number(parseable, as: Input.self)!
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds   .autocorrect(&number)
        precision.autocorrect(&number)
        //=--------------------------------------=
        // Input
        //=--------------------------------------=
        input = try! adapter.parse(number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return commit(&adapter, input, number)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func resolve(_ proposal: Proposal) throws -> Commit<Input> {
        let number = try interpreter.number(proposal, as: Input.self)!
        return try resolve(number)
    }
    
    @inlinable public func resolve(_ proposal: Proposal) throws -> Commit<Input?> {
        let number = try interpreter.number(proposal, as: Input?.self)
        return try number.map({ try Commit(resolve($0)) }) ?? Commit()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive x Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func resolve(_ number: Number) throws -> Commit<Input> {
        let count  = number.count()
        var number = number
        //=--------------------------------------=
        // Adapter
        //=--------------------------------------=
        var adapter = adapter
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds   .autovalidate(&number)
        try precision.autovalidate(&number, count)
        //=--------------------------------------=
        // Input
        //=--------------------------------------=
        let input = try adapter.parse(number)
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(input, &number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        adapter.transform(precision.downstream(count))
        return commit(&adapter, input, number)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=

    @inlinable func commit(_ adapter: inout Adapter, _ value: Input, _ number: Number) -> Commit<Input> {
        Commit(value, snapshot(characters(&adapter, value, number)))
    }
    
    @inlinable func snapshot(_  characters: String) -> Snapshot {
        var snapshot = Snapshot(characters,
        as: { interpreter.attributes[$0] })
        adjustments?(&snapshot); return snapshot
    }
    
    @inlinable func characters(_ adapter: inout Adapter, _ value: Input, _ number: Number) -> String {
        adapter.transform(number.sign)
        adapter.transform(number.separator)
        var characters = adapter.format(value)
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        if  number.sign == .negative, value == .zero,
        let position = characters.firstIndex(
        of: interpreter.components.signs[.positive]) {
            //=----------------------------------=
            // Make Positive Zero Negative
            //=----------------------------------=
            let replacement = String(interpreter.components.signs[.negative])
            characters.replaceSubrange(position...position, with:replacement)
        }
        
        return characters
    }
}
