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
// MARK: * Engine
//*============================================================================*

public struct _Engine<Format: _Format, Key: _Key> {
    public typealias Input = Format.FormatInput
    
    @usableFromInline typealias Adapter = _Adapter<Format>
    @usableFromInline typealias Interpreter = NumberTextReader
    @usableFromInline typealias Adjustments = (inout Snapshot) -> Void
    
    #warning("Store style rather than key, maybe..............................")
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let key: Key
    @usableFromInline let adapter: Adapter
    @usableFromInline let preferences: Preferences<Input>
    
    @usableFromInline let interpreter: Interpreter
    @usableFromInline let adjustments: Adjustments?

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ key: Key) where Key == _Currency_Key, Format: _Format_Currency {
        self.key = key
        self.adapter = .init(code: key.code, locale: key.locale)
        //=--------------------------------------=
        // Formatter
        //=--------------------------------------=
        let formatter = NumberFormatter()
        formatter.locale = key.locale
        formatter.currencyCode = key.code
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
        self.adjustments = _Currency_Label(formatter, interpreter.components)?.autocorrect
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    #warning("...................................")
    @inlinable var bounds: NumberTextBounds<Input> {
        fatalError()
    }

    #warning(".........................................")
    @inlinable var precision: NumberTextPrecision<Input> {
        fatalError()
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

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension _Engine {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Input) -> String {
        adapter.format.precision(precision.inactive()).format(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Active
    //=------------------------------------------------------------------------=
    
    @inlinable public func interpret(_ value: Input) -> Commit<Input> {
        var value = value
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&value)
        //=--------------------------------------=
        // Number
        //=--------------------------------------=
        let formatter = adapter.format.precision(precision.active())
        let parseable = self.snapshot(formatter.format(value))
        var number = try! interpreter.number(parseable, as: Input.self)!
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds   .autocorrect(&number)
        precision.autocorrect(&number)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        value = try! adapter.parse(number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return self.commit(value, number, formatter)
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

    /// The resolve method body, also used by styles such as: optional.
    @inlinable func resolve(_ number: Number) throws -> Commit<Input> {
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
        let value = try adapter.parse(number)
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(value, &number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        let format = adapter.format.precision(precision.interactive(count))
        return self.commit(value, number, format)
    }
}
