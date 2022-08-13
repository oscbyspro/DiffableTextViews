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
    
    @inlinable init(_ components: Components) {
        self.components = components
        self.attributes = Attributes(components)
        self.translator = Translator(from: .ascii, to: components)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func standard(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .none); return Self(.standard(formatter))
    }
    
    @inlinable static func currency(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .none); return Self(.currency(formatter))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func number(_ symbols: some Sequence<Symbol>,
    as value: (some _Value).Type) throws -> Number? {
        let unformatted = symbols.lazy.nonvirtuals() /*--------------------------*/
        return try Number(unformatted: unformatted, signs: components.signs.tokens,
        digits: components.digits.tokens, separators: components.separators.tokens,
        optional: value.optional, unsigned: value.unsigned, integer: value.integer)
    }
    
    @inlinable func number(_ /**/ proposal: Proposal,
    as value: (some _Value).Type) throws -> Number? {
        var proposal = proposal; translator.translate(&proposal)
        let sign   = components.process(&proposal) /*---------*/
        var number = try number(proposal.lazy.merged(),as:value)
        if  sign  != nil { number?.sign = sign! }; return number
    }
}
