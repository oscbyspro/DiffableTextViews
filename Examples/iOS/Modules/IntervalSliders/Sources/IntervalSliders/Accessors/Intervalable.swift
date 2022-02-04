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
// MARK: * Intervalable
//*============================================================================*

@usableFromInline protocol Intervalable {
    
    //=------------------------------------------------------------------------=
    // MARK: Interval
    //=------------------------------------------------------------------------=
    
    @inlinable var interval: Interval { get }
}

//=----------------------------------------------------------------------------=
// MARK: Intervalable - Details
//=----------------------------------------------------------------------------=

extension Intervalable {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
        
    @inlinable var values: Binding<(CGFloat, CGFloat)> {
        interval.values
    }
    
    @inlinable var valuesLimits: ClosedRange<CGFloat> {
        interval.valuesLimits
    }
}