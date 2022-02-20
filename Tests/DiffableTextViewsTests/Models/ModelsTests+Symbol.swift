//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import DiffableTextViews
import XCTest

//*============================================================================*
// MARK: * SymbolTests
//*============================================================================*

final class ModelsTestsXSymbol: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAnchorHasNoWidth() {
        XCTAssertEqual(String(repeating: Symbol.anchor.character, count: 3), "​​​")
    }
}

#endif
