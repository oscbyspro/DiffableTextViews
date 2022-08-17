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

@testable import DiffableTextKitXUIKit

import XCTest

//*============================================================================*
// MARK: * Downstream x Tests
//*============================================================================*

/// ```
/// Asserts: UITextField/offset(from:to:) is O(1).
/// ```
final class DownstreamTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var downstream  = Downstream()
    
    lazy var alphabet    = "ABCDEFGHIJJKLMNOPQRSTUVWXYZ"
    lazy var alphabet10  = String(repeating: alphabet, count: 10)
    lazy var alphabet100 = String(repeating: alphabet, count: 100)
    
    //=------------------------------------------------------------------------=
    // MARK: State x Setup
    //=------------------------------------------------------------------------=
    
    override func setUp() {
        super.setUp()
        downstream.text = String()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func size() -> Int {
        Int(downstream.view.distance(to: downstream.view.endOfDocument))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Position
//=----------------------------------------------------------------------------=

extension DownstreamTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testPositionsAreMeasuredInUTF16() {
        downstream.text = "🇸🇪"
        //=--------------------------------------=
        // Assert
        //=--------------------------------------=
        XCTAssertEqual(8, downstream.text.utf8 .count)
        XCTAssertEqual(4, downstream.text.utf16.count)
        XCTAssertEqual(4, size())
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Measurements
//=----------------------------------------------------------------------------=

extension DownstreamTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func loopOverSize() {
        for _ in 0 ..< 1 {
            _ = size()
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
        downstream.view.text = alphabet
        measure(loopOverSize)
    }
    
    /// 1,000,000 iterations:
    ///
    /// - 0.914 sec.
    ///
    func testMeasure10_() {
        downstream.view.text = alphabet10
        measure(loopOverSize)
    }
    
    /// 1,000,000 iterations:
    ///
    /// - 0.917 sec.
    ///
    func testMeasure100() {
        downstream.view.text = alphabet100
        measure(loopOverSize)
    }
}

#endif
#endif
