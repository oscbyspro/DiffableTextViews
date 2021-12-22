//
//  NumberTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import DiffableTextViews
import struct Foundation.Locale
import protocol Utilities.Transformable

// MARK: - NumberTextStyle

/// Formats numbers to and from user interactive text.
///
/// - Complexity: O(n) or less for all computations.
///
public struct NumberTextStyle<Value: NumberTextValue>: DiffableTextStyle, Transformable {
    public typealias Parser = Value.NumberParser
    public typealias Bounds = NumericTextStyles.NumberTextBounds<Value>
    public typealias Precision = NumericTextStyles.NumberTextPrecision<Value>

    // MARK: Properties
    
    @usableFromInline var locale: Locale
    @usableFromInline var prefix: String = ""
    @usableFromInline var suffix: String = ""
    @usableFromInline var bounds: Bounds = .max
    @usableFromInline var precision: Precision = .max
    
    // MARK: Initializers
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.locale = locale
    }
    
    // MARK: Getters
    
    @inlinable @inline(__always) var parser: Parser {
        .standard.locale(locale)
    }
        
    @inlinable var zero: Character {
        DigitsText.zero
    }
    
    @inlinable var digits: Set<Character> {
        DigitsText.decimals
    }
    
    @inlinable var signs: Set<Character> {
        SignText.all
    }
    
    @inlinable var fractionSeparator: String {
        locale.decimalSeparator ?? SeparatorText.dot
    }

    @inlinable var groupingSeparator: String {
        locale.groupingSeparator ?? ""
    }
    
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
    
    // MARK: Helpers
    
    @inlinable func number(snapshot: Snapshot) -> NumberText? {
        parser.parse(characters: snapshot.lazy.compactMap({ $0.nonformatting ? $0.character : nil }))        
    }
}

// MARK: - Styles

extension NumberTextStyle {
    
    // MARK: Showcase
    
    @inlinable func showcaseStyle() -> Value.FormatStyle {
        Value.style(locale: locale, precision: precision.showcaseStyle(), separator: .automatic)
    }
    
    // MARK: Editable
    
    @inlinable func editableStyle() -> Value.FormatStyle {
        Value.style(locale: locale, precision: precision.editableStyle(), separator: .automatic)
    }
    
    @inlinable func editableStyle(count: Count, separator: Bool) -> Value.FormatStyle {
        Value.style(locale: locale, precision: precision.editableStyle(count: count), separator: separator ? .always : .automatic)
    }
}

// MARK: - Value

extension NumberTextStyle {
    
    // MARK: Process
    
    @inlinable public func process(value: inout Value) {
        value = bounds.bounded(value)
    }
        
    // MARK: Parse

    @inlinable public func parse(snapshot: Snapshot) -> Value? {
        number(snapshot: snapshot).flatMap(value)
    }
    
    // MARK: Components
    
    @inlinable func value(number: NumberText) -> Value? {
        number.integer.isEmpty && number.fraction.isEmpty ? Value.zero : Value.value(description: number.characters)
    }
}

// MARK: - Snapshot

extension NumberTextStyle {
    
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

extension NumberTextStyle {
    
    // MARK: Merge

    @inlinable public func merge(snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) -> Snapshot? {
        var input = Input(content, parser: parser)
        let toggleSignInput = input.consumeToggleSignInput()
        
        // --------------------------------- //
        
        var next = snapshot
        next.replaceSubrange(range, with: input.content)
        
        // --------------------------------- //

        guard var number = number(snapshot: next) else { return nil }
        toggleSignInput?.process(&number)
        
        // --------------------------------- //

        return self.snapshot(number: &number)
    }
    
    // MARK: Number
    
    @inlinable func snapshot(number: inout NumberText) -> Snapshot? {
        let count = number.numberOfSignificantDigits()
        guard let capacity = precision.editableValidationThatGeneratesCapacity(count: count) else { return nil }
        
        // --------------------------------- //
        
        if capacity.fraction == .zero, number.fraction.isEmpty {
            number.separator.removeAll()
        }
        
        // --------------------------------- //
        
        guard let value = value(number: number) else { return nil }
        guard bounds.contains(value) else { return nil }
        
        // --------------------------------- //
        
        let style = editableStyle(count: count, separator: !number.separator.isEmpty)
                
        // --------------------------------- //
        
        var characters = style.format(value)
        
        if !number.sign.isEmpty, !characters.hasPrefix(number.sign.characters) {
            characters = number.sign.characters + characters
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
            } else if fractionSeparator.contains(character) {
                snapshot.append(.content(character))
            } else if signs.contains(character) {
                snapshot.append(.content(character).union(.prefixing))
            }
        }
        
        // --------------------------------- //

        transformFirstDigitIfItIsZero(in:          &snapshot, using: { $0.insert(.prefixing) })
        transformFractionSeparatorIfItIsSuffix(in: &snapshot, using: { $0.insert(.removable) })
                
        // --------------------------------- //

        if !suffix.isEmpty {
            snapshot.append(.suffix(" "))
            snapshot.append(contentsOf: Snapshot(suffix, only: .suffix))
        }
    
        // --------------------------------- //
                
        return snapshot
    }
    
    // MARK: Characters, Helpers
    
    @inlinable func transformFirstDigitIfItIsZero(in snapshot: inout Snapshot, using transformation: (inout Attribute) -> Void) {
        func digit(symbol: Symbol) -> Bool {
            digits.contains(symbol.character)
        }
        
        // --------------------------------- //
        
        guard let position = snapshot.firstIndex(where: digit) else { return }
        guard snapshot[position].character == zero else { return }
        
        // --------------------------------- //
        
        snapshot.transform(attributes: position, using: transformation)
    }
    
    @inlinable func transformFractionSeparatorIfItIsSuffix(in snapshot: inout Snapshot, using transformation: (inout Attribute) -> Void) {
        func predicate(symbol: Symbol) -> Bool {
            fractionSeparator.contains(symbol.character)
        }
        
        // --------------------------------- //
        
        let start = snapshot
            .reversed()
            .prefix(while: predicate)
            .endIndex.base
        
        // --------------------------------- //
        
        snapshot.transform(attributes: start..., using: transformation)
    }
}
