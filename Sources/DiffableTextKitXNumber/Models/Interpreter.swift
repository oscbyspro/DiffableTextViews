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

@usableFromInline struct Interpreter {
    
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
        self.translator = Translator(components)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// - Requires that formatter.numberStyle == .none.
    @inlinable static func standard(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .none); return Self(.standard(formatter))
    }
    
    /// - Requires that formatter.numberStyle == .none.
    @inlinable static func currency(_ formatter: NumberFormatter) -> Self {
        assert(formatter.numberStyle == .none); return Self(.currency(formatter))
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
        var proposal = proposal; translator.translateSingleSymbol(in: &proposal.replacement)
        let sign = components.consumeSingleSign(in: &proposal.replacement)
        guard var number = try self.number(proposal.merged(), as: value) else { return nil }
        if let sign { number.sign = sign }; return number
    }
}
