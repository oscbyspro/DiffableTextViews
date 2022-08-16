//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKit

import XCTest

//*============================================================================*
// MARK: * Options x Tests
//*============================================================================*

final class OptionsTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCallAsFunctionMask() {
        let max = Options(rawValue: .max)
        XCTAssertEqual(max(  true),  max)
        XCTAssertEqual(max( false),  [ ])
    }
    
    func testPlusEqualsFormsUnion() {
        var options = Options()
        options += Options(rawValue: 1 << 0)
        options += Options(rawValue: 1 << 1)
        options += Options(rawValue: 1 << 1)
        options += Options(rawValue: 1 << 1)
        options += Options(rawValue: 1 << 2)
        XCTAssertEqual(options.rawValue, 0b111)
    }
    
    func testNotMeansSameAsIsEmpty() {
        XCTAssertEqual(!Options(rawValue: 0b0),  true)
        XCTAssertEqual(!Options(rawValue: 0b1), false)
    }
    
    //*========================================================================*
    // MARK: * Options [...]
    //*========================================================================*
    
    struct Options: OptionSet { let rawValue: UInt8 }
}

#endif
