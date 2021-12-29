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
        try value(number: number(snapshot: snapshot))
    }
    
    #warning("Integer is never empty.")
    #warning("Can use: 'try .make(description: number.characters)' only.")
    @inlinable func value(number: Number) throws -> Value {
        number.integer.isEmpty && number.fraction.isEmpty ? .zero : try .make(description: number.characters)
    }
        
    @inlinable func number(snapshot: Snapshot) throws -> Number {
        let unformatted = snapshot.lazy.filter(Symbol.is(non: .formatting)).map(\.character)
                
        guard let number = format.parser.parse(unformatted) else {
            throw .reason("unable to parse number in", snapshot.characters)
        }
                
        return number
    }

    // MARK: Merge

    @inlinable public func merge(snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) throws -> Snapshot {
        var input = Input(content)
        let signInput = input.consumeSignInput(with: format.parser.sign)
                
        // --------------------------------- //

        var number = try number(snapshot: snapshot.replacing(range, with: input.content))
        
        // --------------------------------- //
        
        signInput?.process(&number)
        try format.validate(sign: number.sign)
        
        // --------------------------------- //

        let capacity = try format.precision.capacity(number: number)
        number.removeImpossibleSeparator(capacity: capacity)
        
        // --------------------------------- //
        
        let value = try value(number: number)
        try format.validate(value: value)
        
        // --------------------------------- //
        
        let style = format.editableStyleThatUses(number: number)
        
        var characters = style.format(value)
        
        if !characters.hasPrefix(number.sign.characters) {
            characters = number.sign.characters + characters
        }
        
        // --------------------------------- //
    
        return self.snapshot(characters: characters)
    }
    
    // MARK: Characters
    
    @inlinable func snapshot(characters: String) -> Snapshot {
        var snapshot = Snapshot()
        var index = characters.startIndex
        
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
            var sign = Sign()
            let character = characters[index]
            
            if let value = format.signs[character] {
                sign = value
                characters.formIndex(after: &index)
            }
                    
            format.correct(sign: &sign)
            let value = Snapshot(sign.characters, only: .prefixing)
            
            snapshot.append(contentsOf: value)
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
        // MARK: Body
        // --------------------------------- //
        
        BODY: while index != characters.endIndex {
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
        // MARK: Process Redundant Tail
        // --------------------------------- //
        
        PROCESS_REDUNDANT_TAIL: do {
            let redundantTail = snapshot.suffix { symbol in
                if format.zero == symbol.character { return true }
                if format.fractionSeparator.contains(symbol.character) { return true }
                return false
            }
            
            snapshot.transform(attributes: redundantTail.indices) { attribute in
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
