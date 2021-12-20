//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import DiffableTextViews
import struct Foundation.Locale
import protocol Utilities.Transformable

// MARK: - NumericTextStyle

/// Formats text and numbers.
///
/// - Complexity: O(n) or less for all calculations.
///
public struct NumericTextStyle<Value: NumericTextValue>: DiffableTextStyle, Transformable {
    public typealias Bounds = NumericTextStyles.Bounds<Value>
    public typealias Precision = NumericTextStyles.Precision<Value>

    // MARK: Properties
    
    @usableFromInline var locale: Locale
    @usableFromInline var prefix: String = ""
    @usableFromInline var suffix: String = ""
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
        transforming({ $0.locale = locale })
    }
    
    @inlinable public func prefix(_ newValue: String) -> Self {
        transforming({ $0.prefix = newValue })
    }
    
    @inlinable public func suffix(_ newValue: String) -> Self {
        transforming({ $0.suffix = newValue })
    }
    
    @inlinable public func bounds(_ newValue: Bounds) -> Self {
        transforming({ $0.bounds = newValue })
    }
    
    @inlinable public func precision(_ newValue: Precision) -> Self {
        transforming({ $0.precision = newValue })
    }
}

// MARK: - Getters

extension NumericTextStyle {
    
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
    
    @inlinable var decimalSeparator: String {
        locale.decimalSeparator ?? Components.Separator.system.characters
    }

    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? ""
    }
}

// MARK: - Format

extension NumericTextStyle {
    
    // MARK: Showcase
    
    @inlinable func showcaseStyle() -> Value.FormatStyle {
        Value.style(locale: locale, precision: precision.showcaseStyle(), separator: .automatic)
    }
    
    // MARK: Editable
    
    @inlinable func editableStyle() -> Value.FormatStyle {
        Value.style(locale: locale, precision: precision.editableStyle(), separator: .automatic)
    }
    
    @inlinable func editableStyle(digits: NumberOfDigits, separator: Bool) -> Value.FormatStyle {
        Value.style(locale: locale, precision: precision.editableStyle(digits), separator: separator ? .always : .automatic)
    }
}

// MARK: - Value

extension NumericTextStyle {
    
    // MARK: Process
    
    @inlinable public func process(value: inout Value) {
        value = bounds.displayableStyle(value)
    }
        
    // MARK: Parse

    @inlinable public func parse(snapshot: Snapshot) -> Value? {
        components(snapshot, with: configuration()).flatMap(value)
    }
    
    // MARK: Components
    
    @inlinable func value(of components: Components) -> Value? {
        components.integers.isEmpty && components.decimals.isEmpty ? Value.zero : Value.value(of: components.characters())
    }
}

// MARK: - Snapshot

extension NumericTextStyle {
    
    // MARK: Showcase
    
    @inlinable public func snapshot(showcase value: Value) -> Snapshot {
        snapshot(characters: showcaseStyle().format(value))
    }
    
    // MARK: Editable

    @inlinable public func snapshot(editable value: Value) -> Snapshot {
        snapshot(characters: editableStyle().format(value))
    }
}

// MARK: - Snapshot

extension NumericTextStyle {
    
    // MARK: Merge

    @inlinable public func merge(snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        let configuration = configuration()
                
        // --------------------------------- //
        
        var input = Input(content, with: configuration)
        let toggleSignInstruction = input.consumeToggleSignInstruction()
        
        // --------------------------------- //
        
        var next = snapshot
        next.replaceSubrange(range, with: input.content)
        
        // --------------------------------- //
        
        guard var components = components(next, with: configuration) else { return nil }
        toggleSignInstruction?.process(&components)
        
        // --------------------------------- //
        
        return self.snapshot(components: &components)
    }
    
    // MARK: Components
    
    @inlinable func snapshot(components: inout Components) -> Snapshot? {
        let digits = components.numberOfDigitsIgnoringSingleIntegerZero()
        guard let capacity = precision.editableValidationWithCapacity(digits: digits) else { return nil }
        
        // --------------------------------- //
        
        if capacity.lower <= 0, components.decimals.isEmpty {
            components.separator = nil
        }
        
        // --------------------------------- //
        
        guard let value = value(of: components) else { return nil }
        guard bounds.editableValidation(value)  else { return nil }
        
        // --------------------------------- //
        
        let style = editableStyle(digits: digits, separator: components.separator != nil)
                
        // --------------------------------- //
        
        var characters = style.format(value)
        
        if let sign = components.sign, !characters.hasPrefix(sign.characters) {
            characters = sign.characters + characters
        }
        
        // --------------------------------- //
    
        return snapshot(characters: characters)
    }
    
    // MARK: Characters
    
    @inlinable func snapshot(characters: String) -> Snapshot {
        var snapshot = Snapshot()
            
        // --------------------------------- //
        
        if !prefix.isEmpty {
            snapshot.append(contentsOf: Snapshot(prefix, only: .prefix))
            snapshot.append(.prefix(" "))
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
                snapshot.append(.content(character).union(.prefixing))
            }
        }
                
        // --------------------------------- //

        transformFirstDigitIfItIsZero(in:         &snapshot, using: { $0.insert(.prefixing) })
        transformDecimalSeparatorIfItIsSuffix(in: &snapshot, using: { $0.insert(.removable) })
                
        // --------------------------------- //

        if !suffix.isEmpty {
            snapshot.append(.suffix(" "))
            snapshot.append(contentsOf: Snapshot(suffix, only: .suffix))
        }
    
        // --------------------------------- //
                
        return snapshot
    }
    
    // MARK: Characters, Helpers
    
    @inlinable func transformFirstDigitIfItIsZero(in snapshot: UnsafeMutablePointer<Snapshot>, using transformation: (inout Attribute) -> Void) {
        func digit(symbol: Symbol) -> Bool {
            digits.contains(symbol.character)
        }
        
        // --------------------------------- //
        
        guard let position = snapshot.pointee.firstIndex(where: digit) else { return }
        guard snapshot.pointee[position].character == zero else { return }
        
        // --------------------------------- //
        
        snapshot.pointee.transform(attributes: position, using: transformation)
    }
    
    @inlinable func transformDecimalSeparatorIfItIsSuffix(in snapshot: UnsafeMutablePointer<Snapshot>, using transformation: (inout Attribute) -> Void) {
        func predicate(symbol: Symbol) -> Bool {
            decimalSeparator.contains(symbol.character)
        }
        
        // --------------------------------- //
        
        let start = snapshot.pointee
            .reversed()
            .prefix(while: predicate)
            .endIndex.base
        
        // --------------------------------- //
        
        snapshot.pointee.transform(attributes: start..., using: transformation)
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
        
        if Value.isInteger {
            configuration.options.insert(.integer)
        } else {
            configuration.separators.insert(decimalSeparator)
            configuration.separators.insert(contentsOf: .system)
        }
        
        // --------------------------------- //
        
        return configuration
    }
    
    // MARK: Components
    
    /// Unformatting can be made lazy.
    @inlinable func components(_ snapshot: Snapshot, with configuration: Configuration) -> Components? {
        configuration.components(snapshot.characters(where: \.nonformatting))
    }
}
