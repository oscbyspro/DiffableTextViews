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

    /// A snapshot of characters.
    ///
    /// - Assumes that characters contains at least one content character.
    ///
    @inlinable func snapshot(characters: String) -> Snapshot {
        var snapshot = Snapshot()
        //=--------------------------------------=
        // MARK: Prefix
        //=--------------------------------------=
        if !prefix.isEmpty {
            snapshot.append(contentsOf: Snapshot(prefix, as: .phantom))
            snapshot.append(.spacer)
        }
        //=--------------------------------------=
        // MARK: Body
        //=--------------------------------------=
        for character in characters {
            if let _ = region.digits[character] {
                snapshot.append(Symbol(character, as: .content))
            } else if let separator = region.separators[character], separator == .fraction {
                snapshot.append(Symbol(character, as: .removable))
            } else if let _ = region.signs[character] {
                snapshot.append(Symbol(character, as: .phantom.subtracting(.formatting)))
            } else {
                snapshot.append(Symbol(character, as: .phantom))
            }
        }
        //=--------------------------------------=
        // MARK: Suffix
        //=--------------------------------------=
        if !suffix.isEmpty {
            snapshot.append(.spacer)
            snapshot.append(contentsOf: Snapshot(suffix, as: .phantom))
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
                
        try bounds.validate(sign: number.sign)
        let capacity = try precision.capacity(number: number)
        number.removeImpossibleSeparator(capacity: capacity)
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        let formatted = number.characters(in: region)
        let value = try format.parseStrategy.parse(formatted)
        try bounds.validate(value: value)
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        let style = editableStyle(number: number)
        //=--------------------------------------=
        // MARK: Characters
        //=--------------------------------------=
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
        let number = try number(snapshot: snapshot)
        let characters = number.characters(in: region)
        return try format.parseStrategy.parse(characters)
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Snapshot As Number
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

extension NumericTextStyle: UIKitTextStyle {    
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable public func setup(textField: ProxyTextField) {
        textField.keyboard(Value.options.contains(.integer) ? .numberPad : .decimalPad)
    }
}

#endif
