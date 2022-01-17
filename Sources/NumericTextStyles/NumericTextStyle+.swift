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

    /// Assumes that characters contains at least one content character.
    @inlinable func snapshot(characters: String) -> Snapshot {
        characters.reduce(into: Snapshot()) { snapshot, character in
            if let _ = region.digits[character] {
                snapshot.append(Symbol(character, as: .content))
            } else if let separator = region.separators[character] {
                snapshot.append(Symbol(character, as: separator == .fraction ? .removable : .phantom))
            } else if let _ = region.signs[character] {
                snapshot.append(Symbol(character, as: .phantom.subtracting(.virtual)))
            } else {
                snapshot.append(Symbol(character, as: .phantom))
            }
        }
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
        // MARK: Reader, Proposal
        //=--------------------------------------=
        var reader = Reader(input.content)
        reader.consumeSignInput(region: region)

        var proposal = snapshot
        proposal.replaceSubrange(input.range, with: reader.content)
        //=--------------------------------------=
        // MARK: Number
        //=--------------------------------------=
        var number = try region.parse(proposal, as: Value.self)
        reader.process?(&number)
        try bounds.validate(sign: number.sign)
        //=--------------------------------------=
        // MARK: Count, Capacity
        //=--------------------------------------=
        var count = number.count()
        format.process(count: &count)

        let capacity = try precision.capacity(count: count)
        number.removeImpossibleSeparator(capacity: capacity)
        //=--------------------------------------=
        // MARK: Corrected, Value
        //=--------------------------------------=
        let corrected = region.characters(number)
        let value = try parser.parse(corrected)
        try bounds.validate(value: value)
        //=--------------------------------------=
        // MARK: Style, Characters
        //=--------------------------------------=
        let style = editableStyle(number: number)

        var characters = style.format(value)
        autocorrectSign(in: &characters, with: value, and: number.sign)
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
    // MARK: Snapshot As Value
    //=------------------------------------------------------------------------=

    @inlinable public func parse(snapshot: Snapshot) throws -> Value {
        try parser.parse(snapshot.characters)
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

extension NumericTextStyle: UIKitTextStyle {    
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable public func setup(diffableTextField: ProxyTextField) {
        diffableTextField.keyboard(Value.isInteger ? .numberPad : .decimalPad)
    }
}

#endif
