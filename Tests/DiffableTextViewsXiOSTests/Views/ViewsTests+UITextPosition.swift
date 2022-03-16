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

//*============================================================================*
// MARK: * ViewsTests x UITextPosition
//*============================================================================*

final class ViewsTestsXUITextPosition: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var wrapped = UITextField()
    
    lazy var content1__ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    lazy var content10_ = String(repeating: content1__, count: 10_)
    lazy var content100 = String(repeating: content1__, count: 100)
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    override func setUp() {
        wrapped.text = nil
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Scheme
//=----------------------------------------------------------------------------=

extension ViewsTestsXUITextPosition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUsesUTF16() {
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
    
    func calculateSizeLoop() {
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
        wrapped.text = content1__
        
        measure {
            calculateSizeLoop()
        }
    }
    
    /// 1,000,000 iterations:
    ///
    /// - 0.914 sec.
    ///
    func testMeasure10_() {
        wrapped.text = content10_

        measure {
            calculateSizeLoop()
        }
    }
    
    /// 1,000,000 iterations:
    ///
    /// - 0.917 sec.
    ///
    func testMeasure100() {
        wrapped.text = content100

        measure {
            calculateSizeLoop()
        }
    }
}

#endif
#endif
