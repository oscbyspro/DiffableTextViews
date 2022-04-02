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

import DiffableTestKit
@testable import DiffableTextViewsXUIKit

//*============================================================================*
// MARK: * ViewsTests x Downstream
//*============================================================================*

/// ```
/// Asserts: UITextField/offset(from:to:) is O(1).
/// ```
final class ViewsTestsXDownstream: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var downstream = Downstream()
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    override func setUp() {
        super.setUp()
        downstream.wrapped.text = nil
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Position
//=----------------------------------------------------------------------------=

extension ViewsTestsXDownstream {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testPositionsAreMeasuredInUTF16() {
        downstream.wrapped.text = "🇸🇪"
        //=--------------------------------------=
        // MARK: Assert
        //=--------------------------------------=
        XCTAssertEqual(8, downstream.wrapped.text!.utf8 .count)
        XCTAssertEqual(4, downstream.wrapped.text!.utf16.count)
        XCTAssertEqual(4, downstream.size)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Measurements
//=----------------------------------------------------------------------------=

extension ViewsTestsXDownstream {
    
    //=------------------------------------------------------------------------=
    // MARK: Loop
    //=------------------------------------------------------------------------=
    
    func size() {
        for _ in 0 ..< 1 {
            _ = downstream.size
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
        downstream.wrapped.text = alphabet
        measure(size)
    }
    
    /// 1,000,000 iterations:
    ///
    /// - 0.914 sec.
    ///
    func testMeasure10_() {
        downstream.wrapped.text = alphabet10
        measure(size)
    }
    
    /// 1,000,000 iterations:
    ///
    /// - 0.917 sec.
    ///
    func testMeasure100() {
        downstream.wrapped.text = alphabet100
        measure(size)
    }
}

#endif
#endif
