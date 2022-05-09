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
// MARK: Extension
//*============================================================================*

extension NSTextAlignment {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ alignment: TextAlignment, relativeTo direction: LayoutDirection) {
        switch alignment {
        case   .leading: self = .adaptive(direction, leftToRight:  .left, rightToLeft: .right)
        case  .trailing: self = .adaptive(direction, leftToRight: .right, rightToLeft:  .left)
        case    .center: self = .center
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable static func adaptive(_ direction: LayoutDirection,
    leftToRight: @autoclosure () -> Self, rightToLeft: @autoclosure () -> Self) -> Self {
        switch direction {
        case .rightToLeft: return rightToLeft()
        case .leftToRight: return leftToRight()
        @unknown  default: return leftToRight()
        }
    }
}
#endif
