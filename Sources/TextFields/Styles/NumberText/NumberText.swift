//
//  NumberTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import SwiftUI
import struct Foundation.Locale

#if os(iOS)

// MARK: - NumberTextStyle

@available(iOS 15.0, *)
public struct NumberText<Item: NumberTextItem>: DiffableTextStyle {
    public typealias Value = Item.Number
    public typealias Values = NumberTextValues<Item>
    public typealias Precision = NumberTextPrecision<Item>
    
    @usableFromInline typealias Components = NumberTextComponents
    @usableFromInline typealias PrecisionStyle = NumberFormatStyleConfiguration.Precision
    @usableFromInline typealias SeparatorStyle = NumberFormatStyleConfiguration.DecimalSeparatorDisplayStrategy

    // MARK: Properties
    
    @usableFromInline var locale: Locale
    @usableFromInline var values: Values = .all
    @usableFromInline var precision: Precision = .max
    
    @usableFromInline var prefix: String? = nil
    @usableFromInline var suffix: String? = nil
    
    // MARK: Initializers
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.locale = locale
    }
    
    // MARK: Styles
    
    @inlinable func displayableStyle() -> Item.Style {
        let precision: PrecisionStyle = precision.displayableStyle()

        return Item.style(locale, precision: precision, separator: .automatic)
    }
    
    @inlinable func editableStyle(digits: (upper: Int, lower: Int)? = nil, separator: Bool = false) -> Item.Style {
        let precision: PrecisionStyle = precision.editableStyle(digits: digits)
        let separator: SeparatorStyle = separator ? .always : .automatic
        
        return Item.style(locale, precision: precision, separator: separator)
    }
    
    // MARK: Maps
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        update({ $0.locale = locale })
    }
    
    @inlinable public func values(_ newValue: Values) -> Self {
        update({ $0.values = newValue })
    }
    
    @inlinable public func precision(_ newValue: Precision) -> Self {
        update({ $0.precision = newValue })
    }
    
    @inlinable public func prefix(_ newValue: String?) -> Self {
        update({ $0.prefix = newValue })
    }
    
    @inlinable public func suffix(_ newValue: String?) -> Self {
        update({ $0.suffix = newValue })
    }
    
    // MARK: Helpers, Maps
    
    @inlinable func update(_ transform: (inout Self) -> Void) -> Self {
        var copy = self; transform(&copy); return copy
    }

    // MARK: Helpers, Locale
    
    @inlinable var decimalSeparator: String {
        locale.decimalSeparator ?? "."
    }
    
    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? ","
    }
    
    // MARK: Helpers, Snapshot
    
    @inlinable func content() -> Set<Character> {
        var set = Set<Character>()
        set.formUnion(Components.Constants.minus)
        set.formUnion(Components.Constants.digits)
        set.formUnion(decimalSeparator)
        return set
    }
    
    @inlinable func spacers() -> Set<Character> {
        var set = Set<Character>()
        set.formUnion(groupingSeparator)
        return set
    }
}

// MARK: Conformance to: DiffableTextStyle

@available(iOS 15.0, *)
extension NumberText {
    
    // MARK: Process
    
    @inlinable public func process(_ value: Item.Number) -> Item.Number {
        values.displayableStyle(value)
    }
    
    @inlinable public func process(_ snapshot: Snapshot) -> Snapshot {
        let prefix = prefix.map({ Snapshot($0 + " ", only: .prefix) })
        let suffix = suffix.map({ Snapshot(" " + $0, only: .suffix) })
        
        let snapshots = [prefix, snapshot, suffix].compactMap({ $0 })
        
        return snapshots.dropFirst().reduce(into: snapshots.first!, +=)
    }
    
    // MARK: Snapshot
    
    @inlinable public func showcase(_ value: Item.Number) -> Snapshot {
        let style = displayableStyle()
        
        return snapshot(style.format(value))
    }
    
    @inlinable public func snapshot(_ value: Item.Number) -> Snapshot {
        let style = editableStyle()
        
        return snapshot(style.format(value))
    }
        
