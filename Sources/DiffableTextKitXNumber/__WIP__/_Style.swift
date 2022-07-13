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
// MARK: * Style
//*============================================================================*

public protocol _Style: DiffableTextStyle where Cache: _Cache, Value: NumberTextValue { }

//*============================================================================*
// MARK: * Style x Internal x Base
//*============================================================================*

@usableFromInline protocol _Style_Internal_Base: _Style {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var bounds: NumberTextBounds<Value>? { get set }
    
    @inlinable var precision: NumberTextPrecision<Value>? { get set }
}

#warning("TODO")
