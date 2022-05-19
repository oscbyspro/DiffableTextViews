//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import XCTest
@testable import DiffableTextKit

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class StyleTestsXConstant: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let en_US = Locale(identifier: "en_US")
    let sv_SE = Locale(identifier: "sv_SE")
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func test() {
        //=--------------------------------------=
        // MARK: Setup
        //=--------------------------------------=
        let mock0 = Mock(locale: en_US).constant()
        let mock1 = mock0.locale(sv_SE)
        //=--------------------------------------=
        // MARK: Assert
        //=--------------------------------------=
        XCTAssertEqual(mock0, mock1)
        XCTAssertEqual(mock0.style.locale, mock1.style.locale)
    }
}

#endif
