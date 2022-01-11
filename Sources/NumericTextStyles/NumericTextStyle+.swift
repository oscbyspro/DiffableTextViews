//
//  NumericTextStyle+.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

import DiffableTextViews

//=----------------------------------------------------------------------------=
// MARK: NumericTextStyle - Snapshot
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Showcase
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(showcase value: Value) -> Snapshot {
        snapshot(characters: showcaseStyle().format(value))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Editable
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(editable value: Value) -> Snapshot {
        snapshot(characters: editableStyle().format(value))
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
                        
            if let digit = region.digits[character] {
                let attribute: Attribute = digit.isZero ? .prefixing : .content
                snapshot.append(Symbol(character: character, attribute: attribute))
                break through_first_digit
            } else if region.signs.keys.contains(character) {
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
            
            if region.digits.keys.contains(character) {
                snapshot.append(.content(character))
            } else if region.groupingSeparator == character {
                snapshot.append(.spacer(character))
            } else if region.fractionSeparator == character {
                snapshot.append(.content(character))
            } else if region.signs.keys.contains(character) {
                snapshot.append(Symbol(character: character, attribute: .prefixing))
            } else {
                snapshot.append(.spacer(character))
            }
        }
        
        //=--------------------------------------=
        // MARK: Redundance
        //=--------------------------------------=
        
        snapshot.transform(attributes: snapshot.suffix { symbol in
            if region.zero == symbol.character { return true }
            if region.fractionSeparator == symbol.character { return true }
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
        reader.consumeSignInput(region: region)

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
        
        try bounds.validate(sign: number.sign)
        let capacity = try precision.capacity(number: number)
        number.removeImpossibleSeparator(capacity: capacity)

        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=

        let value = try Value(number: number)
        try bounds.validate(value: value)

        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        
        let style = editableStyleThatUses(number: number)

        //=--------------------------------------=
        // MARK: Characters
        //=--------------------------------------=

        let characters = style.format(value)

        //
        // MARK: Characters - Correct
        //=--------------------------------------=
        
        #warning("This is invalid.")
//        correct_zero_sign: if value == .zero, number.sign == .negative {
//            guard let index = characters.firstIndex(where: \.isNumber) else { break correct_zero_sign }
//
//            var result = ""
//            result.append(contentsOf: characters[..<index])
//            result.append(contentsOf: region.localized(sign: number.sign))
//            result.append(contentsOf: characters[index...])
//            characters = result
//        }
        
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
        try Number(snapshot, with: Value.options, in: region)
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
        bounds.clamp(&value)
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
