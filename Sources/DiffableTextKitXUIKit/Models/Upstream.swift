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
    @usableFromInline typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline let style: Style
    @usableFromInline let value: Binding<Value>
    
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ parent: DiffableTextField<Style>, _ environment: EnvironmentValues) {
        self.style = parent.style.locale(environment.locale); self.value = parent.value
    }
}

#endif
