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
    
    @inlinable func number(_ proposal: Proposal, as kind: (some NumberTextKind).Type) throws -> Number? {
        var proposal = proposal
        //=--------------------------------------=
        // Process
        //=--------------------------------------=
        translator.translateSingleSymbol(in: &proposal.replacement)
        let sign = components.consumeSingleSign(in: &proposal.replacement)
        //=--------------------------------------=
        // Parse
        //=--------------------------------------=
        guard var number = try components.number(in:
        proposal.merged(), as: kind) else { return nil }
        //=--------------------------------------=
        // Commands
        //=--------------------------------------=
        if let sign { number.sign = sign }; return number
    }
}
