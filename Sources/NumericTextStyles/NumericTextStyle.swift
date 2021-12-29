//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import Foundation
import DiffableTextViews
import Utilities

// MARK: - NumericTextStyle

/// Formats numbers to and from user interactive text.
///
/// - Complexity: O(k · n) where k is some constant and n is the number of characters in the snapshot.
///               This is reasonably efficient considering that sequences are read in at least O(n) time.
///
public struct NumericTextStyle<Value: Valuable>: DiffableTextStyle, Transformable {
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
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        transforming({ $0.format.update(locale: locale) })
    }
    
    @inlinable public func bounds(_ bounds: Bounds) -> Self {
        transforming({ $0.format.update(bounds: bounds) })
    }
    
    @inlinable public func precision(_ precision: Precision) -> Self {
        transforming({ $0.format.update(precision: precision) })
    }
    
    @inlinable public func prefix(_ prefix: String?) -> Self {
        transforming({ $0.prefix = prefix ?? "" })
    }
    
    @inlinable public func suffix(_ suffix: String?) -> Self {
        transforming({ $0.suffix = suffix ?? "" })
    }
    
    // MARK: Snapshot
    
    @inlinable public func snapshot(showcase value: Value) -> Snapshot {
        snapshot(value: value, style: format.showcaseStyle())
    }
    
    @inlinable public func snapshot(editable value: Value) -> Snapshot {
        snapshot(value: value, style: format.editableStyle())
    }
    
    @inlinable func snapshot(value: Value, style: Value.FormatStyle) -> Snapshot {
        snapshot(characters: style.format(value))
    }
    
    // MARK: Process
    
    @inlinable public func process(value: inout Value) {
        format.bounds.clamp(&value)
    }
    
    // MARK: Parse

    @inlinable public func parse(snapshot: Snapshot) throws -> Value {
        try Value(number: number(snapshot: snapshot))
    }
    
    @inlinable func number(snapshot: Snapshot) throws -> Number {
        let unformatted = snapshot.lazy.filter(Symbol.is(non: .formatting)).map(\.character)
                
        guard let number = format.parser.parse(unformatted) else {
            throw Autoredactable("unable to parse number in", [snapshot.characters])
        }
                
        return number
    }

    // MARK: Merge

    @inlinable public func merge(snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) throws -> Snapshot {
        
        // --------------------------------- //
        // MARK: Input
        // --------------------------------- //
        
        var input = Input(content)
        
        PARSE_COMMANDS: do {
            input.consumeSignInput(with: format.parser.sign)
        }
        
        // --------------------------------- //
        // MARK: Number
        // --------------------------------- //
        
        var number = try number(snapshot: snapshot.replacing(range, with: input.content))
        
        EXECUTE_COMMANDS: do {
            input.process?(&number)
        }
        
        VALIDATE_NUMBER: do {
            try format.validate(sign: number.sign)
            let capacity = try format.precision.capacity(number: number)
            number.removeImpossibleSeparator(capacity: capacity)
        }
        
        // --------------------------------- //
        // MARK: Value
        // --------------------------------- //
        
        let value = try Value(number: number)
        
        VALIDATE_VALUE: do {
            try format.validate(value: value)
        }
        
        // --------------------------------- //
        // MARK: Style
        // --------------------------------- //
        
        let style = format.editableStyleThatUses(number: number)
        
        // --------------------------------- //
        // MARK: Characters
        // --------------------------------- //
        
        var characters = style.format(value)
        
        CORRECT_CHARACTERS_SIGN: do {
            let sign = number.sign.characters
            
            if !sign.isEmpty, !characters.hasPrefix(sign) {
                /// occurs when sign is negative and value is zero
                characters = number.sign.characters + characters
            }
        }
        
        // --------------------------------- //
        // MARK: Continue
        // --------------------------------- //
                
        return self.snapshot(characters: characters)
    }
    
    // MARK: Characters
    
    @inlinable func snapshot(characters: String) -> Snapshot {
        var index = characters.startIndex
        var snapshot = Snapshot()
        
        // --------------------------------- //
        // MARK: Prefix
        // --------------------------------- //
        
        PREFIX: if !prefix.isEmpty {
            snapshot.append(contentsOf: Snapshot(prefix, only: .prefix))
            snapshot.append(.prefix(" "))
        }
        
        // --------------------------------- //
        // MARK: Sign
        // --------------------------------- //
        
        SIGN: if index != characters.endIndex {
            let character = characters[index]
            var result = Sign()
            
            if let sign = format.signs[character] {
                result = sign
                characters.formIndex(after: &index)
            }
            
            format.correct(sign: &result)
            snapshot.append(contentsOf: Snapshot(result.characters, only: .prefixing))
        }
        
        // --------------------------------- //
        // MARK: First Digit
        // --------------------------------- //

        FIRST_DIGIT: if index != characters.endIndex {
            let character = characters[index]
            
            guard format.digits.contains(character) else { break FIRST_DIGIT }
            characters.formIndex(after: &index)
            
            var symbol = Symbol(character, attribute: .content)
            symbol.attribute.insert(character == format.zero ? .prefixing : .content)
                        
            snapshot.append(symbol)
        }
        
        // --------------------------------- //
        // MARK: Remainders
        // --------------------------------- //
        
        REMAINDERS: while index != characters.endIndex {
            let character = characters[index]
            
            if format.digits.contains(character) {
                snapshot.append(.content(character))
            } else if format.groupingSeparator.contains(character) {
                snapshot.append(.spacer(character))
            } else if format.fractionSeparator.contains(character) {
                snapshot.append(.content(character))
            }
            
            characters.formIndex(after: &index)
        }
        
        // --------------------------------- //
        // MARK: Process Redundance
        // --------------------------------- //
        
        PROCESS_REDUNDANCE: do {
            let redundance = snapshot.suffix { symbol in
                if format.zero == symbol.character { return true }
                if format.fractionSeparator.contains(symbol.character) { return true }
                return false
            }
            
            snapshot.transform(attributes: redundance.indices) { attribute in
                attribute.insert(.removable)
            }
        }
        
        // --------------------------------- //
        // MARK: Suffix
        // --------------------------------- //

        SUFFIX: if !suffix.isEmpty {
            snapshot.append(.suffix(" "))
            snapshot.append(contentsOf: Snapshot(suffix, only: .suffix))
        }
    
        // --------------------------------- //
        // MARK: Return
        // --------------------------------- //
        
        return snapshot
    }
}
