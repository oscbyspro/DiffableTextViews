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
// MARK: Declaration
//*============================================================================*

@usableFromInline @dynamicMemberLookup final class Context {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let layout:   Layout
    @usableFromInline let interval: Interval
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ interval: Interval, proxy: GeometryProxy) {
        self.interval = interval; self.layout = Layout(interval, in: proxy)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript<T>(dynamicMember keyPath: KeyPath<Layout, T>) -> T {
        layout[keyPath: keyPath]
    }
    
    @inlinable subscript<T>(dynamicMember keyPath: KeyPath<Interval, T>) -> T {
        interval[keyPath: keyPath]
    }
}
