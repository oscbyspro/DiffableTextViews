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
import DiffableTestKit

//*============================================================================*
// MARK: * ViewsTests x UITextPosition
//*============================================================================*

/// ```
/// Asserts: UITextField/offset(from:to:) is O(1).
/// ```
final class ViewsTestsXUITextPosition: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var wrapped = UITextField()
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    override func setUp() {
        super.setUp(); wrapped.text = nil
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Scheme
//=----------------------------------------------------------------------------=

extension ViewsTestsXUITextPosition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUITextFieldUsesUTF16() {
        wrapped.text = "🇸🇪"
        //=--------------------------------------=
        // MARK: Assert
        //=--------------------------------------=
        XCTAssertEqual(8, wrapped.text!.utf8 .count)
        XCTAssertEqual(4, wrapped.text!.utf16.count)
        XCTAssertEqual(4, wrapped.offset(from: wrapped.beginningOfDocument, to: wrapped.endOfDocument))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Measurements
//=----------------------------------------------------------------------------=

extension ViewsTestsXUITextPosition {
    
    //=------------------------------------------------------------------------=
    // MARK: Loop
    //=------------------------------------------------------------------------=
    
    func offsetLoop() {
        for _ in 0 ..< 1_000 {
            _ = wrapped.offset(from: wrapped.beginningOfDocument, to: wrapped.endOfDocument)
        }
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// 1,000,000 iterations:
    ///
    /// - 0.909 sec.
    ///
    func testMeasure1__() {
        wrapped.text = alphabet1__
        measure(offsetLoop)
    }
    
    /// 1,000,000 iterations:
    ///
    /// - 0.914 sec.
    ///
    func testMeasure10_() {
        wrapped.text = alphabet10_
        measure(offsetLoop)
    }
    
    /// 1,000,000 iterations:
    ///
    /// - 0.917 sec.
    ///
    func testMeasure100() {
        wrapped.text = alphabet100
        measure(offsetLoop)
    }
}

#endif
#endif
