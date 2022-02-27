//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import UIKit
import XCTest

//*============================================================================*
// MARK: * ViewsTests x UITextField
//*============================================================================*

final class ViewsTests_UITextField: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let uiTextField = UITextField()
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testForceUnwrappingTextIsOK() {
        uiTextField.text = nil
        XCTAssertNotNil(uiTextField.text)
    }
    
    func testForceUnwrappingSelectionIsOK() {
        uiTextField.selectedTextRange = nil
        XCTAssertNotNil(uiTextField.selectedTextRange)
    }
}

#endif
