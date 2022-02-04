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
// MARK: * Interval
//*============================================================================*

@usableFromInline final class Interval: ObservableObject {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let values: Binding<(CGFloat, CGFloat)>
    @usableFromInline let valuesLimits: ClosedRange<CGFloat>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ values: Binding<(CGFloat, CGFloat)>, in valuesLimits: ClosedRange<CGFloat>) {
        self.values = values; self.valuesLimits = valuesLimits
    }
}
