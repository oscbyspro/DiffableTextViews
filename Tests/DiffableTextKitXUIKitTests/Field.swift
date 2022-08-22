//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG && canImport(UIKit)

@testable import DiffableTextKitXUIKit

import XCTest

//*============================================================================*
// MARK: * Field x Tests
//*============================================================================*

final class FieldTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var field = Field()
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testForceUnwrappingTextIsOK() {
        field.text = nil
        XCTAssertNotNil(field.text)
    }
    
    func testForceUnwrappingSelectedTextRangeIsOK() {
        field.selectedTextRange = nil
        XCTAssertNotNil(field.selectedTextRange)
    }
    
    func testForceUnwrappingMarkedTextRangeIsBad() {
        XCTAssertNil(field.markedTextRange)
    }
}

#endif
