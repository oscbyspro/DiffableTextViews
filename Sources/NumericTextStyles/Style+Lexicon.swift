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
// MARK: + Lexicon
//=----------------------------------------------------------------------------=

extension _NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Conversions
    //=------------------------------------------------------------------------=
    
    @inlinable func value(_ number: Number) throws -> Value {
        try lexicon.value(of: number, as: format)
    }
    
    @inlinable func number(_ snapshot: Snapshot) throws -> Number {
        try lexicon.number(in: snapshot, as: Value.self)
    }
}
