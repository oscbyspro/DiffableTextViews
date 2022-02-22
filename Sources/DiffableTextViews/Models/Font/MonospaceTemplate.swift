//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * MonospaceTemplate
//*============================================================================*

public struct MonospaceTemplate {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    public static let text   = Self(     .monospacedSystemFont(ofSize: .zero, weight: .regular))
    public static let digits = Self(.monospacedDigitSystemFont(ofSize: .zero, weight: .regular))
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let descriptor: UIFontDescriptor
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ base: UIFont) {
        self.descriptor = base.fontDescriptor
    }
}

#endif
