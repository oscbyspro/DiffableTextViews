//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextViews

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct Twins<T: NumberTextValue> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    private var _standard: T
    private var _optional: T?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ standard: T = .zero) {
        self._standard = standard
        self._optional = standard
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var standard: T {
        get { _standard }
        set { _standard = newValue; _optional = newValue }
    }
    
    var optional: T? {
        get { _optional }
        set { _optional = newValue; _standard = newValue ?? .zero }
    }
}
