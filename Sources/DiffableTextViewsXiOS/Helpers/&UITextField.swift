//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import SwiftUI
import UIKit

//*============================================================================*
// MARK: * UITextField x Alignment
//*============================================================================*

extension UITextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func setTextAlignment(_ environment: EnvironmentValues) {
        self.setTextAlignment(environment.multilineTextAlignment)
    }
    
    @inlinable func setTextAlignment(_ newValue: TextAlignment) {
        self.textAlignment = NSTextAlignment(newValue, for: userInterfaceLayoutDirection)
    }
}

#endif
