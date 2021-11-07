//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

#if os(iOS)

import DiffableTextViews
import struct Foundation.Locale

// MARK: - NumericTextStyle

#warning("Could hide public values inside this struct.")
#warning("Break recursion with: NumericTextStyle<Value, Value>...?")

/// Formats text and number.
///
/// - Complexity: O(n) or less for all calculations.
public struct NumericTextStyle<Value: NumericTextValue>: DiffableTextStyle {
    @usableFromInline typealias Components = NumericTextComponents
    @usableFromInline typealias Configuration = NumericTextConfiguration
    @usableFromInline typealias NumberOfDigits = NumericTextNumberOfDigits

    public typealias Bounds = NumericTextBounds<Value>
    public typealias Precision = NumericTextPrecision<Value>

    // MARK: Properties
    
    @usableFromInline var locale: Locale
    
    @usableFromInline var bounds: Bounds = .all
    @usableFromInline var precision: Precision = .max
    
    @usableFromInline var prefix: String? = nil
    @usableFromInline var suffix: String? = nil
    
    // MARK: Initializers
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.locale = locale
    }
    
    // MARK: Initializers: Static
    
    @inlinable public static func number(locale: Locale = .autoupdatingCurrent) -> Self {
        .init(locale: locale)
    }
    
    // MARK: Getters, Locale

    @inlinable var decimalSeparator: String {
        locale.decimalSeparator ?? Components.Separator.system.characters
    }

    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? String()
    }
    
    // MARK: Getters, Numbers
    
    @inlinable var zero: Character {
        Components.Digits.zero
    }
    
    @inlinable var digits: Set<Character> {
        Components.Digits.set
    }
    
    @inlinable var signs: Set<Character> {
        Components.Sign.set
    }
}

// MARK: - Format

extension NumericTextStyle {
    
    // MARK: Styles
    
    @inlinable func displayableStyle() -> Value.FormatStyle {
        Value.style(locale, precision: precision.displayableStyle(), separator: .automatic)
    }
        
    @inlinable func editableStyle() -> Value.FormatStyle {
        Value.style(locale, precision: precision.editableStyle(), separator: .automatic)
    }
    
    @inlinable func editableStyle(digits: NumberOfDigits, separator: Bool) -> Value.FormatStyle {
        Value.style(locale, precision: precision.editableStyle(digits), separator: separator ? .always : .automatic)
    }
}

// MARK: - Update

extension NumericTextStyle {
    
