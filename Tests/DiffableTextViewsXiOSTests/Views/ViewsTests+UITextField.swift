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

import UIKit
import XCTest

@testable import DiffableTextViewsXiOS

//*============================================================================*
// MARK: * ViewsTests x UITextField
//*============================================================================*

final class ViewsTestsXUITextField: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var wrapped = BasicTextField()
    lazy var proxy = ProxyTextField(wrapped)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testForceUnwrappingTextIsOK() {
        wrapped.text = nil
        XCTAssertNotNil(wrapped.text)
        XCTAssertEqual(proxy.text.value, String())
    }
    
    func testForceUnwrappingSelectedTextRangeIsOK() {
        wrapped.selectedTextRange = nil
        XCTAssertNotNil(wrapped.selectedTextRange)
        XCTAssertEqual(proxy.selection.value, String())
    }
    
    func testForceUnwrappingMarkedTextRangeIsBad() {
        XCTAssertNil(wrapped.markedTextRange)
        XCTAssertEqual(proxy.selection.marked, String())
    }
}

#endif
#endif
