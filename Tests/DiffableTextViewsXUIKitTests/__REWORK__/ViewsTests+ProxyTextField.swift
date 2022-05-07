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

import DiffableTestKit
@testable import DiffableTextKitXUIKit

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class ViewsTestsXProxyTextField: Tests {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var view = ProxyTextField(Base())
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testForceUnwrappingTextIsOK() {
        view.wrapped.text = nil
        XCTAssertNotNil(view.wrapped.text)
        XCTAssertEqual(view.text.value, String())
    }
    
    func testForceUnwrappingSelectedTextRangeIsOK() {
        view.wrapped.selectedTextRange = nil
        XCTAssertNotNil(view.wrapped.selectedTextRange)
        XCTAssertEqual(view.selection.value, String())
    }
    
    func testForceUnwrappingMarkedTextRangeIsBad() {
        XCTAssertNil(view.wrapped.markedTextRange)
        XCTAssertEqual(view.selection.marked, String())
    }
}

#endif
#endif
