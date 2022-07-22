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
// MARK: * Interpreter
//*============================================================================*

@usableFromInline final class Interpreter {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let components: Components
    @usableFromInline let attributes: Attributes
    @usableFromInline let translator: Translator
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(local components: Components) {
        self.components = components
        self.attributes = Attributes(components)
        self.translator = Translator(from:.ascii, to: components)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// - Requires that formatter.numberStyle == .none.
    @inlinable static func standard(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .none); return Self(local: .standard(formatter))
    }
    
    /// - Requires that formatter.numberStyle == .none.
    @inlinable static func currency(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .none); return Self(local: .currency(formatter))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func number(_ snapshot: Snapshot, as value: (some _Value).Type) throws -> Number? {
        try .init(unformatted: snapshot.nonvirtuals,signs: components.signs.tokens,
        digits: components.digits.tokens, separators: components.separators.tokens,
        optional: value.optional, unsigned: value.unsigned, integer: value.integer)
    }
    
    @inlinable func number(_ proposal: Proposal, as value: (some _Value).Type) throws -> Number? {
        var proposal = proposal;translate(&proposal.replacement)
        let sign = consumeSingleSignInput(&proposal.replacement)
        var number = try number(proposal.merged(), as:    value)
        if  sign  != nil { number?.sign = sign! }; return number
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func translate(_ replacement: inout Snapshot) {
        //=--------------------------------------=
        // Keystroke
        //=--------------------------------------=
        if  replacement.count == 1, let keystroke = replacement.first {
            replacement = Snapshot([translator.keystroke(keystroke.character)])
        //=--------------------------------------=
        // Paste, Backspace
        //=--------------------------------------=
        } else { return }
    }
    
    @inlinable func consumeSingleSignInput(_ replacement: inout Snapshot) -> Sign? {
        //=--------------------------------------=
        // Keystroke
        //=--------------------------------------=
        if  replacement.count == 1, let keystroke = replacement.first {
            let sign = components.signs[keystroke.character]
            if sign != nil { replacement = [] }; return sign
        //=--------------------------------------=
        // Paste, Backspace
        //=--------------------------------------=
        } else { return nil }
    }
}
