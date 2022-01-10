//
//  SchemeTests.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-09.
//

#if DEBUG

import XCTest
@testable import DiffableTextViews

//*============================================================================*
// MARK: * SchemeTests
//*============================================================================*

/// ```
/// Asserts: UTF16.size(of:) is O(1).
/// Checked: Character.size(of:) is not O(1).
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
            sizeTest(content1__)
        }
    }
    
    /// UTF16: 0.204 sec.
    /// Character: 3.970 sec.
    func test10_() {
        measure {
            sizeTest(content10_)
        }
    }
    
    /// UTF16: 0.206 sec.
    /// Character: ain't nobody got time for that.
    func test100() {
        measure {
            sizeTest(content100)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    func sizeTest(_ content: String) {
        for _ in 0 ..< iterations {
            _ = scheme.size(of: content)
        }
    }
}

#endif
