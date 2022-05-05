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
// MARK: Declaration
//*============================================================================*

public struct _NumberTextStyle<Format: NumberTextFormat>: DiffableTextStyle {
    public typealias Value = Format.FormatInput
    public typealias Bounds = DiffableTextStylesXNumber.NumberTextBounds<Value>
    public typealias Precision = DiffableTextStylesXNumber.NumberTextPrecision<Value>
    @usableFromInline typealias Adapter = DiffableTextStylesXNumber.Adapter<Format>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var adapter: Adapter
    @usableFromInline var bounds: Bounds
    @usableFromInline var precision: Precision
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ format: Format) {
        self.adapter = Adapter(format)
        self.bounds = adapter.bounds()
        self.precision = adapter.precision()
    }
 
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var locale: Locale {
        format.locale
    }
    
    @inlinable var format: Format {
        adapter.format
    }

    @inlinable var scheme: Format.NumberTextScheme {
        adapter.scheme
    }
    
    @inlinable var lexicon: Lexicon {
        scheme.lexicon
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        guard self.locale != locale else { return self }
        var result = self; result.adapter.update(locale); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.adapter == rhs.adapter
        && lhs.bounds == rhs.bounds
        && lhs.precision == rhs.precision
    }
    
    //*========================================================================*
    // MARK: UIKit
    //*========================================================================*
    
    #if canImport(UIKit)

    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=

    @inlinable public static func onSetup(of diffableTextField: ProxyTextField) {
        diffableTextField.keyboard.view(Value.isInteger ? .numberPad : .decimalPad)
    }

    #endif
}

//=----------------------------------------------------------------------------=
// MARK: Utilities
//=----------------------------------------------------------------------------=

public extension NumberTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=
    
    @inlinable func format(_ value: Value) -> String {
        format.precision(precision.inactive()).format(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Active
    //=------------------------------------------------------------------------=
    
    @inlinable func interpret(_ value: Value) -> Commit<Value> {
        //=--------------------------------------=
        // Style
        //=--------------------------------------=
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
        let parseable = snapshot(formatted)
        var number = try! number(parseable)
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&number)
        precision.autocorrect(&number)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        value = try! self.value(number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return commit(value, number, style)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    @inlinable func merge(_ changes: Changes) throws -> Commit<Value> {
        //=--------------------------------------=
        // Number
        //=--------------------------------------=
        var number = try number(changes)
        let count = number.count()
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(number)
        try precision.autovalidate(&number, count)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        let value = try value(number)
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(value, &number)
        //=--------------------------------------=
        // Style
        //=--------------------------------------=
        let style = format.precision(
        precision.interactive(count))
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return commit(value, number, style)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Helpers
//=----------------------------------------------------------------------------=

internal extension NumberTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Conversions
    //=------------------------------------------------------------------------=
    
    @inlinable func value(_ number: Number) throws -> Value {
        try lexicon.value(of: number, as: format)
    }
    
    @inlinable func number(_ snapshot: Snapshot) throws -> Number {
        try lexicon.number(in: snapshot, as: Value.self)
    }

    @inlinable func number(_ changes: Changes) throws -> Number {
        try Reader(lexicon).number(changes, as: Value.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Commit
    //=------------------------------------------------------------------------=
    
    @inlinable func commit(_ value: Value, _ number: Number, _ style: Format) -> Commit<Value> {
        //=--------------------------------------=
        // Style
        //=--------------------------------------=
        let sign = (number.sign == .negative) ? Format.Sign.always : .automatic
        let separator = (number.separator == .fraction) ? Format.Separator.always : .automatic
        let style = style.sign(sign).separator(separator)
        //=--------------------------------------=
        // Characters
        //=--------------------------------------=
        var characters = style.format(value)
        fix(number.sign, for: value, in: &characters)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return Commit(value, snapshot(characters))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    /// Assumes characters contain at least one content character.
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        var snapshot = characters.reduce(into: Snapshot()) { snapshot, character in
            let attribute: Attribute
            //=----------------------------------=
            // Digit
            //=----------------------------------=
            if lexicon.digits.contains(character) {
                attribute = .content
            //=----------------------------------=
            // Separator
            //=----------------------------------=
            } else if let separator = lexicon.separators[character] {
                attribute = (separator == .fraction) ? .removable : .phantom
            //=----------------------------------=
            // Sign
            //=----------------------------------=
            } else if lexicon.signs.contains(character) {
                attribute = .phantom.subtracting(.virtual)
            //=----------------------------------=
            // Miscellaneous
            //=----------------------------------=
            } else { attribute = .phantom }
            //=----------------------------------=
            // Insert
            //=----------------------------------=
            snapshot.append(Symbol(character, as: attribute))
        }
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        scheme.autocorrect(&snapshot); return snapshot
    }
}

//=----------------------------------------------------------------------------=
// MARK: Helpers
//=----------------------------------------------------------------------------=

internal extension NumberTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Fixes
    //=------------------------------------------------------------------------=
    
    /// This method exists because Apple always interpret zero as being positive.
    @inlinable func fix(_ sign: Sign, for value: Value, in characters: inout String)  {
        guard sign == .negative, value == .zero else { return }
        guard let index = characters.firstIndex(of: lexicon.signs[sign.toggled()]) else { return }
        characters.replaceSubrange(index...index, with: String(lexicon.signs[sign]))
    }
}
