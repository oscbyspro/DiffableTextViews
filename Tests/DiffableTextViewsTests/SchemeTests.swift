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
// MARK: * SchemeTests
//*============================================================================*

/// ```
/// Asserts: UTF16.size(of:) is O(1).
/// ```
final class SchemeTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var scheme     = UTF16.self
    lazy var iterations = 1_000_000
    
    lazy var content1__ = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, magna aliqua."
    lazy var content10_ = String(repeating: content1__, count: 10_)
    lazy var content100 = String(repeating: content1__, count: 100)

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// UTF16: 0.202 sec.
    /// Character: 0.578 sec.
    func test1__() {
        measure {
            calculateSizeLoop(content1__)
        }
    }
    
    /// UTF16: 0.204 sec.
    /// Character: 3.970 sec.
    func test10_() {
        measure {
            calculateSizeLoop(content10_)
        }
    }
    
    /// UTF16: 0.206 sec.
    /// Character: ain't nobody got time for that.
    func test100() {
        measure {
            calculateSizeLoop(content100)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    func calculateSizeLoop(_ content: String) {
        for _ in 0 ..< iterations {
            _ = scheme.size(of: content)
        }
    }
}

#endif
