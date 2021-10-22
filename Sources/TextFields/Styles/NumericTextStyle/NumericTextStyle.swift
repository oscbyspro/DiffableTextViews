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
public struct NumericTextStyle<Scheme: NumericTextStyleScheme>: DiffableTextStyle {
    @usableFromInline typealias Components = NumericTextComponents

    public typealias Value = Scheme.Number
    public typealias Values = NumericTextStyleValues<Scheme>
    public typealias Precision = NumericTextStylePrecision<Scheme>

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
    
    // MARK: Helpers, Locale

    @inlinable var decimalSeparator: String {
        locale.decimalSeparator ?? Components.Separator.some.rawValue
    }

    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? Components.Separator.none.rawValue
    }
}

// MARK: - Formats

@available(iOS 15.0, *)
extension NumericTextStyle {
    
    // MARK: Displayable
    
    @inlinable func displayableStyle() -> Scheme.Style {
        let precision: Scheme.Precision = precision.displayableStyle()

        return Scheme.style(locale, precision: precision, separator: .automatic)
    }
    
    // MARK: Editable
    
    @inlinable func editableStyle(digits: (upper: Int, lower: Int)? = nil, separator: Bool = false) -> Scheme.Style {
        let precision: Scheme.Precision = precision.editableStyle(digits: digits)
        let separator: Scheme.Separator = separator ? .always : .automatic
        
        return Scheme.style(locale, precision: precision, separator: separator)
    }
}

// MARK: - Update

@available(iOS 15.0, *)
extension NumericTextStyle {
    
    // MARK: Transformations
    
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
    
    // MARK: Helpers
    
    @inlinable func update(_ transform: (inout Self) -> Void) -> Self {
        var copy = self; transform(&copy); return copy
    }
}

// MARK: - Value

@available(iOS 15.0, *)
extension NumericTextStyle {
    
    // MARK: Process
    
    @inlinable public func process(_ value: Scheme.Number) -> Scheme.Number {
        values.displayableStyle(value)
    }
    
    // MARK: Parse

    @inlinable public func parse(_ snapshot: Snapshot) -> Scheme.Number? {
        components(snapshot, with: componentsStyle()).flatMap(value)
    }
    
    // MARK: Components
    
    @inlinable func value(_ components: Components) -> Scheme.Number? {
        if components.integers.isEmpty, components.decimals.isEmpty {
            return Scheme.zero
        }
        
        return Scheme.number(components)
    }
}

// MARK: - Snapshot

@available(iOS 15.0, *)
extension NumericTextStyle {
    
    // MARK: Process
    
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
    
    // MARK: Merge
    
    @inlinable public func merge(_ snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        let componentsStyle = componentsStyle()
                
        var input = NumericTextStyleInput(content, with: componentsStyle)
        let toggleSignInstruction = input.consumeToggleSignInstruction()
                
        let result = snapshot.replace(range, with: input.content)
                
        guard var components = components(result, with: componentsStyle) else { return nil }
        toggleSignInstruction?.process(&components)
                
        return self.snapshot(components)
    }
    
    // MARK: Helpers, Components
    
    @inlinable func snapshot(_ components: Components) -> Snapshot? {
        let digits = (components.integers.count, components.decimals.count)
        guard precision.editableValidation(digits: digits) else { return nil }
        
        guard let value = value(components) else { return nil }
        guard values.editableValidation(value) else { return nil }
        
        let style = editableStyle(digits: digits, separator: components.separator != .none)
        var characters = style.format(value)
        
        if components.sign != .none, !characters.hasPrefix(components.sign.rawValue) {
            characters = components.sign.rawValue + characters
        }
    
        return snapshot(characters)
    }
    
    // MARK: Helpers, Characters
        
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

// MARK: - Components

@available(iOS 15.0, *)
extension NumericTextStyle {
    
    // MARK: Make
    
    @inlinable func components(_ snapshot: Snapshot, with componentsStyle: Components.Style) -> Components? {
        Components(snapshot.content(), style: componentsStyle)
    }
    
    // MARK: Style
    
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
}

// MARK: - Commands

@usableFromInline struct NumericTextStyleInput {
    @usableFromInline typealias Components = NumericTextComponents
    
    @usableFromInline var content: Snapshot
    @usableFromInline var componentsStyle: Components.Style
            
    @inlinable init(_ content: Snapshot, with componentsStyle: Components.Style) {
        self.content = content
        self.componentsStyle = componentsStyle
    }
            
    @inlinable mutating func consumeToggleSignInstruction() -> NumericTextStyleToggleSignInstruction? {
        .init(consumable: &content, with: componentsStyle)
    }
}
        
@usableFromInline struct NumericTextStyleToggleSignInstruction {
    @usableFromInline typealias Components = NumericTextComponents
    
    @usableFromInline var sign: Components.Sign
            
    @inlinable init?(consumable: inout Snapshot, with componentsStyle: Components.Style) {
        let sign = componentsStyle.signs.interpret(consumable.characters)
                    
        guard sign != .none else { return nil }
                    
        self.sign = sign
        consumable.removeAll()
    }
            
    @inlinable func process(_ components: inout Components) {
        components.toggleSign(with: sign)
    }
}

#endif
