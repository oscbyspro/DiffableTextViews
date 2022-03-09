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
@testable import DiffableTextStylesXPattern

//*============================================================================*
// MARK: * StyleTests x Hidden
//*============================================================================*

final class StyleTestsXHidden: XCTestCase, StyleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    lazy var style = PatternTextStyle<String>
        .pattern("+### (###) ##-##-##")
        .placeholder("#") { $0.isASCII && $0.isNumber }
        .hidden()
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNone() {
        XCTFormat___("", format: "+")
        XCTInterpret("", format: "+", value: "")
    }
    
    func testSome() {
        XCTFormat___("12300045", format: "+123 (000) 45")
        XCTInterpret("12300045", format: "+123 (000) 45", value: "12300045")
    }
    
    func testFull() {
        XCTFormat___("123000456789", format: "+123 (000) 45-67-89")
        XCTInterpret("123000456789", format: "+123 (000) 45-67-89", value: "123000456789")
    }
    
    func testMore() {
        XCTFormat___("123000456789000", format: "+123 (000) 45-67-89|000")
        XCTInterpret("123000456789000", format: "+123 (000) 45-67-89", value: "123000456789")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests - Mismatches
    //=------------------------------------------------------------------------=
    
    func testNoneMismatch() {
        XCTFormat___("ABC", format: "+|ABC")
        XCTInterpret("ABC", format: "+", value: "")
    }
    
    func testSomeMismatch() {
        XCTFormat___("12300045ABC", format: "+123 (000) 45|ABC")
        XCTInterpret("12300045ABC", format: "+123 (000) 45", value: "12300045")
    }
}

#endif
