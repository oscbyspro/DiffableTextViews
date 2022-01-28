//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import DiffableTextViews
import Foundation

#warning("FIXME: fraction deletion with trailing zeros.")
//*============================================================================*
// MARK: * NumericTextStyle
//*============================================================================*

public struct NumericTextStyle<Format: NumericTextStyles.Format>: DiffableTextStyle {
    public typealias Value = Format.FormatInput
    public typealias Bounds = NumericTextStyles.Bounds<Value>
    public typealias Precision = NumericTextStyles.Precision<Value>

    //=------------------------------------------------------------------------=
    // MARK: Properties
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
        var result = self
        
        if  result.region.locale != locale {
            result.format = format.locale(locale)
            result.region = Region.cached(locale)
        }
        
        return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import UIKit

extension NumericTextStyle: UIKitDiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable public static func setup(diffableTextField: ProxyTextField) {
        diffableTextField.keyboard(Value.isInteger ? .numberPad : .decimalPad)
    }
}

#endif

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
// MARK: NumericTextStyle - Upstream
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Showcase
    //=------------------------------------------------------------------------=
    
    @inlinable public func showcase(value: Value) -> String {
        format.style(precision: precision.showcase()).format(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Editable
    //=------------------------------------------------------------------------=
    
    #error("FIXME: This should not be called on request.")
    @inlinable public func editable(value: Value) -> Commit<Value> {
        let style = format.style(precision: precision.editable())
        //=--------------------------------------=
        // MARK: Value, Autocorrect
        //=--------------------------------------=
        var autocorrectable = value
        bounds.clamp(&autocorrectable)
        style.autocorrect(&autocorrectable)
        //=--------------------------------------=
        // MARK: Characters, Snapshot
        //=--------------------------------------=
        let characters = style.format(autocorrectable)
        let snapshot = snapshot(characters: characters)
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return Commit(value: autocorrectable, snapshot: snapshot)
    }
}

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - Downstream
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Commit
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(request: Request) throws -> Commit<Value> {
        var reader = Reader(request, in: region)
        let change = reader.consumeSignCommand()
        //=--------------------------------------=
        // MARK: Number
        //=--------------------------------------=
        var number = try region.number(
        in: reader.request.proposal(),
        as: Value.self); change?(&number)
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
        let value = try format.parse(region.characters(in: number))
        try bounds.validate(value: value)
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        let style = format.style(
        precision: precision.editable(count: count),
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
        return Commit(value: value, snapshot: self.snapshot(characters: characters))
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
