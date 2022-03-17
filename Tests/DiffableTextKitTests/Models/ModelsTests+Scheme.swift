//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import DiffableTestKit

//*============================================================================*
// MARK: * ModelsTests x Scheme
//*============================================================================*

/// ```
/// Asserts: UTF16.size(of:) is O(1).
/// ```
final class ModelsTestsXScheme: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Loop
    //=------------------------------------------------------------------------=
    
    func sizeLoop<S>(_ alphabet: S) where S: StringProtocol {
        for _ in 0 ..< 1_000 {
            _ = UTF16.size(of: alphabet)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + String
//=----------------------------------------------------------------------------=

extension ModelsTestsXScheme {

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
            sizeLoop(alphabet)
        }
    }
    
    /// 1,000,000 iterations:
    ///
    /// - UTF16: 0.204 sec.
    /// - Character: 3.970 sec.
    ///
    func testString10_() {
        measure {
            sizeLoop(alphabet10)
        }
    }
    
    /// 1,000,000 iterations:
    ///
    /// - UTF16: 0.206 sec.
    /// - Character: ain't nobody got time for that.
    ///
    func testString100() {
        measure {
            sizeLoop(alphabet100)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Substring
//=----------------------------------------------------------------------------=

extension ModelsTestsXScheme {

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
            sizeLoop(alphabet[...])
        }
    }
    
    /// 1,000,000 iterations:
    ///
    /// - UTF16: 0.204 sec.
    /// - Character: 3.970 sec.
    ///
    func testSubstring10_() {
        measure {
            sizeLoop(alphabet10[...])
        }
    }
    
    /// 1,000,000 iterations:
    ///
    /// - UTF16: 0.206 sec.
    /// - Character: ain't nobody got time for that.
    ///
    func testSubstring100() {
        measure {
            sizeLoop(alphabet100[...])
        }
    }
}

#endif
