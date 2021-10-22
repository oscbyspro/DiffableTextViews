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
public struct NumericTextStyle<Scheme: NumericTextScheme>: DiffableTextStyle {
    public typealias Value = Scheme.Number
    public typealias Values = NumericTextValues<Scheme>
    public typealias Precision = NumericTextPrecision<Scheme>
    
    @usableFromInline typealias Components = NumericTextComponents

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
        locale.decimalSeparator ?? Components.Separator.some.rawValue
    }

    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? Components.Separator.none.rawValue
    }
    
    // MARK: Formats
    
    @inlinable func displayableStyle() -> Scheme.Style {
        let precision: Scheme.Precision = precision.displayableStyle()

        return Scheme.style(locale, precision: precision, separator: .automatic)
    }
    
    @inlinable func editableStyle(digits: (upper: Int, lower: Int)? = nil, separator: Bool = false) -> Scheme.Style {
        let precision: Scheme.Precision = precision.editableStyle(digits: digits)
        let separator: Scheme.Separator = separator ? .always : .automatic
        
        return Scheme.style(locale, precision: precision, separator: separator)
    }

    // MARK: Snapshot
        
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        var snapshot = Snapshot()
        
        for character in characters {
            if Components.Digits.all.contains(character) {
                snapshot.append(.content(character))
            } else if Components.Sign.all.contains(character) {
                snapshot.append(.content(character))
            } else if decimalSeparator.contains(character) {
                snapshot.append(.content(character))
            } else if groupingSeparator.contains(character) {
                snapshot.append( .spacer(character))
            }
        }
        
        return snapshot
    }
}

// MARK: Conformance to: DiffableTextStyle

@available(iOS 15.0, *)
extension NumericTextStyle {
    
    // MARK: Process
    
    @inlinable public func process(_ value: Scheme.Number) -> Scheme.Number {
        values.displayableStyle(value)
    }
    
    @inlinable public func process(_ snapshot: Snapshot) -> Snapshot {
        let prefix = prefix.map({ Snapshot($0 + " ", only: .prefix) })
        let suffix = suffix.map({ Snapshot(" " + $0, only: .suffix) })
        
        let snapshots = [prefix, snapshot, suffix].compactMap({ $0 })
        
        return snapshots.dropFirst().reduce(into: snapshots.first!, +=)
    }
    
    // MARK: Snapshot
    
    @inlinable public func showcase(_ value: Scheme.Number) -> Snapshot {
        let style = displayableStyle()
        
        return snapshot(style.format(value))
    }
    
    @inlinable public func snapshot(_ value: Scheme.Number) -> Snapshot {
        let style = editableStyle()
        
        return snapshot(style.format(value))
    }
        
    // MARK: Parse

    @inlinable public func parse(_ snapshot: Snapshot) -> Scheme.Number? {
        guard let components = components(snapshot, style: componentsStyle()) else { return nil }
        
        guard !components.integers.isEmpty, !components.decimals.isEmpty else {
            return Scheme.zero
        }
        
        return Scheme.number(components)
    }
    
    // MARK: Merge
    
    @inlinable public func merge(_ snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        
        // --------------------------------- //
        
        let componentsStyle = componentsStyle()
        
        // --------------------------------- //
        
        var input = Input(content, style: componentsStyle)
        let toggleSignInstruction = input.consumeToggleSignInstruction()
        
        // --------------------------------- //
        
        let result = snapshot.replace(range, with: input.content)
        
        // --------------------------------- //
        
        guard var components = components(result, style: componentsStyle) else { return nil }
        toggleSignInstruction?.process(&components)
        
        // --------------------------------- //
        
        return self.snapshot(components)
    }
        
    // MARK: Helpers
    
    @inlinable func snapshot(_ components: Components) -> Snapshot? {
        
        // --------------------------------- //
        
        let digits = (components.integers.count, components.decimals.count)
        guard precision.editableValidation(digits: digits) else { return nil }
        
        // --------------------------------- //
        
        guard let value = Scheme.number(components) else { return nil }
        guard values.editableValidation(value) else { return nil }

        // --------------------------------- //
        
        let style = editableStyle(digits: digits, separator: components.separator != .none)
        
        // --------------------------------- //
        
        var characters = style.format(value)
        
        if components.sign != .none, !characters.hasPrefix(components.sign.rawValue) {
            
            characters = components.sign.rawValue + characters
        }
        
        // --------------------------------- //
                                
        return snapshot(characters)
    }

    // MARK: Helpers, Components
    
    @inlinable func components(_ snapshot: Snapshot, style: Components.Style) -> Components? {
        Components(snapshot.content(), style: style)
    }
    
    @inlinable func componentsStyle() -> Components.Style {
        let componentsStyle = Components.Style()
        componentsStyle.signs.positives.removeAll()
                
        if Scheme.isInteger {
            componentsStyle.options.insert(.integer)
        } else {
            componentsStyle.separators.insert([decimalSeparator])
        }
        
        if values.nonnegative {
            componentsStyle.options.insert(.nonnegative)
        }
        
        return componentsStyle
    }
    
    // MARK: Input
    
    @usableFromInline struct Input {
        
        // MARK: Properties
        
        @usableFromInline var content: Snapshot
        @usableFromInline var componentsStyle: Components.Style
        
        // MARK: Initializers
        
        @inlinable init(_ content: Snapshot, style componentsStyle: Components.Style) {
            self.content = content
            self.componentsStyle = componentsStyle
        }
        
        // MARK: Utilities
        
        @inlinable mutating func consumeToggleSignInstruction() -> ToggleSignInstruction? {
            ToggleSignInstruction(consumable: &content, with: componentsStyle)
        }
    }
    
    // MARK: ToggleSignInstruction
        
    @usableFromInline struct ToggleSignInstruction {
        
        // MARK: Properties
        
        @usableFromInline var sign: Components.Sign
        
        // MARK: Initializers
        
        @inlinable init?(consumable: inout Snapshot, with style: Components.Style) {
            let sign = style.signs.interpret(consumable.characters)
                        
            guard sign != .none else { return nil }
                        
            self.sign = sign
            consumable.removeAll()
        }
        
        // MARK: Utilities
        
        @inlinable func process(_ components: inout Components) {
            components.toggleSign(with: sign)
        }
    }
}

#endif
