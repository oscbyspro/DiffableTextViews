//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import Utilities
import DiffableTextViews
import struct Foundation.Locale

// MARK: - NumericTextStyle

/// Formats numbers to and from user interactive text.
///
/// - Complexity: O(n) or less for all computations.
///
public struct NumericTextStyle<Value: NumericTextValue>: DiffableTextStyle, Transformable {
    public typealias Bounds = NumericTextStyles.Bounds<Value>
    public typealias Precision = NumericTextStyles.Precision<Value>
    @usableFromInline typealias Format = NumericTextStyles.Format<Value>

    // MARK: Properties
    
    @usableFromInline var format: Format
    @usableFromInline var prefix: String
    @usableFromInline var suffix: String
    
    // MARK: Initializers
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.format = Format(locale: locale)
        self.prefix = ""
        self.suffix = ""
    }
    
    // MARK: Transformations
    
    @inlinable public func locale(_ newValue: Locale) -> Self {
        transforming({ $0.format.update(locale: newValue) })
    }
    
    @inlinable public func bounds(_ newValue: Bounds) -> Self {
        transforming({ $0.format.update(bounds: newValue) })
    }
    
    @inlinable public func precision(_ newValue: Precision) -> Self {
        transforming({ $0.format.update(precision: newValue) })
    }
    
    @inlinable public func prefix(_ newValue: String?) -> Self {
        transforming({ $0.prefix = newValue ?? "" })
    }
    
    @inlinable public func suffix(_ newValue: String?) -> Self {
        transforming({ $0.suffix = newValue ?? "" })
    }
    
    // MARK: Value: Parse

    @inlinable public func parse(snapshot: Snapshot) throws -> Value {
        try value(number: number(snapshot: snapshot))
    }
    
    @inlinable func value(number: Number) throws -> Value {
        number.integer.isEmpty && number.fraction.isEmpty ? Value.zero : try Value.value(description: number.characters)
    }
    
    // MARK: Value: Process
    
    @inlinable public func process(value: inout Value) {
        format.bounds.clamp(&value)
    }
    
    // MARK: Snapshot: Number
        
    @inlinable func number(snapshot: Snapshot) throws -> Number {
        try format.parser.parse(snapshot.lazy.filter(\.nonformatting).map(\.character))
    }
    
    // MARK: Snapshot: Showcase
    
    @inlinable public func snapshot(showcase value: Value) -> Snapshot {
        snapshot(characters: format.showcaseStyle().format(value))
    }
    
    // MARK: Snapshot: Editable

    @inlinable public func snapshot(editable value: Value) -> Snapshot {
        snapshot(characters: format.editableStyle().format(value))
    }

    // MARK: Snapshot: Merge

    @inlinable public func merge(snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) throws -> Snapshot {
        var input = Input(content, parser: format.parser)
        let toggleSignCommand = input.consumeToggleSignCommand()
                
        // --------------------------------- //

        var number = try number(snapshot: snapshot.replacing(range, with: input.content))
        toggleSignCommand?.process(&number)
        
        // --------------------------------- //

        let capacity = try format.precision.capacity(count: number.digitsCount)
        
        // --------------------------------- //
        
        number.autocorrectSign(bounds: format.bounds)
        number.autocorrectSeparator(capacity: capacity)
        
        // --------------------------------- //
        
        let value = try value(number: number)
        try format.bounds.validate(contains: value)
                
        // --------------------------------- //
        
        let style = format.editableStyleThatUses(count: number.digitsCount, separator: !number.separator.isEmpty)
                
        // --------------------------------- //
        
        var characters = style.format(value)
        
        if !number.sign.isEmpty, !characters.hasPrefix(number.sign.characters) {
            characters = number.sign.characters + characters
        }
        
        // --------------------------------- //
    
        return self.snapshot(characters: characters)
    }
    
    // MARK: Snapshot: Characters
    
    @inlinable func snapshot(characters: String) -> Snapshot {
        var snapshot = Snapshot()
            
        // --------------------------------- //
        
        if !prefix.isEmpty {
            snapshot.append(contentsOf: Snapshot(prefix, only: .prefix))
            snapshot.append(.prefix(" "))
        }
                
        // --------------------------------- //
        
        for character in characters {
            if format.digits.contains(character) {
                snapshot.append(.content(character))
            } else if format.groupingSeparator.contains(character) {
                snapshot.append(.spacer(character))
            } else if format.fractionSeparator.contains(character) {
                snapshot.append(.content(character))
            } else if format.signs.keys.contains(character) {
                snapshot.append(.content(character).union(.prefixing))
            }
        }
        
        // --------------------------------- //

        processZeroFirstDigit(&snapshot) { attribute in
            attribute.insert(.prefixing)
        }
        
        processFractionSeparatorSuffix(&snapshot) { attribute in
            attribute.insert(.removable)
        }
                
        // --------------------------------- //

        if !suffix.isEmpty {
            snapshot.append(.suffix(" "))
            snapshot.append(contentsOf: Snapshot(suffix, only: .suffix))
        }
    
        // --------------------------------- //
                
        return snapshot
    }
    
    // MARK: Snapshot: Characters: Helpers
    
    @inlinable func processZeroFirstDigit(_ snapshot: inout Snapshot, transformation: (inout Attribute) -> Void) {
        func predicate(symbol: Symbol) -> Bool {
            format.digits.contains(symbol.character)
        }

        // --------------------------------- //
        
        guard let position = snapshot.firstIndex(where: predicate) else { return }
        guard snapshot[position].character == format.zero else { return }
        snapshot.transform(attributes: position, with: transformation)
    }
    
    @inlinable func processFractionSeparatorSuffix(_ snapshot: inout Snapshot, transformation: (inout Attribute) -> Void) {
        func predicate(symbol: Symbol) -> Bool {
            format.fractionSeparator.contains(symbol.character)
        }
        
        // --------------------------------- //
        
        snapshot.transform(attributes: snapshot.suffix(while: predicate).indices, with: transformation)
    }
}
