//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI

//*============================================================================*
// MARK: Declaration
//*============================================================================*

@usableFromInline enum Constants {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let coordinates: UInt8 = 33
    @usableFromInline static let radius: CGFloat = 27
    @usableFromInline static let thickness: CGFloat = 04
    @usableFromInline static let dragging: Animation = .linear(duration: 0.125)
}
