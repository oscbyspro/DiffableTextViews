//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

#if os(iOS)

import struct Foundation.Locale

// MARK: - NumericTextStyle

/// Formats text and number.
///
/// It can easily format 1,000+ digits if its scheme permits it.
///
/// - Complexity: O(n) or less for all calculations.
public struct NumericTextStyle<Scheme: NumericTextScheme>: DiffableTextStyle {
    @usableFromInline typealias Components = NumericTextComponents
    @usableFromInline typealias Configuration = NumericTextConfiguration
    @usableFromInline typealias NumberOfDigits = NumericTextNumberOfDigits

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

// MARK: - Format

extension NumericTextStyle {
    
    // MARK: Styles
    
    @inlinable func displayableStyle() -> Scheme.FormatStyle {
        Scheme.style(locale, precision: precision.displayableStyle(), separator: .automatic)
    }
        
    @inlinable func editableStyle() -> Scheme.FormatStyle {
        Scheme.style(locale, precision: precision.editableStyle(), separator: .automatic)
    }
    
    @inlinable func editableStyle(digits: NumberOfDigits, separator: Bool) -> Scheme.FormatStyle {
        Scheme.style(locale, precision: precision.editableStyle(digits), separator: separator ? .always : .automatic)
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
    
    @inlinable public func merge(_ current: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        let configuration = configuration()
                
        var input = NumericTextStyleInput(content, with: configuration)
        let toggleSignInstruction = input.consumeToggleSignInstruction()
                
        let next = current.replace(range, with: input.content)
                
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
        guard values.editableValidation(value) else { return nil }
        
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
    
    #warning("Snapshot needs a priority system like: case .diffable, .ignore.")
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        var snapshot = Snapshot()
            
        // --------------------------------- //
        
        #warning("Never diff prefix.")
        if let prefix = prefix {
            snapshot.append(contentsOf: Snapshot(prefix, only: .prefix))
            snapshot.append(.prefix(" "))
        }
        
        for character in characters {
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
        
        #warning("If decimal separator is last, don't diff it.")
        let decimalSeparatorAsSuffixStartIndex = snapshot.reversed()
            .prefix(while: { decimalSeparator.contains($0.character) }).endIndex.base
        if decimalSeparatorAsSuffixStartIndex < snapshot.endIndex {
            let replacement = snapshot[decimalSeparatorAsSuffixStartIndex...].map({ Symbol($0.character, attribute: [$0.attribute, .removable]) })
            snapshot.replaceSubrange(decimalSeparatorAsSuffixStartIndex..., with: replacement)
        }

        #warning("Never diff suffix.")
        if let suffix = suffix {
            snapshot.append(.suffix(" "))
            snapshot.append(contentsOf: Snapshot(suffix, only: .suffix))
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
    
    #warning("Double check, later.")
    @inlinable func components(_ snapshot: Snapshot, with configuration: Configuration) -> Components? {
        configuration.components(snapshot.characters(where: \.editable))
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
