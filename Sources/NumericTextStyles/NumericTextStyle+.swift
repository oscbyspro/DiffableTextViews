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
        
        var interactableStartIndex: Snapshot.Index? = nil
        var interactableEndIndex = snapshot.startIndex
        var redundanceStartIndex = snapshot.startIndex
        
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
            
            if let digit = region.digits[character] {
                snapshot.append(.content(character))
                interactableEndIndex = snapshot.endIndex
                
                if !digit.isZero {
                    redundanceStartIndex = snapshot.endIndex
                } else if interactableStartIndex == nil {
                    interactableStartIndex = snapshot.endIndex
                }
                
            } else if region.groupingSeparator == character {
                snapshot.append(Symbol(character: character, attribute: .spacer))
            } else if region.fractionSeparator == character {
                snapshot.append(Symbol(character: character, attribute: .content))
                interactableEndIndex = snapshot.endIndex
            } else if region.signs.keys.contains(character) {
                snapshot.append(Symbol(character: character, attribute: .prefixing))
            } else {
                snapshot.append(Symbol(character: character, attribute: .spacer))
            }
        }
        
        //=--------------------------------------=
        // MARK: Attributes
        //=--------------------------------------=
        
        if let interactableStartIndex = interactableStartIndex {
            snapshot.transform(attributes: ..<interactableStartIndex) {
                attribute in
                attribute.insert(.prefixing)
            }
        }
        
        redundant_symbols_are_removable: do {
            snapshot.transform(attributes: redundanceStartIndex...) {
                attribute in
                attribute.insert(.removable)
            }
        }
        
        trailing_symbols_are_suffix: do {
            snapshot.transform(attributes: interactableEndIndex...) {
                attribute in
                attribute = .suffix
            }
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

        let value = try Value(number: number)
        try bounds.validate(value: value)
        
        //=--------------------------------------=
        // MARK: Style
        //=--------------------------------------=
        
        let style = editableStyle(number: number)

        //=--------------------------------------=
        // MARK: Characters
        //=--------------------------------------=

        let characters = style.format(value)
                
        print(number, value, characters)
        
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
        try Value(number: number(snapshot: snapshot))
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

extension NumericTextStyle: UIKitDiffableTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable public var keyboard: UIKeyboardType {
        Value.options.contains(.integer) ? .numberPad : .decimalPad
    }
}

#endif