    // MARK: Parse

    @inlinable public func parse(_ snapshot: Snapshot) -> Item.Number? {
        components(snapshot).flatMap(value)
    }
    
    // MARK: Merge
    
    @inlinable public func merge(_ snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        
        // --------------------------------- //
        
        var input = Input(content)
                
        // --------------------------------- //
        
        let toggleSignInstruction = input.consumeToggleSignInstruction()
                        
        // --------------------------------- //
        
        let result = snapshot.replace(range, with: input.content)
        
        // --------------------------------- //
        
        guard var components = components(result) else { return nil }

        // --------------------------------- //
        
        toggleSignInstruction?.process(&components)
                
        // --------------------------------- //
        
        return self.snapshot(components)
    }
        
    // MARK: Helpers
    
    @inlinable func snapshot(_ components: Components) -> Snapshot? {
        
        // --------------------------------- //
        
        let digits = (components.integerDigits.count, components.decimalDigits.count)
        
        // --------------------------------- //
        
        guard precision.editableValidation(digits: digits) else { return nil }
        
        // --------------------------------- //
        
        guard let value = value(components), values.editableValidation(value) else { return nil }

        // --------------------------------- //
        
        let style = editableStyle(digits: digits, separator: !components.decimalSeparator.isEmpty)
        
        // --------------------------------- //
                                
        let characters = editableCharacters(style: style, value: value, components: components)
        
        // --------------------------------- //
                
        return snapshot(characters)
    }
    
    // MARK: Helpers
    
    @inlinable func editableCharacters(style: Item.Style, value: Item.Number, components: Components) -> String {
        var characters = style.format(value)
        correctSignIsAbsent(in: &characters, expectation: components.sign)
        return characters
    }
    
    @inlinable func correctSignIsAbsent(in characters: inout String, expectation sign: String) {
        guard !sign.isEmpty else { return }
        guard !characters.hasPrefix(sign) else { return }
        characters = sign + characters
    }

    // MARK: Helpers
    
    @inlinable func value(_ components: Components) -> Value? {
        guard !components.digitsAreEmpty else {
            return Item.zero
        }
        
        return Item.number(components)
    }
    
    @inlinable func components(_ snapshot: Snapshot) -> Components? {
        
        // --------------------------------- //
        
        let characters = snapshot.content()
        
        // --------------------------------- //
        
        let separators = Components.Separators
            .translates([decimalSeparator])
        
        let options = Components.Options()
            .insert(.integer, when: Item.isInteger)
            .insert(.nonnegative, when: values.nonnegative)
        
        guard let components = Components(characters, separators: separators, options: options) else { return nil }
        
        // --------------------------------- //

        return components
    }
    
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        var snapshot = Snapshot()
        
        let contentSet = content()
        let spacersSet = spacers()
        
        for character in characters {
            if contentSet.contains(character) {
                snapshot.append(.content(character))
            } else if spacersSet.contains(character) {
                snapshot.append(.spacer(character))
            }
        }
                
        return snapshot
    }
        
    // MARK: Input
    
    @usableFromInline struct Input {
        
        // MARK: Properties
        
        @usableFromInline var content: Snapshot
        
        // MARK: Initializers
        
        @inlinable init(_ content: Snapshot) {
            self.content = content
        }
        
        // MARK: Utilities
        
        @inlinable mutating func consumeToggleSignInstruction() -> ToggleSignInstruction? {
            ToggleSignInstruction(consumable: &content)
        }
    }
    
    // MARK: ToggleSignInstruction
        
    @usableFromInline struct ToggleSignInstruction {
        
        // MARK: Properties
        
        @usableFromInline var sign: String
        
        // MARK: Initializers
        
        @inlinable init?(consumable: inout Snapshot) {
            guard consumable.characters == Components.Constants.minus else { return nil }
            self.sign = consumable.characters
            consumable.removeAll()
        }
        
        // MARK: Utilities
        
        @inlinable func process(_ components: inout Components) {
            components.toggle(sign: sign)
        }
    }
}

#endif
