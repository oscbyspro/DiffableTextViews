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

#warning("Rename this as 'Interpreter'...")
#warning("Remake this as a struct, maybe.")
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
    
    @inlinable func number(_ snapshot: Snapshot, as kind: (some NumberTextKind).Type) throws -> Number? {
        try .init(unformatted: snapshot.nonvirtuals, signs: components.signs.components,
        digits: components.digits.components, separators: components.separators.components,
        optional: kind.isOptional, unsigned: kind.isUnsigned, integer: kind.isInteger)
    }
    
    @inlinable func number(_ proposal: Proposal, as kind: (some NumberTextKind).Type) throws -> Number? {
        var proposal = proposal
        //=--------------------------------------=
        // Proposal
        //=--------------------------------------=
        translator.translateSingleSymbol(in: &proposal.replacement)
        let sign = components.consumeSingleSign(in: &proposal.replacement)
        //=--------------------------------------=
        // Number
        //=--------------------------------------=
        guard var number = try self.number(
        proposal.merged(), as: kind) else { return nil }
        if let sign { number.sign = sign }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return number
    }
}
