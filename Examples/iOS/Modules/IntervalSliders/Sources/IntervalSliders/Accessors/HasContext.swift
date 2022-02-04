//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * HasContext
//*============================================================================*

@usableFromInline protocol HasContext: HasInterval, HasLayout {
    
    //=------------------------------------------------------------------------=
    // MARK: Context
    //=------------------------------------------------------------------------=
    
    @inlinable var context: Context { get }
}

//=----------------------------------------------------------------------------=
// MARK: HasContext
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
