//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews
import Foundation
import Support

//*============================================================================*
// MARK: * NumericTextStyle
//*============================================================================*

public struct NumericTextStyle<Format: NumericTextFormat>: DiffableTextStyle {
    public typealias Value = Format.FormatInput
    public typealias Adapter = Format.NumericTextAdapter
    public typealias Bounds = NumericTextStyles.Bounds<Value>
    public typealias Precision = NumericTextStyles.Precision<Value>

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
        self.bounds = Bounds()
        self.precision = Precision()
    }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var format:  Format  { adapter.format  }
    @inlinable var locale:  Locale  { adapter.locale  }
    @inlinable var lexicon: Lexicon { adapter.lexicon }

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        guard locale != self.locale else { return self }
        var result = self; result.adapter = adapter.locale(locale); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.adapter   == rhs.adapter   else { return false }
        guard lhs.bounds    == rhs.bounds    else { return false }
        guard lhs.precision == rhs.precision else { return false }
        return true
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Format
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(value: Value) -> String {
        format.precision(precision.inactive()).format(value)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Upstream
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Interpret
    //=------------------------------------------------------------------------=
    
    @inlinable public func interpret(value: Value) -> Commit<Value> {
        var style = format.precision(precision.active())
        var value = value
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(value: &value)
        //=--------------------------------------=
        // MARK: Value -> Components
        //=--------------------------------------=
        let formatted = style.format(value)
        let parseable = snapshot(characters: formatted)
        var components = try! lexicon.components(in: parseable, as: Value.self)
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(sign: &components.sign)
        precision.autocorrect(components: &components)
        //=--------------------------------------=
        // MARK: Value <- Components
        //=--------------------------------------=
        value = try! lexicon.value(in: components, as: style)
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        style = style.sign(self.sign(components: components))
        //=--------------------------------------=
        // MARK: Style -> Characters
        //=--------------------------------------=
        var characters = style.format(value)
        fix(sign: components.sign, for: value, in: &characters)
        //=--------------------------------------=
        // MARK: Characters -> Snapshot -> Commit
        //=--------------------------------------=
        let snapshot = snapshot(characters: characters)
        return Commit(value: value, snapshot: snapshot)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Downstream
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Merge
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(changes: Changes) throws -> Commit<Value> {
        var reader = Reader(changes, in: lexicon)
        //=--------------------------------------=
        // MARK: Reader
        //=--------------------------------------=
        reader.translateSingleCharacterInput()
        let sign = reader.consumeSingleSignInput()
        let proposal = reader.changes.proposal()
        //=--------------------------------------=
        // MARK: Components
        //=--------------------------------------=
        var components = try lexicon.components(in: proposal, as: Value.self)
        sign.map({ components.sign = $0 })
        //=--------------------------------------=
        // MARK: Components - Validate
        //=--------------------------------------=
        try bounds.validate(sign: components.sign)
        //=--------------------------------------=
        // MARK: Components - Count, Validate
        //=--------------------------------------=
        let count = components.count()
        let capacity = try precision.capacity(count: count)
        components.removeImpossibleSeparator(capacity: capacity)
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = try lexicon.value(in: components, as: format)
        //=--------------------------------------=
        // MARK: Value - Validate
        //=--------------------------------------=
        let location = try bounds.validate(value: value)
        try bounds.validate(components: components, with: location)
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        let style = format.sign(self.sign(components: components))
        .precision(self.precision.interactive(count: count))
        .separator(self.separator(components: components))
        //=--------------------------------------=
        // MARK: Style -> Characters
        //=--------------------------------------=
        var characters = style.format(value)
        fix(sign: components.sign, for: value, in: &characters)
        //=--------------------------------------=
        // MARK: Characters -> Snapshot -> Commit
        //=--------------------------------------=
        let snapshot = snapshot(characters: characters)
        return Commit(value: value, snapshot: snapshot)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Snapshot
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=

    /// Assumes that characters contains at least one content character.
    @inlinable func snapshot(characters: String) -> Snapshot {
        var snapshot = characters.reduce(into: Snapshot()) { snapshot, character in
            let attribute: Attribute
            //=----------------------------------=
            // MARK: Match
            //=----------------------------------=
            if let _ = lexicon.digits[character] {
                attribute = .content
            } else if let separator = lexicon.separators[character] {
                attribute = separator == .fraction ? .removable : .phantom
            } else if let _ = lexicon.signs[character] {
                attribute = .phantom.subtracting(.virtual)
            } else {
                attribute = .phantom
            }
            //=----------------------------------=
            // MARK: Insert
            //=----------------------------------=
            snapshot.append(Symbol(character, as: attribute))
        }
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        adapter.autocorrect(snapshot: &snapshot); return snapshot
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Helpers
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(components: Components) -> Format.Sign {
        components.sign == .negative ? .always : .automatic
    }

    @inlinable func separator(components: Components) -> Format.Separator {
        components.separator == .fraction ? .always : .automatic
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Fixes
    //=------------------------------------------------------------------------=
        
    /// This method exists because Apple's format styles always interpret zero as having a positive sign.
    @inlinable func fix(sign: Sign, for value: Value, in characters: inout String) {
        guard sign == .negative, value == .zero else { return }
        guard let position = characters.firstIndex(where: lexicon.signs.components.keys.contains) else { return }
        characters.replaceSubrange(position...position, with: String(lexicon.signs[sign]))
    }
}
