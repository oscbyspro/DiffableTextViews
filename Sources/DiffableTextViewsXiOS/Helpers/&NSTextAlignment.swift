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
        case  .leading: self =  .leading(for: layout)
        case .trailing: self = .trailing(for: layout)
        case   .center: self =   .center
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable static func leading(for  layout: UIUserInterfaceLayoutDirection) -> Self {
        switch layout {
        case .leftToRight: return  .left
        case .rightToLeft: return .right
        @unknown  default: return  .left
        }
    }
    
    @inlinable static func trailing(for layout: UIUserInterfaceLayoutDirection) -> Self {
        switch layout {
        case .leftToRight: return .right
        case .rightToLeft: return  .left
        @unknown  default: return .right
        }
    }
}

#endif
