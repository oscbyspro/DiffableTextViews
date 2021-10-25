//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import struct Foundation.Locale

#if os(iOS)

// MARK: - NumericTextStyle

/// Formats text and number.
///
/// - Performance: It can easily format 1000+ digits.
public struct NumericTextStyle<Scheme: NumericTextScheme>: DiffableTextStyle {
    @usableFromInline typealias Components = NumericTextComponents
    @usableFromInline typealias Configuration = NumericTextConfiguration

    public typealias Value = Scheme.Number
    public typealias Values = NumericTextStyleValues<Scheme>
    public typealias Precision = NumericTextStylePrecision<Scheme>

    // MARK: Properties
    
    @usableFromInline var locale: Locale
    @usableFromInline var values: Values = .all
    @usableFromInline var precision: Precision = .max
    
    @usableFromInline var prefix: Snapshot? = nil
    @usableFromInline var suffix: Snapshot? = nil
    
    // MARK: Initializers
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.locale = locale
    }
    
    // MARK: Initializers: Static
    
    @inlinable public static func number(locale: Locale = .autoupdatingCurrent) -> Self {
        .init(locale: locale)
    }
    
    // MARK: Helpers, Locale

    @inlinable var decimalSeparator: String {
        locale.decimalSeparator ?? Components.Separator.system.characters
    }

    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? String()
    }
}

// MARK: - Formats

extension NumericTextStyle {
    
    // MARK: Displayable
    
    @inlinable func displayableStyle() -> Scheme.FormatStyle {
        let precision: Scheme.Precision = precision.displayableStyle()

        return Scheme.style(locale, precision: precision, separator: .automatic)
    }
    
    // MARK: Editable
    
    @inlinable func editableStyle(digits: (upper: Int, lower: Int)? = nil, separator: Bool = false) -> Scheme.FormatStyle {
        let precision: Scheme.Precision = precision.editableStyle(digits: digits)
        let separator: Scheme.Separator = separator ? .always : .automatic
        
        return Scheme.style(locale, precision: precision, separator: separator)
    }
}

// MARK: - Update

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
        update({ $0.prefix = newValue.map({ Snapshot($0, only: .prefix) }) })
    }
    
    @inlinable public func suffix(_ newValue: String?) -> Self {
        update({ $0.suffix = newValue.map({ Snapshot($0, only: .suffix) }) })
    }
    
    // MARK: Helpers
    
    @inlinable func update(_ transform: (inout Self) -> Void) -> Self {
        var copy = self; transform(&copy); return copy
    }
}

// MARK: - Value

extension NumericTextStyle {
        
    // MARK: Parse

    @inlinable public func parse(_ snapshot: Snapshot) -> Scheme.Number? {
        components(snapshot, with: configuration()).flatMap(value)
    }
    
    // MARK: Process
    
    @inlinable public func process(_ value: inout Scheme.Number) {
        value = values.displayableStyle(value)
    }
    
    // MARK: Components
    
    @inlinable func value(_ components: Components) -> Scheme.Number? {
        components.hasDigits ? Scheme.number(components) : Scheme.zero
    }
}

// MARK: - Snapshot

extension NumericTextStyle {
    
    // MARK: Snapshot
    
    public func process(_ snapshot: inout Snapshot) {
        snapshot.complete()
    }
    
    @inlinable public func showcase(_ value: Scheme.Number) -> Snapshot {
        snapshot(displayableStyle().format(value))
    }
    
    @inlinable public func snapshot(_ value: Scheme.Number) -> Snapshot {
        snapshot(editableStyle().format(value))
    }
    
    // MARK: Merge
    
    @inlinable public func merge(_ snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        let configuration = configuration()
                
        var input = NumericTextStyleInput(content, with: configuration)
        let toggleSignInstruction = input.consumeToggleSignInstruction()
                
        let result = snapshot.replace(range, with: input.content)
                
        guard var components = components(result, with: configuration) else { return nil }
        toggleSignInstruction?.process(&components)
                
        return self.snapshot(components)
    }
    
    // MARK: Helpers, Components
    
    @inlinable func snapshot(_ components: Components) -> Snapshot? {
        let digits = (components.integers.count, components.decimals.count)
        guard precision.editableValidation(digits: digits) else { return nil }
        
        guard let value = value(components) else { return nil }
        guard values.editableValidation(value) else { return nil }
        
        let style = editableStyle(digits: digits, separator: components.separator != nil)
        var _characters = style.format(value)
        
        if let sign = components.sign, !_characters.hasPrefix(sign.characters) {
            _characters = sign.characters + _characters
        }
    
        return snapshot(_characters)
    }
    
    // MARK: Helpers, Characters
    
    @inlinable func snapshot(_ _characters: String) -> Snapshot {
        var snapshot = Snapshot()
            
        // --------------------------------- //
        
        if let prefix = prefix {
            snapshot = prefix
            snapshot.append(.prefix(" "))
        }
        
        for character in _characters {
            if Components.Digits.set.contains(character) {
                snapshot.append(.content(character))
            } else if groupingSeparator.contains(character) {
                snapshot.append(.spacer(character))
            } else if decimalSeparator.contains(character) {
                snapshot.append(.content(character))
            } else if Components.Sign.set.contains(character) {
                snapshot.append(.content(character))
            }
        }
        
        if let suffix = suffix {
            snapshot.append(.suffix(" "))
            snapshot.append(contentsOf: suffix)
        }
    
        // --------------------------------- //
                
        return snapshot
    }
}

// MARK: - NumericText

extension NumericTextStyle {
    
    // MARK: Configuration
    
    @inlinable func configuration() -> Configuration {
        let configuration = Configuration(signs: .negatives)
                
        if Scheme.isInteger {
            configuration.options.insert(.integer)
        } else {
            configuration.separators.insert(decimalSeparator)
        }
        
        if values.nonnegative {
            configuration.options.insert(.nonnegative)
        }
        
        return configuration
    }
    
    // MARK: Components
    
    @inlinable func components(_ snapshot: Snapshot, with configuration: Configuration) -> Components? {
        configuration.components(snapshot.content())
    }
}

// MARK: - Inputs

@usableFromInline struct NumericTextStyleInput {
    @usableFromInline typealias Configuration = NumericTextConfiguration
    
    // MARK: Properties
    
    @usableFromInline var content: Snapshot
    @usableFromInline var configuration: Configuration
        
    // MARK: Initializers
            
    @inlinable init(_ content: Snapshot, with configuration: Configuration) {
        self.content = content
        self.configuration = configuration
    }
    
    // MARK: Utilities
    
    @inlinable mutating func consumeToggleSignInstruction() -> NumericTextStyleToggleSignInstruction? {
        .init(consumable: &content, with: configuration)
    }
}

// MARK: Commands: Toggle Sign
        
@usableFromInline struct NumericTextStyleToggleSignInstruction {
    @usableFromInline typealias Components = NumericTextComponents
    @usableFromInline typealias Configuration = NumericTextConfiguration

    // MARK: Properties
    
    @usableFromInline var sign: Components.Sign
    
    // MARK: Initializers
            
    @inlinable init?(consumable: inout Snapshot, with configuration: Configuration) {
        guard let sign = configuration.signs.interpret(consumable.characters) else { return nil }
                                        
        self.sign = sign
        consumable.removeAll()
    }
    
    // MARK: Utilities
            
    @inlinable func process(_ components: inout Components) {
        components.toggleSign(with: sign)
    }
}

#endif
