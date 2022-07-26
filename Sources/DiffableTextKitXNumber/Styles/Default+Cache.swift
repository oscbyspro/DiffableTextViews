//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Default x Cache
//*============================================================================*

@usableFromInline protocol _DefaultCache<Style>: _Cache where Input == Style.Input {
    
    associatedtype Style: _DefaultStyle
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var style: Style { get set }
    
    @inlinable var adapter:  Adapter<Style.Format> { get }
    
    @inlinable var preferences: Preferences<Input> { get }
    
    @inlinable var interpreter: Interpreter { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ style: Style)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func compatible(_ style: Style) -> Bool
    
    @inlinable func snapshot(_ characters: String) -> Snapshot
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _DefaultCache {

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var bounds: Bounds<Input> {
        style.bounds ?? preferences.bounds
    }

    @inlinable var precision: Precision<Input> {
        style.precision ?? preferences.precision
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        Snapshot(characters, as: { interpreter.attributes[$0] })
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension _DefaultCache {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ input: Input) -> String {
        self.adapter.format(precision.inactive()).format(input)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Active
    //=------------------------------------------------------------------------=
    
    @inlinable public func interpret(_ input: Input) -> Commit<Input> {
        var input = input
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&input)
        //=--------------------------------------=
        // Number
        //=--------------------------------------=
        let format = adapter.format(precision.active())
        let numberable = snapshot(format.format(input))
        var number = try! interpreter.number(numberable, as: Input.self)!
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds   .autocorrect(&number)
        precision.autocorrect(&number)
        //=--------------------------------------=
        // Input
        //=--------------------------------------=
        input = try! adapter.parse(number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return commit(input, number, with: format)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func resolve(_ proposal: Proposal) throws -> Commit<Input> {
        let number = try interpreter.number(proposal, as: Input.self)!
        return try resolve(number)
    }
    
    @inlinable public func resolve(_ proposal: Proposal) throws -> Commit<Input?> {
        let number = try interpreter.number(proposal, as: Input?.self)
        return try number.map({ try Commit(resolve($0)) }) ?? Commit()
    }
    
    @inlinable func resolve( _ number: Number) throws -> Commit<Input> {
        var number = number; let count = number.count
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds   .autovalidate(&number)
        try precision.autovalidate(&number, count)
        //=--------------------------------------=
        // Input
        //=--------------------------------------=
        let input = try adapter.parse(number)
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(input, &number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        let format = adapter.format(precision.interactive(count))
        return commit(input, number, with: format)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func commit(_ input: Input, _ number: Number, with format: Style.Format) -> Commit<Input> {
        let separator = number.separator != nil ? _NFSC_SeparatorDS.always : .automatic
        let sign = Style.Format._SignDS(number.sign == .negative ? .always : .automatic)
        let format = format.decimalSeparator(strategy:  separator).sign(strategy:  sign)
        var characters = format.format(input)
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        if  number.sign == .negative, input == .zero,
        let position = characters.firstIndex(of:
        interpreter.components.signs[.positive]) {
            //=----------------------------------=
            // Make Positive Zero Negative
            //=----------------------------------=
            let replacement = String(interpreter.components.signs[.negative])
            characters.replaceSubrange(position...position, with:replacement)
        }
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return Commit(input, snapshot(characters))
    }
}
