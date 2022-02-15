//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//*============================================================================*
// MARK: * Table of Contents
//*============================================================================*

@usableFromInline typealias SignStyle = NumericTextSignStyle

//*============================================================================*
// MARK: * NumericTextSignStyle
//*============================================================================*

public enum NumericTextSignStyle {

    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case always
    case automatic
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func standard() -> NumberFormatStyleConfiguration.SignDisplayStrategy {
        switch self {
        case .always:    return .always()
        case .automatic: return .automatic
        }
    }
    
    @inlinable func currency() -> CurrencyFormatStyleConfiguration.SignDisplayStrategy {
        switch self {
        case .always:    return .always()
        case .automatic: return .automatic
        }
    }
}
