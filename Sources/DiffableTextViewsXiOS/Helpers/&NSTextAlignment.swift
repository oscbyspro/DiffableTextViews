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
// MARK: * NSTextAlignment
//*============================================================================*

extension NSTextAlignment {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ alignment: TextAlignment, for layout: UIUserInterfaceLayoutDirection) {
        switch alignment {
        case  .leading: self = .adaptive(layout, lr:  .left, rl: .right)
        case .trailing: self = .adaptive(layout, lr: .right, rl:  .left)
        case   .center: self = .center
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Static
    //=------------------------------------------------------------------------=
    
    @inlinable static func adaptive(_ layout: UIUserInterfaceLayoutDirection,
    lr: @autoclosure () -> Self, rl: @autoclosure () -> Self) -> Self {
        switch layout {
        case .rightToLeft: return rl()
        case .leftToRight: return lr()
        @unknown  default: return lr()
        }
    }
}

#endif
