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
// MARK: * NSTextAlignment [...]
//*============================================================================*

extension NSTextAlignment {
    
    @inlinable init(_ alignment: TextAlignment, relativeTo layout: LayoutDirection) {
        switch alignment {
        case  .leading: self.init(layout, leftToRight:  .left, rightToLeft: .right)
        case .trailing: self.init(layout, leftToRight: .right, rightToLeft:  .left)
        case   .center: self = .center }
    }
    
    @inlinable init(_ layout: LayoutDirection, leftToRight: Self, rightToLeft: Self) {
        switch layout {
        case .rightToLeft: self = rightToLeft
        case .leftToRight: self = leftToRight
        @unknown  default: self = leftToRight }
    }
}

#endif
