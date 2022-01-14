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

    #warning("Rework ")
    /// Snapshots characters.
    ///
    /// - Assumes: that there is at least one integer digit.
    /// - Assumes: that there is at most one prefix integer digit zero.
    ///
    @inlinable func snapshot(characters: String) -> Snapshot {
        var snapshot = Snapshot()
        var index = characters.startIndex
        //=--------------------------------------=
        // MARK: Markers
        //=--------------------------------------=
        var interactableStart = Snapshot.Index?(nil)
        var interactableEnd   = snapshot.startIndex
        var redundanciesStart = snapshot.startIndex
        //=--------------------------------------=
        // MARK: Prefix
        //=--------------------------------------=
        if !prefix.isEmpty {
            snapshot.append(contentsOf: Snapshot(prefix, only: .prefix))
            snapshot.append(.prefix(" "))
        }

        #warning("Up to first digit")
        #warning("Remove interactable start.")
        
        //=--------------------------------------=
        // MARK: Body
        //=--------------------------------------=
        while index != characters.endIndex {
            let character = characters[  index]
            characters.formIndex(after: &index)
            //=----------------------------------=
            // MARK: Digit
            //=----------------------------------=
            if let digit = region.digits[character] {
                snapshot.append(Symbol(character: character, attribute: .content))
                interactableEnd = snapshot.endIndex

                if digit == .zero {
                    redundanciesStart = snapshot.endIndex
                    if interactableStart == nil {
                        interactableStart = snapshot.endIndex
                    }
                }
            //=----------------------------------=
            // MARK: Separator
            //=----------------------------------=
            } else if let separator = region.separators[character] {
                switch separator {
                case .grouping:
                    snapshot.append(Symbol(character: character, attribute: .spacer))
                case .fraction:
                    redundanciesStart = snapshot.endIndex
                    snapshot.append(Symbol(character: character, attribute: .content))
                    interactableEnd = snapshot.endIndex
                }
            
            //=----------------------------------=
            // MARK: Sign
            //=----------------------------------=
            } else if let _ = region.signs[character] {
                snapshot.append(Symbol(character: character, attribute: [.prefixing, .suffixing]))
            //=----------------------------------=
            // MARK: None Of The Above
            //=----------------------------------=
            } else {
                snapshot.append(Symbol(character: character, attribute: .spacer))
            }
        }
        //=--------------------------------------=
        // MARK: Interactable - Start
        //=--------------------------------------=
        if let interactableStart = interactableStart {
            snapshot.transform(attributes: ..<interactableStart) {
                attribute in
                attribute.insert(.prefixing)
            }
        }
        //=--------------------------------------=
        // MARK: Redundancies - Start
        //=--------------------------------------=
        if redundanciesStart != snapshot.startIndex {
            snapshot.transform(attributes: redundanciesStart...) {
                attribute in
                attribute.insert(.removable)
            }
        }
        //=--------------------------------------=
        // MARK: Interactable - End
        //=--------------------------------------=
        snapshot.transform(attributes: interactableEnd...) {
            attribute in
            attribute = .suffix
        }
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

extension NumericTextStyle: UIKitCompatibleStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable public var keyboard: UIKeyboardType {
        Value.options.contains(.integer) ? .numberPad : .decimalPad
    }
}

#endif
