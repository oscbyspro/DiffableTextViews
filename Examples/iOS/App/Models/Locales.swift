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
// MARK: * Localization
//*============================================================================*

final class Locales: ObservableObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let available: [Locale]
    @Published var current: Locale
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init() {
        self.current = Locale.autoupdatingCurrent
        self.available = Locale.availableIdentifiers.lazy
            .map(Locale.init)
            .reduce(into: Set()) { $0.insert($1) }
            .sorted(by: { $0.identifier < $1.identifier })
    }
}
