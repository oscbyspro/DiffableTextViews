//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import Foundation

//=----------------------------------------------------------------------------=
// MARK: + Modes
//=----------------------------------------------------------------------------=

extension Precision {
    
    //=------------------------------------------------------------------------=
    // MARK: Configurations
    //=------------------------------------------------------------------------=
    
    @inlinable func inactive() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(
         integerLimits: lower.integer  ... Int.max,
        fractionLimits: lower.fraction ... Int.max)
    }

    @inlinable func active() -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(
         integerLimits: Namespace.lower.integer  ... upper.integer,
        fractionLimits: Namespace.lower.fraction ... upper.fraction)
    }
    
    @inlinable func interactive(_ count: Count) -> NumberFormatStyleConfiguration.Precision {
        .integerAndFractionLength(
         integerLimits: max(Namespace.lower.integer,  count.integer)  ... count.integer,
        fractionLimits: max(Namespace.lower.fraction, count.fraction) ... count.fraction)
    }
}
