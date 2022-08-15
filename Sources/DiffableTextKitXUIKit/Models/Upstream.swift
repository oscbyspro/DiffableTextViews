//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import DiffableTextKit
import SwiftUI

//*============================================================================*
// MARK: * Upstream [...]
//*============================================================================*

@usableFromInline struct Upstream<Style: DiffableTextStyle> {
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline let style: Style
    @usableFromInline let value: Binding<Style.Value>
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ upstream: DiffableTextField<Style>, _ environment: EnvironmentValues) {
        self.style  = upstream.style.locale(environment.locale); self.value  = upstream.value
    }
}

#endif
