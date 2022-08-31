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
// MARK: * Style x Tests x Visible
//*============================================================================*

final class StyleTestsOnVisible: XCTestCase, StyleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let style = PatternTextStyle<String>
        .pattern("+## (###) ###-##-##")
        .placeholders("#") { $0.isASCII && $0.isNumber }
        .hidden(false)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNone() {
        OKFormat___("", format: "+## (###) ###-##-##")
        OKInterpret("", format: "+## (###) ###-##-##", value: "")
    }
    
    func testSome() {
        OKFormat___("12000345", format: "+12 (000) 345-##-##")
        OKInterpret("12000345", format: "+12 (000) 345-##-##", value: "12000345")
    }
    
    func testFull() {
        OKFormat___("120003456789", format: "+12 (000) 345-67-89")
        OKInterpret("120003456789", format: "+12 (000) 345-67-89", value: "120003456789")
    }
    
    func testMore() {
        OKFormat___("120003456789000", format: "+12 (000) 345-67-89|000")
        OKInterpret("120003456789000", format: "+12 (000) 345-67-89", value: "120003456789")
    }
    
    func testNoneMismatch() {
        OKFormat___("ABC", format: "+## (###) ###-##-##|ABC")
        OKInterpret("ABC", format: "+## (###) ###-##-##", value: "")
    }
    
    func testSomeMismatch() {
        OKFormat___("12000345ABC", format: "+12 (000) 345-##-##|ABC")
        OKInterpret("12000345ABC", format: "+12 (000) 345-##-##", value: "12000345")
    }
}

#endif
