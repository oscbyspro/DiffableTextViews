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
///
public struct NumericTextStyle<Value: Valuable>: DiffableTextStyle, Mappable {
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
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        map({ $0.format.update(locale: locale) })
    }
    
    @inlinable public func bounds(_ bounds: Bounds) -> Self {
        map({ $0.format.update(bounds: bounds) })
    }
    
    @inlinable public func precision(_ precision: Precision) -> Self {
        map({ $0.format.update(precision: precision) })
    }
    
    @inlinable public func prefix(_ prefix: String?) -> Self {
        map({ $0.prefix = prefix ?? "" })
    }
    
    @inlinable public func suffix(_ suffix: String?) -> Self {
        map({ $0.suffix = suffix ?? "" })
    }
}

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - Snapshot
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Mode
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(showcase value: Value) -> Snapshot {
        snapshot(value: value, style: format.showcaseStyle())
    }
    
    @inlinable public func snapshot(editable value: Value) -> Snapshot {
        snapshot(value: value, style: format.editableStyle())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable func snapshot(value: Value, style: Value.FormatStyle) -> Snapshot {
        snapshot(characters: style.format(value))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=

    @inlinable func snapshot(characters: String) -> Snapshot {
        var index = characters.startIndex
        var snapshot = Snapshot()
                
        //=--------------------------------------=
        // MARK: Prefix
        //=--------------------------------------=
        
        if !prefix.isEmpty {
            snapshot.append(contentsOf: Snapshot(prefix, only: .prefix))
            snapshot.append(.prefix(" "))
        }
        
        //=--------------------------------------=
        // MARK: Sign
        //=--------------------------------------=
        
        if index != characters.endIndex {
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
            
            var symbol = Symbol(character: character, attribute: .content)
            symbol.attribute.insert(character == format.zero ? .prefixing : .content)
                        
            snapshot.append(symbol)
        }
        
        //=--------------------------------------=
        // MARK: Remainders
        //=--------------------------------------=
        
        while index != characters.endIndex {
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
        
        snapshot.transform(attributes: snapshot.suffix { symbol in
            if format.zero == symbol.character { return true }
            if format.fractionSeparator.contains(symbol.character) { return true }
            return false }.indices) { attribute in  attribute.insert(.removable) }

        //=--------------------------------------=
        // MARK: Suffix
        //=--------------------------------------=

        if !suffix.isEmpty {
            snapshot.append(.suffix(" "))
            snapshot.append(contentsOf: Snapshot(suffix, only: .suffix))
        }

        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        
        return snapshot
    }
}

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - Merge
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Implementation
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) throws -> Snapshot {
        
        //=--------------------------------------=
        // MARK: Input
        //=--------------------------------------=
        
        var input = Input(content)
        
        //
        // MARK: Input - Parse Commands
        //=--------------------------------------=
        
        input.consumeSignInput(with: format.parser.sign)
        
        //=--------------------------------------=
        // MARK: Proposal
        //=--------------------------------------=
        
        var proposal = snapshot
        proposal.replaceSubrange(range, with: input.content)
        
        //=--------------------------------------=
        // MARK: Number
        //=--------------------------------------=
        
        var number = try number(snapshot: proposal)
        
        //
        // MARK: Number - Run Input Commands
        //=--------------------------------------=
        
        input.process?(&number)
        
        //
        // MARK: Number - Validation & Capacity
        //=--------------------------------------=
        
        try format.validate(sign: number.sign)
        let capacity = try format.precision.capacity(number: number)
        number.removeImpossibleSeparator(capacity: capacity)
        
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        
        let value = try Value(number: number)
        
        //
        // MARK: Value - Validation
        //=--------------------------------------=
        
        try format.validate(value: value)
        
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        
        let style = format.editableStyleThatUses(number: number)
        
        //=--------------------------------------=
        // MARK: Characters
        //=--------------------------------------=
        
        var characters = style.format(value)
        
        //
        // MARK: Characters - Correct
        //=--------------------------------------=
        
        let sign = number.sign.characters
        /// insert absent sign when sign is negative and value is zero
        if !sign.isEmpty, !characters.hasPrefix(sign) {
            characters = number.sign.characters + characters
        }
        
        //=--------------------------------------=
        // MARK: Continue
        //=--------------------------------------=
                
        return self.snapshot(characters: characters)
    }
}

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - Parse
//=----------------------------------------------------------------------------=

extension NumericTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Snapshot as Value
    //=------------------------------------------------------------------------=

    @inlinable public func parse(snapshot: Snapshot) throws -> Value {
        try Value(number: number(snapshot: snapshot))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot as Number
    //=------------------------------------------------------------------------=
    
    @inlinable func number(snapshot: Snapshot) throws -> Number {
        let unformatted = snapshot.lazy
            .filter({ !$0.attribute.contains(.formatting) })
            .map(\.character)
                
        guard let number = format.parser.parse(unformatted) else {
            throw Info(["unable to parse number in", .mark(snapshot.characters)])
        }
                
        return number
    }
}

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - Process
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=

    @inlinable public func process(value: inout Value) {
        format.bounds.clamp(&value)
    }
}
