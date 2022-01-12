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
        // MARK: Markers
        //=--------------------------------------=

        var interactableLHS: Snapshot.Index? = nil
        var interactableRHS = snapshot.startIndex
        var redundanceStart = snapshot.startIndex
        
        //=--------------------------------------=
        // MARK: Prefix
        //=--------------------------------------=
        
        if !prefix.isEmpty {
            snapshot.append(contentsOf: Snapshot(prefix, only: .prefix))
            snapshot.append(.prefix(" "))
        }

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
                interactableRHS = snapshot.endIndex
                
                zero_digit: if digit == .x0 {
                    redundanceStart = snapshot.endIndex
                    guard interactableLHS == nil else { break zero_digit }
                    interactableLHS = snapshot.endIndex
                }
                
            //=----------------------------------=
            // MARK: Separator
            //=----------------------------------=
                
            } else if let separator = region.separators[character] {
                switch separator {
                case .grouping:
                    snapshot.append(Symbol(character: character, attribute: .spacer))
                case .fraction:
                    redundanceStart = snapshot.endIndex
                    snapshot.append(Symbol(character: character, attribute: .content))
                    interactableRHS = snapshot.endIndex
                }
            
            //=----------------------------------=
            // MARK: Sign
            //=----------------------------------=
            
            } else if region.signs.keys.contains(character) {
                snapshot.append(Symbol(character: character, attribute: [.prefixing, .suffixing]))
                
            //=----------------------------------=
            // MARK: None Of The Above
            //=----------------------------------=
                
            } else {
                snapshot.append(Symbol(character: character, attribute: .spacer))
            }
        }
                
        //=--------------------------------------=
        // MARK: Interactable - LHS
        //=--------------------------------------=
        
        if let interactableLHS = interactableLHS {
            snapshot.transform(attributes: ..<interactableLHS) {
                attribute in
                attribute.insert(.prefixing)
            }
        }
        
        //=--------------------------------------=
        // MARK: Redundance - Start
        //=--------------------------------------=
        
        if redundanceStart != snapshot.startIndex {
            snapshot.transform(attributes: (redundanceStart)...) {
                attribute in
                attribute.insert(.removable)
            }
        }
        
        //=--------------------------------------=
        // MARK: Interactable - RHS
        //=--------------------------------------=
        
        snapshot.transform(attributes: interactableRHS...) {
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
        // MARK: Characters
        //=--------------------------------------=

        let style = editableStyle(number: number)
        let characters = style.format(value)
        
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

extension NumericTextStyle: UIKitSetupable {
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable public var keyboard: UIKeyboardType {
        Value.options.contains(.integer) ? .numberPad : .decimalPad
    }
}

#endif
