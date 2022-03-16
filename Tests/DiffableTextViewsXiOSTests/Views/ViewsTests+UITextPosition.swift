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
// MARK: * ViewsTests x UITextPosition
//*============================================================================*

final class ViewsTestsXUITextPosition: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var view = UITextField()
    
    lazy var content1__ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    lazy var content10_ = String(repeating: content1__, count: 10_)
    lazy var content100 = String(repeating: content1__, count: 100)
    
    //=------------------------------------------------------------------------=
    // MARK: Loop
    //=------------------------------------------------------------------------=
    
    func calculateSizeLoop() {
        for _ in 0 ..< 1_000 {
            _ = view.offset(from: view.beginningOfDocument, to: view.endOfDocument)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// 1,000,000 iterations:
    ///
    /// - 0.909 sec.
    ///
    func test1__() {
        view.text = content1__
        
        measure {
            calculateSizeLoop()
        }
    }
    
    /// 1,000,000 iterations:
    ///
    /// - 0.914 sec.
    ///
    func test10_() {
        view.text = content10_

        measure {
            calculateSizeLoop()
        }
    }
    
    /// 1,000,000 iterations:
    ///
    /// - 0.917 sec.
    ///
    func test100() {
        view.text = content100

        measure {
            calculateSizeLoop()
        }
    }
}

#endif
#endif
