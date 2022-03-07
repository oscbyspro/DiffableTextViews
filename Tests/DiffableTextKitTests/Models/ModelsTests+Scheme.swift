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
@testable import DiffableTextViews

//*============================================================================*
// MARK: * ModelsTests x Scheme
//*============================================================================*

/// ```
/// Asserts: UTF16.size(of:) is O(1).
/// ```
final class ModelsTests_Scheme: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var scheme     = UTF16.self
    lazy var iterations = 1_000
    
    lazy var content1__ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    lazy var content10_ = String(repeating: content1__, count: 10_)
    lazy var content100 = String(repeating: content1__, count: 100)

    //=------------------------------------------------------------------------=
    // MARK: Loop
    //=------------------------------------------------------------------------=
    
    func calculateSizeLoop<S>(_ content: S) where S: StringProtocol {
        for _ in 0 ..< iterations {
            _ = scheme.size(of: content)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + String
//=----------------------------------------------------------------------------=

extension HelpersTests_Scheme {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// 1,000,000 iterations:
    ///
    /// - UTF16: 0.202 sec.
    /// - Character: 0.578 sec.
    ///
    func testString1__() {
        measure {
            calculateSizeLoop(content1__)
        }
    }
    
    /// 1,000,000 iterations:
    ///
    /// - UTF16: 0.204 sec.
    /// - Character: 3.970 sec.
    ///
    func testString10_() {
        measure {
            calculateSizeLoop(content10_)
        }
    }
    
    /// 1,000,000 iterations:
    ///
    /// - UTF16: 0.206 sec.
    /// - Character: ain't nobody got time for that.
    ///
    func testString100() {
        measure {
            calculateSizeLoop(content100)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Substring
//=----------------------------------------------------------------------------=

extension HelpersTests_Scheme {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// 1,000,000 iterations:
    ///
    /// - UTF16: 0.202 sec.
    /// - Character: 0.578 sec.
    ///
    func testSubstring1__() {
        measure {
            calculateSizeLoop(content1__[...])
        }
    }
    
    /// 1,000,000 iterations:
    ///
    /// - UTF16: 0.204 sec.
    /// - Character: 3.970 sec.
    ///
    func testSubstring10_() {
        measure {
            calculateSizeLoop(content10_[...])
        }
    }
    
    /// 1,000,000 iterations:
    ///
    /// - UTF16: 0.206 sec.
    /// - Character: ain't nobody got time for that.
    ///
    func testSubstring100() {
        measure {
            calculateSizeLoop(content100[...])
        }
    }
}

#endif
