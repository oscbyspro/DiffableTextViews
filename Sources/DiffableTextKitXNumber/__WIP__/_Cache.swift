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
// MARK: * Cache
//*============================================================================*

public struct _Cache<Graph: _Graph>: DiffableTextCache {
    #warning("Use adapter instead.......")
    public typealias Format = Graph.Format
    
    public typealias Style = Graph.Style
    public typealias Input = Graph.Input
    
    @usableFromInline typealias Adapter = _Adapter<Graph>
    @usableFromInline typealias Preferences = _Preferences<Input>
    @usableFromInline typealias Adjustments = (inout Snapshot) -> Void
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var style: Style
    @usableFromInline let adapter: Adapter
    @usableFromInline let preferences: Preferences
    
    @usableFromInline let interpreter: _Interpreter
    @usableFromInline let adjustments: Adjustments?

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init<T>(_ style: Style) where Graph == _Standard<T> {
        self.style = style
        self.adapter = .init(style.id)
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
    
    @inlinable init<T>(_ style: Style) where Graph == _Currency<T> {
        self.style = style
        self.adapter = .init(style.id)
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

extension _Cache {
    
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
        // Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&input)
        //=--------------------------------------=
        // Number
        //=--------------------------------------=
        let formatter = adapter.format.precision(precision.active())
        let parseable = self.snapshot(formatter.format(input))
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
        return self.commit(input, number, formatter)
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
        let format = adapter.format.precision(precision.interactive(count))
        return self.commit(input, number, format)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=

    @inlinable func commit(_ value: Input, _ number: Number, _ format: Format) -> Commit<Input> {
        Commit(value, snapshot(characters(value, number, format)))
    }
    
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        var snapshot = Snapshot(characters, as: interpreter.attributes.map)
        adjustments?(&snapshot); return snapshot
    }
    
    @inlinable func characters(_ value: Input, _ number: Number, _ format: Format) -> String {
        var characters = format.sign(number.sign)
       .separator(number.separator).format(value)
        let signs = interpreter.components.signs
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        if  number.sign == .negative, value == .zero,
        let index = characters.firstIndex(of: signs[.positive]) {
            //=----------------------------------=
            // Make Positive Zero Negative
            //=----------------------------------=
            let replacement = String(signs[.negative])
            characters.replaceSubrange(index...index, with: replacement)
        }
        
        return characters
    }
}
