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

@testable import DiffableTextViewsXiOS

//*============================================================================*
// MARK: * ViewsTests x ActorTextField
//*============================================================================*

/// ```
/// Asserts: UITextField/offset(from:to:) is O(1).
/// ```
final class ViewsTestsXActorTextField: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var view = ActorTextField(BasicTextField())
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    override func setUp() {
        super.setUp(); view.wrapped.text = nil
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Position
//=----------------------------------------------------------------------------=

extension ViewsTestsXActorTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testPositionsAreMeasuredInUTF16() {
        view.wrapped.text = "🇸🇪"
        //=--------------------------------------=
        // MARK: Assert
        //=--------------------------------------=
        XCTAssertEqual(8, view.wrapped.text!.utf8 .count)
        XCTAssertEqual(4, view.wrapped.text!.utf16.count)
        XCTAssertEqual(4, view.size)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Measurements
//=----------------------------------------------------------------------------=

extension ViewsTestsXActorTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Loop
    //=------------------------------------------------------------------------=
    
    func offsetLoop() {
        for _ in 0 ..< 1_000_000 {
            _ = view.size
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
        view.wrapped.text = alphabet1__
        measure(offsetLoop)
    }
    
    /// 1,000,000 iterations:
    ///
    /// - 0.914 sec.
    ///
    func testMeasure10_() {
        view.wrapped.text = alphabet10_
        measure(offsetLoop)
    }
    
    /// 1,000,000 iterations:
    ///
    /// - 0.917 sec.
    ///
    func testMeasure100() {
        view.wrapped.text = alphabet100
        measure(offsetLoop)
    }
}

#endif
#endif
