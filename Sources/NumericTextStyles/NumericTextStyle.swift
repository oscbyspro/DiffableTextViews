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

/// Formats text and numbers.
///
/// - Complexity: O(n) or less for all calculations.
public struct NumericTextStyle<Value: Boundable & Precise & Formattable>: DiffableTextStyle {
    public typealias Bounds = NumericTextStyles.Bounds<Value>
    public typealias Precision = NumericTextStyles.Precision<Value>

    // MARK: Properties
    
    @usableFromInline var locale: Locale
    @usableFromInline var prefix: String? = nil
    @usableFromInline var suffix: String? = nil
    
    @usableFromInline var bounds: Bounds = .all
    @usableFromInline var precision: Precision = .max
    
    // MARK: Initializers
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.locale = locale
    }
}

// MARK: - Update

extension NumericTextStyle {
    
    // MARK: Transformations
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        update({ $0.locale = locale })
    }
    
    @inlinable public func prefix(_ newValue: String?) -> Self {
        update({ $0.prefix = newValue })
    }
    
    @inlinable public func suffix(_ newValue: String?) -> Self {
        update({ $0.suffix = newValue })
    }
    
    @inlinable public func bounds(_ newValue: Bounds) -> Self {
        update({ $0.bounds = newValue })
    }
    
    @inlinable public func precision(_ newValue: Precision) -> Self {
        update({ $0.precision = newValue })
    }
    
    // MARK: Helpers
    
    @inlinable func update(_ transform: (inout Self) -> Void) -> Self {
        var copy = self; transform(&copy); return copy
    }
}

// MARK: - Getters

extension NumericTextStyle {
    
    // MARK: Locale

    @inlinable var decimalSeparator: String {
        locale.decimalSeparator ?? Components.Separator.system.characters
    }

    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? .init()
    }
    
    // MARK: Characters
    
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
        components.integers.isEmpty && components.decimals.isEmpty ? Value.zero : Value.value(components.characters())
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
                
        // --------------------------------- //
        
        var input = Input(content, with: configuration)
        let toggleSignInstruction = input.consumeToggleSignInstruction()
        
        // --------------------------------- //
        
        var next = current
        next.replaceSubrange(range, with: input.content)
        
        // --------------------------------- //
        
        guard var components = components(next, with: configuration) else { return nil }
        toggleSignInstruction?.process(&components)
        
        // --------------------------------- //
        
        return snapshot(&components)
    }
    
    // MARK: Components
    
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
    
    // MARK: Characters
    
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
    
    // MARK: Characters, Helpers
    
    @inlinable func configureFirstDigitIfItIsZero(in snapshot: UnsafeMutablePointer<Snapshot>, with configuration: (inout Attribute) -> Void) {
        func digit(symbol: Symbol) -> Bool {
            digits.contains(symbol.character)
        }
        
        // --------------------------------- //
        
        guard let position = snapshot.pointee.firstIndex(where: digit) else { return }
        guard snapshot.pointee[position].character == zero else { return }
        
        // --------------------------------- //
        
        snapshot.pointee.configure(attributes: position, with: configuration)
    }
    
    @inlinable func configureDecimalSeparatorIfItIsSuffix(in snapshot: UnsafeMutablePointer<Snapshot>, with configuration: (inout Attribute) -> Void) {
        func predicate(symbol: Symbol) -> Bool {
            decimalSeparator.contains(symbol.character)
        }
        
        // --------------------------------- //
        
        let start = snapshot.pointee
            .reversed()
            .prefix(while: predicate)
            .endIndex.base
        
        // --------------------------------- //
        
        snapshot.pointee.configure(attributes: start..., with: configuration)
    }
}

// MARK: - Text

extension NumericTextStyle {
    
    // MARK: Configuration
    
    @inlinable func configuration() -> Configuration {
        let configuration = Configuration(signs: .negatives, separators: .none)
        
        // --------------------------------- //
        
        if bounds.nonnegative {
            configuration.options.insert(.nonnegative)
        }
        
        // --------------------------------- //
        
        if Value.integer {
            configuration.options.insert(.integer)
        } else {
            configuration.separators.insert(decimalSeparator)
            configuration.separators.insert(contentsOf: .system)
        }
        
        // --------------------------------- //
        
        return configuration
    }
    
    // MARK: Components
    
    @inlinable func components(_ snapshot: Snapshot, with configuration: Configuration) -> Components? {
        configuration.components(snapshot.characters(where: \.content))
    }
}

#endif
