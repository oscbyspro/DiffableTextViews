//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKitXPattern

import XCTest

//*============================================================================*
// MARK: * Style x Tests
//*============================================================================*

protocol StyleTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    var style: PatternTextStyle<String> { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNone()
    func testSome()
    func testFull()
    func testMore()
    
    func testNoneMismatch()
    func testSomeMismatch()
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=
    
extension StyleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func OKFormat___(_ input: String, format: String) {
         XCTAssertEqual(style.format(input),   format)
    }
    
    func OKInterpret(_ input: String, format: String, value: String) {
        let testable = style.interpret(input)
        XCTAssertEqual(testable.value, value)
        XCTAssertEqual(testable.snapshot.characters, format)
    }
}

#endif
