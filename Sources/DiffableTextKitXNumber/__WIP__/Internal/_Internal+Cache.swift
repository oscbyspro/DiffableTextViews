//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

#warning("....................................................................")
//*============================================================================*
// MARK: * Internal x Cache
//*============================================================================*

#warning("'Interpreter' == adapter + interpreter + adjustments, maybe?")
@usableFromInline protocol _Internal_Cache: _Cache {
    associatedtype Key: _Key
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var key: Key { get }
    @inlinable var adapter: _Adapter<Format> { get }
    @inlinable var preferences: Preferences<Input> { get }
    @inlinable var interpreter: NumberTextReader { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ key: Key)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable func snapshot(_ characters: String) -> Snapshot
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Internal_Cache {

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable var format: Format {
        adapter.format
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable func value(_ number: Number) throws -> Input {
        try adapter.parse(number)
    }

    @inlinable func number(_ snapshot: Snapshot) throws -> Number {
        try interpreter.number(snapshot, as: Input.self)!
    }

    @inlinable func number(_ proposal: Proposal) throws -> Number {
        try interpreter.number(proposal, as: Input.self)!
    }
    
    @inlinable func optional(_ proposal: Proposal) throws -> Number? {
        try interpreter.number(proposal, as: Input?.self)
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable func characters(_ value: Input, _ number: Number, _ format: Format) -> String {
        var characters = format.sign(number.sign)
       .separator(number.separator).format(value)
        let signs = interpreter.components.signs
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        if  number.sign == .negative, value == .zero,
        let index = characters.firstIndex(of: signs[.positive]) {
            //=----------------------------------=
            // Make Positive Zero Negative
            //=----------------------------------=
            let replacement = String(signs[.negative])
            characters.replaceSubrange(index...index, with: replacement)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return characters
    }

    @inlinable func snapshot(_ characters: String) -> Snapshot {
        Snapshot(characters, as: interpreter.attributes.map(_:))
    }

    @inlinable func commit(_ value: Input, _ number: Number, _ format: Format) -> Commit<Input> {
        Commit(value, snapshot(characters(value, number, format)))
    }
}
