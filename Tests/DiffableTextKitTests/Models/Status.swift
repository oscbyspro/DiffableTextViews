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
// MARK: * Status x Tests
//*============================================================================*

final class StatusTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let en_US = Mock(locale: Locale(identifier: "en_US"))
    let sv_SE = Mock(locale: Locale(identifier: "sv_SE"))
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testMergeReplacesInequalValues() {
        var status  = Status(en_US, 0, false)
        let changes = status.merge(Status(sv_SE, 1, true))
        let result  = Status(sv_SE, 1,  true)
        
        XCTAssertEqual(status,  result)
        XCTAssertEqual(changes, [.style, .value, .focus])
    }
    
    func testMergeDiscardsEqualValues() {
        let en_US = EqualsTextStyle(en_US, proxy: _Void())
        let sv_SE = EqualsTextStyle(sv_SE, proxy: _Void())
        
        var status0 = Status(en_US, 0, false)
        let status1 = Status(sv_SE, 1,  true)
        let changes = status0.merge( status1)
        
        XCTAssertEqual(status0, status1)
        XCTAssertEqual(status0.style.style.locale, en_US.style.locale)
        XCTAssertEqual(changes, Changes([.value, .focus]))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities
    //=------------------------------------------------------------------------=
    
    func testMemberWiseInequal() {
        XCTAssertEqual(
        Status(en_US, 0, false) .!=
        Status(en_US, 0, false), [])
        
        XCTAssertEqual(
        Status(en_US, 0, false) .!=
        Status(sv_SE, 0, false), [.style])
        
        XCTAssertEqual(
        Status(en_US, 0, false) .!=
        Status(en_US, 1, false), [.value])
        
        XCTAssertEqual(
        Status(en_US, 0, false) .!=
        Status(en_US, 0,  true), [.focus])
        
        XCTAssertEqual(
        Status(en_US, 0, false) .!=
        Status(sv_SE, 1,  true), [.style, .value, .focus])
        
    }
}

#endif
