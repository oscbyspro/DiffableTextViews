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

@usableFromInline protocol _DefaultCache: _Cache where Input == Style.Input {
    
    associatedtype Style: _DefaultStyle
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var style: Style { get set }
    
    @inlinable var adapter: Adapter<Style.Format> { get }
    
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
    
    @inlinable func snapshot(_  characters: String) -> Snapshot
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
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension _DefaultCache {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Input) -> String {
        adapter.format.precision(precision.inactive()).format(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Active
    //=------------------------------------------------------------------------=
    
    @inlinable public func interpret(_ input: Input) -> Commit<Input> {
        var input = input
        //=--------------------------------------=
        // Adapter
        //=--------------------------------------=
        var adapter = adapter; adapter.transform(precision.active())
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&input)
        //=--------------------------------------=
        // Number
        //=--------------------------------------=
        let parseable = snapshot(adapter.format(input))
        var number = try! interpreter.number(parseable, as: Input.self)!
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
        return commit(&adapter, input, number)
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
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive x Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func resolve(_ number: Number) throws -> Commit<Input> {
        var number = number
        let count  = number.count
        //=--------------------------------------=
        // Adapter
        //=--------------------------------------=
        var adapter = adapter
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
        adapter.transform(precision.interactive(count))
        return commit(&adapter, input, number)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=

    @inlinable func commit(_ adapter: inout Adapter<Style.Format>,
    _ value: Input, _ number: Number) -> Commit<Input> {
        Commit(value, snapshot(characters(&adapter, value, number)))
    }
    
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        Snapshot(characters, as: { interpreter.attributes[$0] })
    }
    
    @inlinable func characters(_ adapter: inout Adapter<Style.Format>,
    _ value: Input, _ number: Number) -> String {
        adapter.transform(number.sign)
        adapter.transform(number.separator)
        var characters = adapter.format(value)
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        if  number.sign == .negative, value == .zero,
        let position = characters.firstIndex(
        of: interpreter.components.signs[.positive]) {
            //=----------------------------------=
            // Make Positive Zero Negative
            //=----------------------------------=
            let replacement = String(interpreter.components.signs[.negative])
            characters.replaceSubrange(position...position, with:replacement)
        }
        
        return characters
    }
}
