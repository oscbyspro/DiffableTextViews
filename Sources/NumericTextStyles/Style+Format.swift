//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// MARK: + Format
//=----------------------------------------------------------------------------=

extension _NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Strategies
    //=------------------------------------------------------------------------=
    
    @inlinable func sign(_ number: Number) -> Format.Sign {
        number.sign == .negative ? .always : .automatic
    }
    
    @inlinable func separator(_ number: Number) -> Format.Separator {
        number.separator == .fraction ? .always : .automatic
    }

    //=------------------------------------------------------------------------=
    // MARK: Fixes
    //=------------------------------------------------------------------------=
    
    /// This method exists because Apple's format styles always interpret zero as having a positive sign.
    @inlinable func fix(_ sign: Sign, for value: Value, in characters: inout String) {
        guard sign == .negative, value == .zero else { return }
        guard let position = characters.firstIndex(of: lexicon.signs[sign.toggled()]) else { return }
        characters.replaceSubrange(position...position, with: String(lexicon.signs[sign]))
    }
}
