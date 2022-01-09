//
//  File.swift
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
    
    lazy var loremIpsum1__ = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, magna aliqua."
    lazy var loremIpsum10_ = String(repeating: loremIpsum1__, count: 10_)
    lazy var loremIpsum100 = String(repeating: loremIpsum1__, count: 100)

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// UTF16: 0.202 sec.
    /// Character: 0.578 sec.
    func testUTF16x1__() {
        measure {
            count(loremIpsum1__, with: UTF16.self)
        }
    }
    
    /// UTF16: 0.204 sec.
    /// Character: 3.970 sec.
    func testUTF16x10_() {
        measure {
            count(loremIpsum10_, with: UTF16.self)
        }
    }
    
    /// UTF16: 0.206 sec.
    /// Character: ain't nobody got time for that.
    func testUTF16x100() {
        measure {
            count(loremIpsum100, with: UTF16.self)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    func count<S: Scheme>(_ content: String, with scheme: S.Type) {
        for _ in 0 ..< 1_000_000 {
            _ = S.size(of: content)
        }
    }
}

#endif
