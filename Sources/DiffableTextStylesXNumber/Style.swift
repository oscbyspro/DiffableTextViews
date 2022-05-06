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

public struct _NumberTextStyle<Format: NumberTextFormat>: NumberTextStyleProtocol {
    public typealias Value = Format.FormatInput
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
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var format: Format {
        adapter.format
    }
    
    @inlinable var lexicon: Lexicon {
        adapter.lexicon
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
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

public extension _NumberTextStyle {
    
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
        var number = try! adapter.number(parseable)
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&number)
        precision.autocorrect(&number)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        value = try! adapter.value(number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return commit(value, number, style)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    @inlinable func merge(_ proposal: Proposal) throws -> Commit<Value> {
        try merge(number(proposal)!)
    }
    
    @inlinable internal func merge(_ number: Number) throws -> Commit<Value> {
        var number = number
        let count = number.count()
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(&number)
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

internal extension _NumberTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    /// Assumes characters contain at least one content character.
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        //=--------------------------------------=
        // Snapshot
        //=--------------------------------------=
        var snapshot = characters.reduce(into: Snapshot()) {
            snapshot,  character in
            snapshot.append(symbol(character))
        }
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        adapter.autocorrect(&snapshot); return snapshot
    }
    
    @inlinable func symbol(_ character: Character) -> Symbol {
        let attribute: Attribute
        //=--------------------------------------=
        // Digit
        //=--------------------------------------=
        if lexicon.digits.contains(character) {
            attribute = .content
        //=--------------------------------------=
        // Separator
        //=--------------------------------------=
        } else if let separator = lexicon.separators[character] {
            attribute = (separator == .fraction) ? .removable : .phantom
        //=--------------------------------------=
        // Sign
        //=--------------------------------------=
        } else if lexicon.signs.contains(character) {
            attribute = .phantom.subtracting(.virtual)
        //=--------------------------------------=
        // Miscellaneous
        //=--------------------------------------=
        } else { attribute = .phantom }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return Symbol(character, as: attribute)
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
    
    
    /// This method exists because Apple always interpret zero as being positive.
    @inlinable func fix(_ sign: Sign, for value: Value, in characters: inout String)  {
        //=--------------------------------------=
        // Condition
        //=--------------------------------------=
        guard sign == .negative, value == .zero else { return }
        //=--------------------------------------=
        // Toggle Positive Zero Sign To Negative
        //=--------------------------------------=
        guard let index = characters.firstIndex(of: lexicon.signs[sign.toggled()]) else { return }
        characters.replaceSubrange(index...index, with: String(lexicon.signs[sign]))
    }
}
