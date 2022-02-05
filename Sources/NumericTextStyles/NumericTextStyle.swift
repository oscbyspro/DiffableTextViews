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

//*============================================================================*
// MARK: * NumericTextStyle
//*============================================================================*

public struct NumericTextStyle<Format: NumericTextStyles.Format>: DiffableTextStyle {
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
        self.format = format
        self.bounds = Bounds()
        self.precision = Precision()
        self.region = Region.cached(locale)
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
        result.format = format.locale(locale)
        result.region = Region.cached(locale)
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
// MARK: NumericTextStyle - Format
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(value: Value) -> String {
        format.style(precision: precision.inactive()).format(value)
    }
}

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - Commit
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    @inlinable public func commit(value: Value) -> Commit<Value> {
        let style = format.style(precision: precision.active())
        var value = value
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&value)
        //=--------------------------------------=
        // MARK: Value -> Number
        //=--------------------------------------=
        let formatted = style.format(value)
        let parseable = snapshot(characters: formatted)
        var number = try! region.number(in: parseable, as: Value.self)
        //=--------------------------------------=
        // MARK: Autocorrect
        //=--------------------------------------=
        precision.autocorrect(&number)
        //=--------------------------------------=
        // MARK: Value <- Number
        //=--------------------------------------=
        value = try! region.value(in: number, as: style)
        //=--------------------------------------=
        // MARK: Characters, Snapshot, Commit
        //=--------------------------------------=
        let characters = style.format(value)
        let snapshot = snapshot(characters: characters)
        return Commit(value: value, snapshot: snapshot)
    }
}

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - Merge
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Downstream
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(changes: Changes) throws -> Commit<Value> {
        var reader = Reader(changes, in: region)
        let modify = reader.consumeSetSignInput()
        //=--------------------------------------=
        // MARK: Number
        //=--------------------------------------=
        var number = try region.number(
        in: reader.changes.proposal(),
        as: Value.self); modify?(&number)
        //=--------------------------------------=
        // MARK: Number - Validate Sign
        //=--------------------------------------=
        try bounds.validate(sign: number.sign)
        //=--------------------------------------=
        // MARK: Count
        //=--------------------------------------=
        let count = number.count()
        //=--------------------------------------=
        // MARK: Capacity
        //=--------------------------------------=
        let capacity = try precision.capacity(count: count)
        number.removeImpossibleSeparator(capacity: capacity)
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let value = try region.value(in: number, as: format)
        //=--------------------------------------=
        // MARK: Value - Validate
        //=--------------------------------------=
        try bounds.validate(value: value)
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        let style = format.style(
        precision: precision.interactive(count: count),
        separator: number.separator == .fraction ? .always : .automatic,
        sign: number.sign == .negative ? .always : .automatic)
        //=--------------------------------------=
        // MARK: Characters
        //=--------------------------------------=
        var characters = style.format(value)
        fix(sign: number.sign, for: value, in: &characters)
        //=--------------------------------------=
        // MARK: Snapshot, Commit
        //=--------------------------------------=
        let snapshot = snapshot(characters: characters)
        return Commit(value: value, snapshot: snapshot)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    /// This method exists because Apple's format styles always interpret zero as having a positive sign.
    @inlinable func fix(sign: Sign, for value: Value, in characters: inout String) {
        guard sign == .negative && value == .zero  else { return }
        guard let position = characters.firstIndex(where: region.signs.components.keys.contains) else { return }
        guard let replacement = region.signs[sign] else { return }
        characters.replaceSubrange(position...position, with: String(replacement))
    }
}

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - Snapshot
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=

    /// Assumes that characters contains at least one content character.
    @inlinable func snapshot(characters: String) -> Snapshot {
        characters.reduce(into: Snapshot()) { snapshot, character in
            if let _ = region.digits[character] {
                snapshot.append(Symbol(character, as: .content))
            } else if let separator = region.separators[character] {
                snapshot.append(Symbol(character, as: separator == .fraction ? .removable : .phantom))
            } else if let _ = region.signs[character] {
                snapshot.append(Symbol(character, as: .phantom.subtracting(.virtual)))
            } else {
                snapshot.append(Symbol(character, as: .phantom))
            }
        }
    }
}
