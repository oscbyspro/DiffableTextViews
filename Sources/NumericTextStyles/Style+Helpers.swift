//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Lexicon
    //=------------------------------------------------------------------------=
    
    @inlinable func components(_ snapshot: Snapshot) throws -> Components {
        try adapter.lexicon.components(in: snapshot, as: Value.self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Format
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Strategies
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(_ components: Components) -> Format.Sign {
        components.sign == .negative ? .always : .automatic
    }

    @inlinable func separator(_ components: Components) -> Format.Separator {
        components.separator == .fraction ? .always : .automatic
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Fixes
//=----------------------------------------------------------------------------=

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Sign
    //=------------------------------------------------------------------------=
    
    /// This method exists because Apple's format styles always interpret zero as having a positive sign.
    @inlinable func fix(_ sign: Sign, for value: Value, in characters: inout String) {
        guard sign == .negative, value == .zero else { return }
        guard let position = characters.firstIndex(of: lexicon.signs[sign.toggled()]) else { return }
        characters.replaceSubrange(position...position, with: String(lexicon.signs[sign]))
    }
}