    // MARK: Transformations
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        update({ $0.locale = locale })
    }
    
    @inlinable public func values(_ newValue: Bounds) -> Self {
        update({ $0.bounds = newValue })
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

extension NumericTextStyle {
    
    // MARK: Process
    
    @inlinable public func process(_ value: inout Value) {
        value = bounds.displayableStyle(value)
    }
        
    // MARK: Parse

    @inlinable public func parse(_ snapshot: Snapshot) -> Value? {
        components(snapshot, with: configuration()).flatMap(value)
    }
    
    // MARK: Components
    
    @inlinable func value(_ components: Components) -> Value? {
        components.hasDigits ? Value.value(components) : Value.zero
    }
}

// MARK: - Snapshot

extension NumericTextStyle {
    
    // MARK: Edit
    
    @inlinable public func snapshot(_ value: Value) -> Snapshot {
        snapshot(editableStyle().format(value))
    }
    
    // MARK: Showcase
    
    @inlinable public func showcase(_ value: Value) -> Snapshot {
        snapshot(displayableStyle().format(value))
    }
}

// MARK: - Snapshot

extension NumericTextStyle {
    
    // MARK: Merge
    
    @inlinable public func merge(_ current: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        let configuration = configuration()
                
        var input = NumericTextStyleInput(content, with: configuration)
        let toggleSignInstruction = input.consumeToggleSignInstruction()
        
        var next = current
        next.replaceSubrange(range, with: input.content)
                        
        guard var components = components(next, with: configuration) else { return nil }
        toggleSignInstruction?.process(&components)
                
        return snapshot(&components)
    }
    
    // MARK: Helpers, Components
    
    @inlinable func snapshot(_ components: inout Components) -> Snapshot? {
        let digits = components.numberOfDigitsWithoutZeroInteger()
        guard let capacity = precision.editableValidationWithCapacity(digits: digits) else { return nil }
        
        // --------------------------------- //
        
        if components.decimals.isEmpty, capacity.lower == .zero {
            components.separator = nil
        }
        
        // --------------------------------- //
        
        guard let value = value(components) else { return nil }
        guard bounds.editableValidation(value) else { return nil }
        
        let style = editableStyle(digits: digits, separator: components.separator != nil)
        var characters = style.format(value)
                
        // --------------------------------- //
        
        if let sign = components.sign, !characters.hasPrefix(sign.characters) {
            characters = sign.characters + characters
        }
        
        // --------------------------------- //
    
        return snapshot(characters)
    }
    
    // MARK: Helpers, Characters
    
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        var snapshot = Snapshot()
            
        // --------------------------------- //
        
        if let prefix = prefix {
            snapshot.append(contentsOf: Snapshot(prefix, only: .intuitive(.prefix)))
            snapshot.append(Symbol(" ", attribute: .intuitive(.prefix)))
        }
                
        // --------------------------------- //
        
        for character in characters {
            if digits.contains(character) {
                snapshot.append(.content(character))
            } else if groupingSeparator.contains(character) {
                snapshot.append(.spacer(character))
            } else if decimalSeparator.contains(character) {
                snapshot.append(.content(character))
            } else if signs.contains(character) {
                snapshot.append(.content(character).union([.prefix]))
            }
        }
                
        // --------------------------------- //

        configureFirstDigitIfItIsZero(in:         &snapshot, with: { $0.insert(.prefix) })
        configureDecimalSeparatorIfItIsSuffix(in: &snapshot, with: { $0.insert(.remove) })
                
        // --------------------------------- //

        if let suffix = suffix {
            snapshot.append(Symbol(" ", attribute: .intuitive(.suffix)))
            snapshot.append(contentsOf: Snapshot(suffix, only: .intuitive(.suffix)))
        }
    
        // --------------------------------- //
                
        return snapshot
    }
    
    @inlinable func configureFirstDigitIfItIsZero(in snapshot: UnsafeMutablePointer<Snapshot>, with instruction: (inout Attribute) -> Void) {
        func digit(symbol: Symbol) -> Bool { digits.contains(symbol.character) }
        guard let firstDigitIndex = snapshot.pointee.firstIndex(where: digit) else { return }
        guard snapshot.pointee[firstDigitIndex].character == zero else { return }
        snapshot.pointee.configure(attributes: firstDigitIndex, with: instruction)
        
    }
    
    @inlinable func configureDecimalSeparatorIfItIsSuffix(in snapshot: UnsafeMutablePointer<Snapshot>, with instruction: (inout Attribute) -> Void) {
        func predicate(symbol: Symbol) -> Bool { decimalSeparator.contains(symbol.character) }
        let decimalSeparatorAsSuffix = snapshot.pointee.suffix(while: predicate)
        let indices = decimalSeparatorAsSuffix.startIndex ..< decimalSeparatorAsSuffix.endIndex
        snapshot.pointee.configure(attributes: indices, with: instruction)
    }
}

// MARK: - NumericText

extension NumericTextStyle {
    
    // MARK: Configuration
    
    @inlinable func configuration() -> Configuration {
        let configuration = Configuration(signs: .negatives)
                
        if Value.integer {
            configuration.options.insert(.integer)
        } else {
            configuration.separators.insert(decimalSeparator)
        }
        
        if bounds.nonnegative {
            configuration.options.insert(.nonnegative)
        }
        
        return configuration
    }
    
    // MARK: Components With Configuration
    
    @inlinable func components(_ snapshot: Snapshot, with configuration: Configuration) -> Components? {
        configuration.components(snapshot.characters(where: \.content))
    }
}

// MARK: - Input

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

// MARK: Toggle Sign Instruction
        
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
