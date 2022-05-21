//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG
#if canImport(UIKit)

@testable import DiffableTextKitXUIKit

import XCTest

//*============================================================================*
// MARK: * Views x Base
//*============================================================================*

final class ViewsTestsXBase: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var view = Base()
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testForceUnwrappingTextIsOK() {
        view.text = nil
        XCTAssertNotNil(view.text)
    }
    
    func testForceUnwrappingSelectedTextRangeIsOK() {
        view.selectedTextRange = nil
        XCTAssertNotNil(view.selectedTextRange)
    }
    
    func testForceUnwrappingMarkedTextRangeIsBad() {
        XCTAssertNil(view.markedTextRange)
    }
}

#endif
#endif
