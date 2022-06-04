//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Reader
//*============================================================================*

public final class NumberTextReader {
    
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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func number<T>(_ proposal: Proposal, as kind: T.Type)
    throws -> Number? where T: NumberTextKind {
        var proposal = proposal
        //=--------------------------------------=
        // Edit
        //=--------------------------------------=
        translateSingleSymbol(in: &proposal)
        let sign = consumeSingleSign(in: &proposal)
        //=--------------------------------------=
        // Read
        //=--------------------------------------=
        guard var number = try Number(in: proposal.merged(),
        using: components, as: kind) else { return nil }

        if let sign = sign { number.sign = sign }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return number
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Translates a proposal with a replacement snapshot of size one.
    @inlinable func translateSingleSymbol(in proposal: inout Proposal) {
        guard proposal.replacement.count == 1 else { return }
        //=--------------------------------------=
        // Translate
        //=--------------------------------------=
        proposal.replacement = proposal.replacement.reduce(into: .init()) {
            $0.append(Symbol(translator[$1.character], as: $1.attribute))
        }
    }
    
    /// Consumes a proposal with a replacement snapshot of only a sign.
    @inlinable func consumeSingleSign(in proposal: inout Proposal) -> Sign? {
        guard proposal.replacement.count == 1, let sign = components.signs[
        proposal.replacement.first!.character] else { return nil }
        //=--------------------------------------=
        // Remove, Return
        //=--------------------------------------=
        proposal.replacement.removeAll(); return sign
    }
}
