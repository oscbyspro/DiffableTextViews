//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import Foundation
@testable import NumericTextStyles

//*============================================================================*
// MARK: * Lexicons
//*============================================================================*

final class Lexicons {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let standard: [Lexicon]
    let currency: [Lexicon]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ locales: [Locale])  {
        self.standard = locales.compactMap({ try? Lexicon._standard($0) })
        self.currency = locales.compactMap({ try? Lexicon._currency($0) })
    }
}

#endif
