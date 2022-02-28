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
// MARK: * ProxyTextField x Text
//*============================================================================*

public extension ProxyTextField.Text {

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var value: String {
        wrapped.text! // force unwrapping is OK
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable func color(_ color: UIColor) {
        wrapped.textColor = color
    }

    @inlinable func font(_ font: UIFont) {
        wrapped.font = font
    }
    
    @inlinable func font(_ font: DiffableTextFont) {
        wrapped.font = UIFont(font)
    }
}

#endif
