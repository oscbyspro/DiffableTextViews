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
    public typealias Bounds = NumericTextStyles.Bounds<Value>
    public typealias Precision = NumericTextStyles.Precision<Value>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var format: Format
    @usableFromInline var region: Region
    @usableFromInline var bounds: Bounds
    @usableFromInline var precision: Precision
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(format: Format, locale: Locale = .autoupdatingCurrent) {
        self.bounds = Bounds()
        self.precision = Precision()
        self.region = Region.cached(locale)
        self.format = format.locale(region.locale)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        guard locale != self.region.locale else { return self }
        //=--------------------------------------=
        // MARK: Make New Instance
        //=--------------------------------------=
        var result = self
        result.region = Region.cached(locale)
        result.format = format.locale(result.region.locale)
        return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Comparisons
    //=------------------------------------------------------------------------=
    
    /// An equality comparison where the region is represented by the format.
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.format    == rhs.format    else { return false }
        guard lhs.bounds    == rhs.bounds    else { return false }
        guard lhs.precision == rhs.precision else { return false }
        return true
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Format
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(value: Value) -> String {
        format.precision(precision.inactive()).format(value)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Interpret
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    @inlinable public func interpret(value: Value) -> Commit<Value> {
        var style = format.precision(precision.active())
        var value = value
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(value: &value)
        //=--------------------------------------=
        // MARK: Value -> Number
        //=--------------------------------------=
        let formatted = style.format(value)
        let parseable = snapshot(characters: formatted)
        var number = try! region.number(in: parseable, as: Value.self)
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(sign: &number.sign)
        precision.autocorrect(number: &number)
        //=--------------------------------------=
        // MARK: Value <- Number
        //=--------------------------------------=
        value = try! region.value(in: number, as: style)
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        style = style.sign(sign(number: number))
        //=--------------------------------------=
        // MARK: Style -> Characters
        //=--------------------------------------=
        var characters = style.format(value)
        fix(sign: number.sign, for: value, in: &characters)
        //=--------------------------------------=
        // MARK: Characters -> Snapshot -> Commit
        //=--------------------------------------=
        let snapshot = snapshot(characters: characters)
        return Commit(value: value, snapshot: snapshot)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Merge
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(changes: Changes) throws -> Commit<Value> {
        var reader = Reader(changes, in: region)
        //=--------------------------------------=
        // MARK: Reader
        //=--------------------------------------=
        reader.translateSingleCharacterInput()
        let sign = reader.consumeSingleSignInput()
        let proposal = reader.changes.proposal()
        //=--------------------------------------=
        // MARK: Number
        //=--------------------------------------=
        var number = try region.number(in: proposal, as: Value.self)
        sign.map({ number.sign = $0 })
        //=--------------------------------------=
        // MARK: Number - Validate
        //=--------------------------------------=
        try bounds.validate(sign: number.sign)
        //=--------------------------------------=
        // MARK: Number - Count, Validate
        //=--------------------------------------=
        let count = number.count()
        let capacity = try precision.capacity(count: count)
        number.removeImpossibleSeparator(capacity: capacity)
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = try region.value(in: number, as: format)
        //=--------------------------------------=
        // MARK: Value - Validate
        //=--------------------------------------=
        let location = try bounds.validate(value: value)
        try bounds.validate(number: number, with: location)
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        let style = format.sign(self.sign(number: number))
        .precision(self.precision.interactive(count: count))
        .separator(self.separator(number: number))
        //=--------------------------------------=
        // MARK: Style -> Characters
        //=--------------------------------------=
        var characters = style.format(value)
        fix(sign: number.sign, for: value, in: &characters)
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
        characters.reduce(into: Snapshot()) { snapshot, character in
            let attribute: Attribute
            //=----------------------------------=
            // MARK: Match
            //=----------------------------------=
            if let _ = region.digits[character] {
                attribute = .content
            } else if let separator = region.separators[character] {
                attribute = separator == .fraction ? .removable : .phantom
            } else if let _ = region.signs[character] {
                attribute = .phantom.subtracting(.virtual)
            } else {
                attribute = .phantom
            }
            //=----------------------------------=
            // MARK: Insert
            //=----------------------------------=
            snapshot.append(Symbol(character, as: attribute))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Helpers
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(number: Number) -> Format.Sign {
        number.sign == .negative ? .always : .automatic
    }

    @inlinable func separator(number: Number) -> Format.Separator {
        number.separator == .fraction ? .always : .automatic
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Fixes
    //=------------------------------------------------------------------------=
        
    /// This method exists because Apple's format styles always interpret zero as having a positive sign.
    @inlinable func fix(sign: Sign, for value: Value, in characters: inout String) {
        guard sign == .negative, value == .zero else { return }
        guard let position = characters.firstIndex(where: region.signs.components.keys.contains) else { return }
        characters.replaceSubrange(position...position, with: String(region.signs[sign]))
    }
}
