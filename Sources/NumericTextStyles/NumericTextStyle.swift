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
        self.format = Format(region: .reusable(locale))
        self.prefix = ""
        self.suffix = ""
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        map({ $0.format.region = .reusable(locale) })
    }
    
    @inlinable public func bounds(_ bounds: Bounds) -> Self {
        map({ $0.format.bounds = bounds })
    }
    
    @inlinable public func precision(_ precision: Precision) -> Self {
        map({ $0.format.precision = precision })
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
    // MARK: Showcase
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(showcase value: Value) -> Snapshot {
        snapshot(characters: format.showcaseStyle().format(value))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Editable
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(editable value: Value) -> Snapshot {
        snapshot(characters: format.editableStyle().format(value))
    }

    //=------------------------------------------------------------------------=
    // MARK: Characters
    //=------------------------------------------------------------------------=

    /// Snapshots characters.
    ///
    /// - Assumes: that there is at least one integer digit.
    /// - Assumes: that there is at most one prefix integer digit zero.
    ///
    @inlinable func snapshot(characters: String) -> Snapshot {
        var snapshot = Snapshot()
        var index = characters.startIndex
        
        //=--------------------------------------=
        // MARK: Prefix
        //=--------------------------------------=
        
        #warning("Remove when currency is implemented.")
        if !prefix.isEmpty {
            snapshot.append(contentsOf: Snapshot(prefix, only: .prefix))
            snapshot.append(.prefix(" "))
        }
        
        //=--------------------------------------=
        // MARK: Through First Digit
        //=--------------------------------------=
        
        through_first_digit: while index != characters.endIndex {
            let character = characters[  index]
            characters.formIndex(after: &index)
                        
            if let digit = format.region.digits[character] {
                let attribute: Attribute = digit.isZero ? .prefixing : .content
                snapshot.append(Symbol(character: character, attribute: attribute))
                break through_first_digit
            } else if format.region.signs.keys.contains(character) {
                snapshot.append(Symbol(character: character, attribute: .prefixing))
            } else {
                snapshot.append(.prefix(character))
            }
        }
        
        //=--------------------------------------=
        // MARK: Body
        //=--------------------------------------=
        
        while index != characters.endIndex {
            let character = characters[  index]
            characters.formIndex(after: &index)
            
            if format.region.digits.keys.contains(character) {
                snapshot.append(.content(character))
            } else if format.region.groupingSeparator == character {
                snapshot.append(.spacer(character))
            } else if format.region.fractionSeparator == character {
                snapshot.append(.content(character))
            } else if format.region.signs.keys.contains(character) {
                snapshot.append(Symbol(character: character, attribute: .prefixing))
            } else {
                snapshot.append(.spacer(character))
            }
        }
        
        //=--------------------------------------=
        // MARK: Redundance
        //=--------------------------------------=
        
        snapshot.transform(attributes: snapshot.suffix { symbol in
            if format.region.zero == symbol.character { return true }
            if format.region.fractionSeparator == symbol.character { return true }
            return false }.indices) { attribute in  attribute.insert(.removable) }
        
        //=--------------------------------------=
        // MARK: Suffix
        //=--------------------------------------=

        #warning("Remove when currency is implemented.")
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
    // MARK: Input
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(snapshot: Snapshot, with input: Input) throws -> Snapshot {

        //=--------------------------------------=
        // MARK: Reader
        //=--------------------------------------=

        var reader = Reader(input.content)
        reader.consumeSignInput(region: format.region)

        //=--------------------------------------=
        // MARK: Proposal
        //=--------------------------------------=

        var proposal = snapshot
        proposal.replaceSubrange(input.range, with: reader.content)

        //=--------------------------------------=
        // MARK: Number
        //=--------------------------------------=

        var number = try number(snapshot: proposal)
        reader.process?(&number)

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
        
        correct_zero_sign: if value == .zero, number.sign == .negative {
            guard let index = characters.firstIndex(where: \.isNumber) else { break correct_zero_sign }
            
            var result = ""
            result.append(contentsOf: characters[..<index])
            result.append(contentsOf: format.region.localized(sign: number.sign))
            result.append(contentsOf: characters[index...])
            characters = result
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
        try Number(snapshot, with: Value.options, in: format.region)
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

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import UIKit

extension NumericTextStyle: UIKitDiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable public var keyboard: UIKeyboardType {
        Value.options.contains(.integer) ? .numberPad : .decimalPad
    }
}

#endif
