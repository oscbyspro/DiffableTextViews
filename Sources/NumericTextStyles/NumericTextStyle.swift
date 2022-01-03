//
//  NumericTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-19.
//

import DiffableTextViews
import Foundation
import Quick
import Utilities

//*============================================================================*
// MARK: * NumericTextStyle
//*============================================================================*

/// Formats numbers to and from user interactive text.
///
/// - Complexity: O(k · n) where k is some constant and n is the number of characters in the snapshot.
///               This is reasonably efficient considering that sequences are read in at least O(n) time.
///
public struct NumericTextStyle<Value: Valuable>: DiffableTextStyle {
    public typealias Bounds = NumericTextStyles.Bounds<Value>
    public typealias Precision = NumericTextStyles.Precision<Value>
    @usableFromInline typealias Format = NumericTextStyles.Format<Value>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var format: Format
    @usableFromInline var prefix: String
    @usableFromInline var suffix: String
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(locale: Locale = .autoupdatingCurrent) {
        self.format = Format(locale: locale)
        self.prefix = ""
        self.suffix = ""
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Update
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var result = self; result.format.update(locale: locale); return self
    }
    
    @inlinable public func bounds(_ bounds: Bounds) -> Self {
        var result = self; result.format.update(bounds: bounds); return self
    }
    
    @inlinable public func precision(_ precision: Precision) -> Self {
        var result = self; result.format.update(precision: precision); return self
    }
    
    @inlinable public func prefix(_ prefix: String?) -> Self {
        var result = self; result.prefix = prefix ?? ""; return result
    }
    
    @inlinable public func suffix(_ suffix: String?) -> Self {
        var result = self; result.suffix = suffix ?? ""; return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(showcase value: Value) -> Snapshot {
        snapshot(value: value, style: format.showcaseStyle())
    }
    
    @inlinable public func snapshot(editable value: Value) -> Snapshot {
        snapshot(value: value, style: format.editableStyle())
    }
    
    //
    // MARK: Snapshot - Value
    //=------------------------------------------------------------------------=
    
    @inlinable func snapshot(value: Value, style: Value.FormatStyle) -> Snapshot {
        snapshot(characters: style.format(value))
    }
    
    //
    // MARK: Snapshot - Characters
    //=------------------------------------------------------------------------=

    @inlinable func snapshot(characters: String) -> Snapshot {
        var index = characters.startIndex
        var snapshot = Snapshot()
                
        //=--------------------------------------=
        // MARK: Prefix
        //=--------------------------------------=
        
        snapshot_prefix: if !prefix.isEmpty {
            snapshot.append(contentsOf: Snapshot(prefix, only: .prefix))
            snapshot.append(.prefix(" "))
        }
        
        //=--------------------------------------=
        // MARK: Sign
        //=--------------------------------------=
        
        snapshot_sign: if index != characters.endIndex {
            let character = characters[index]
            var result = Sign()
            
            if let sign = format.signs[character] {
                result = sign
                characters.formIndex(after: &index)
            }
            
            format.correct(sign: &result)
            snapshot.append(contentsOf: Snapshot(result.characters, only: .prefixing))
        }
        
        //=--------------------------------------=
        // MARK: First Digit
        //=--------------------------------------=

        snapshot_first_digit: if index != characters.endIndex {
            let character = characters[index]
                        
            guard format.digits.contains(character) else { break snapshot_first_digit }
            characters.formIndex(after: &index)
            
            var symbol = Symbol(character, attribute: .content)
            symbol.attribute.insert(character == format.zero ? .prefixing : .content)
                        
            snapshot.append(symbol)
        }
        
        //=--------------------------------------=
        // MARK: Remainders
        //=--------------------------------------=
        
        snapshot_remainders: while index != characters.endIndex {
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
        
        //=--------------------------------------=
        // MARK: Redundance
        //=--------------------------------------=
        
        process_redundance: do {
            let redundance = snapshot.suffix { symbol in
                if format.zero == symbol.character { return true }
                if format.fractionSeparator.contains(symbol.character) { return true }
                return false
            }
            
            snapshot.transform(attributes: redundance.indices) { attribute in
                attribute.insert(.removable)
            }
        }
        
        //=--------------------------------------=
        // MARK: Suffix
        //=--------------------------------------=

        snapshot_suffix: if !suffix.isEmpty {
            snapshot.append(.suffix(" "))
            snapshot.append(contentsOf: Snapshot(suffix, only: .suffix))
        }

        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        
        return snapshot
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Merge
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) throws -> Snapshot {
        
        //=--------------------------------------=
        // MARK: Input
        //=--------------------------------------=
        
        var input = Input(content)
        
        parse_commands: do {
            input.consumeSignInput(with: format.parser.sign)
        }
        
        //=--------------------------------------=
        // MARK: Number
        //=--------------------------------------=
        
        var number = try number(snapshot: snapshot.replacing(range, with: input.content))
        
        execute_commands: do {
            input.process?(&number)
        }
        
        validate_number: do {
            try format.validate(sign: number.sign)
            let capacity = try format.precision.capacity(number: number)
            number.removeImpossibleSeparator(capacity: capacity)
        }
        
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        
        let value = try Value(number: number)
        
        validate_value: do {
            try format.validate(value: value)
        }
        
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        
        let style = format.editableStyleThatUses(number: number)
        
        //=--------------------------------------=
        // MARK: Characters
        //=--------------------------------------=
        
        var characters = style.format(value)
        
        insert_absent_sign: do {
            let sign = number.sign.characters
            if !sign.isEmpty, !characters.hasPrefix(sign) {
                /// occurs when sign is negative and value is zero
                characters = number.sign.characters + characters
            }
        }
        
        //=--------------------------------------=
        // MARK: Continue
        //=--------------------------------------=
                
        return self.snapshot(characters: characters)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Parse
    //=------------------------------------------------------------------------=

    @inlinable public func parse(snapshot: Snapshot) throws -> Value {
        try Value(number: number(snapshot: snapshot))
    }
    
    @inlinable func number(snapshot: Snapshot) throws -> Number {
        let unformatted = snapshot.lazy.filter(Symbol.is(non: .formatting)).map(\.character)
                
        guard let number = format.parser.parse(unformatted) else {
            throw Redacted.text("unable to parse number in").mark(snapshot.characters)
        }
                
        return number
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Process
    //=------------------------------------------------------------------------=

    @inlinable public func process(value: inout Value) {
        format.bounds.clamp(&value)
    }
}
