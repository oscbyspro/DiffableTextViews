//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import SwiftUI
import struct Foundation.Locale

#if os(iOS)

// MARK: - NumericTextStyle

@available(iOS 15.0, *)
public struct NumericText<Item: NumericTextItem>: DiffableTextStyle {
    public typealias Value = Item.Number
    public typealias Values = NumericTextValues<Item>
    public typealias Precision = NumericTextPrecision<Item>
    
    @usableFromInline typealias Components = NumericTextComponents
    @usableFromInline typealias Configuration = Components.Configuration
    
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
        var characters = Set<Character>()
        characters.formUnion(Configuration.Signs.both)
        characters.formUnion(Configuration.Digits.all)
        characters.formUnion(decimalSeparator)
        return characters
    }
    
    @inlinable func spacers() -> Set<Character> {
        var characters = Set<Character>()
        characters.formUnion(groupingSeparator)
        return characters
    }
}

// MARK: Conformance to: DiffableTextStyle

@available(iOS 15.0, *)
extension NumericText {
    
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
        let configuration = configuration()
        
        return components(snapshot, with: configuration).flatMap(Item.number)
    }
    
    // MARK: Merge
    
    @inlinable public func merge(_ snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        
        // --------------------------------- //
        
        let configuration = configuration()
        
        // --------------------------------- //
        
        var input = Input(content, with: configuration)
        let toggleSignInstruction = input.consumeToggleSignInstruction()
        
        // --------------------------------- //
        
        let result = snapshot.replace(range, with: input.content)
        
        // --------------------------------- //
        
        guard var components = components(result, with: configuration) else { return nil }
        toggleSignInstruction?.process(&components)
        
        // --------------------------------- //
        
        return self.snapshot(components)
    }
        
    // MARK: Helpers
    
    @inlinable func snapshot(_ components: Components) -> Snapshot? {
        
        // --------------------------------- //
        
        let digits = (components.integerDigits.count, components.decimalDigits.count)
        guard precision.editableValidation(digits: digits) else { return nil }
        
        // --------------------------------- //
        
        guard let value = Item.number(components) else { return nil }
        guard values.editableValidation(value) else { return nil }

        // --------------------------------- //
        
        let style = editableStyle(digits: digits, separator: !components.decimalSeparator.isEmpty)
        
        // --------------------------------- //
        
        var characters = style.format(value)
        
        if !components.sign.isEmpty,
           !characters.hasPrefix(components.sign) {
            
            characters = components.sign + characters
        }
        
        // --------------------------------- //
                        
        return snapshot(characters)
    }

    // MARK: Helpers, Components
    
    @inlinable func components(_ snapshot: Snapshot, with configuration: Configuration) -> Components? {
        Components(snapshot.content(), with: configuration)
    }
    
    @inlinable func configuration() -> Configuration {
        let configuration = Configuration()
        configuration.signs.remove(all: .positive)
        
        // --------------------------------- //
        
        if Item.isInteger {
            configuration.options.insert(.integer)
        } else {
            configuration.separators.insert([decimalSeparator])
        }
        
        // --------------------------------- //
        
        if values.nonnegative {
            configuration.options.insert(.nonnegative)
        }
        
        // --------------------------------- //

        return configuration
    }
    
    // MARK: Helpers, Snapshot
    
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
        @usableFromInline var configuration: Configuration
        
        // MARK: Initializers
        
        @inlinable init(_ content: Snapshot, with configuration: Configuration) {
            self.content = content
            self.configuration = configuration
        }
        
        // MARK: Utilities
        
        @inlinable mutating func consumeToggleSignInstruction() -> ToggleSignInstruction? {
            ToggleSignInstruction(consumable: &content, with: configuration)
        }
    }
    
    // MARK: ToggleSignInstruction
        
    @usableFromInline struct ToggleSignInstruction {
        
        // MARK: Properties
        
        @usableFromInline var denomination: Configuration.Signs.Denomination
        
        // MARK: Initializers
        
        @inlinable init?(consumable: inout Snapshot, with configuration: Configuration) {
            guard let denomination = configuration.signs.interpret(consumable.characters) else { return nil }
            
            defer {
                consumable.removeAll()
            }

            self.denomination = denomination
        }
        
        // MARK: Utilities
        
        @inlinable func process(_ components: inout Components) {
            components.toggle(sign: denomination)
        }
    }
}

#endif
