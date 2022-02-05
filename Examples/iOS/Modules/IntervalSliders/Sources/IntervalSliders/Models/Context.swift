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
// MARK: * Context
//*============================================================================*

@usableFromInline final class Context {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let layout: Layout
    @usableFromInline let interval: Interval
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ interval: Interval, proxy: GeometryProxy) {
        self.interval = interval; self.layout = Layout(interval, in: proxy)
    }
}

//*============================================================================*
// MARK: * Context x Access
//*============================================================================*

@usableFromInline protocol HasContext: HasInterval, HasLayout {
    
    //=------------------------------------------------------------------------=
    // MARK: Context
    //=------------------------------------------------------------------------=
    
    @inlinable var context: Context { get }
}

//=----------------------------------------------------------------------------=
// MARK: Context x Access - Details
//=----------------------------------------------------------------------------=

extension HasContext {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var interval: Interval {
        context.interval
    }
    
    @inlinable var layout: Layout {
        context.layout
    }
}
