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

extension NumericTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Conversions
    //=------------------------------------------------------------------------=
    
    @inlinable func value(_ components: Components) throws -> Value {
        try lexicon.value(of: components, as: format)
    }
    
    @inlinable func components(_ snapshot: Snapshot) throws -> Components {
        try lexicon.components(in: snapshot, as: Value.self)
    }
}
