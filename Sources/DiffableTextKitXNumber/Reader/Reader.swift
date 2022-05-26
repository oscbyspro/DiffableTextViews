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

public final class Reader {
    
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
        //=--------------------------------------=
        // Edit
        //=--------------------------------------=
        var proposal = proposal
        translator.translateSingleSymbol(in: &proposal)
        let sign = components.consumeSingleSign(in: &proposal)
        //=--------------------------------------=
        // Read
        //=--------------------------------------=
        guard var number = try Number(
        in: proposal.merged(),
        using: components, as: T.self)
        else { return nil }
        
        if let sign = sign { number.sign = sign }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return number
    }
}
