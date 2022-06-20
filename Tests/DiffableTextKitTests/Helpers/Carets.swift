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
// MARK: * Carets x Tests
//*============================================================================*

final class CaretsTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func AssertEqual<T>(_ carets: Carets<T>, lower: T, upper: T) {
        XCTAssertEqual(carets.lower, lower)
        XCTAssertEqual(carets.upper, upper)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitUncheckedIsUnchecked() {
        AssertEqual(Carets(unchecked: (1, 0)), lower: 1, upper: 0)
    }
    
    func testInitCaretSetsBothToSame() {
        AssertEqual(Carets(7), lower: 7, upper: 7)
    }
    
    func testInitRangeSetsBoth() {
        AssertEqual(Carets(3 ..< 7), lower: 3, upper: 7)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testCollapseSetsBothCaretsToUpper() {
        let carets0 = Carets(3 ..< 7)
        var carets1 = carets0; carets1.collapse()
        
        AssertEqual(carets0, lower: 3, upper: 7)
        AssertEqual(carets1, lower: 7, upper: 7)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities
    //=------------------------------------------------------------------------=
    
    func testRangeEqualsLowerToUpper() {
        XCTAssertEqual(Carets(3 ..< 7).range, 3 ..< 7)
    }
    
    func testbMapUpperLowerMapsBothWhenUnequal() {
        let carets = Carets(3 ..< 7).map(lower: { $0 + 1 }, upper: { $0 - 1 })
        AssertEqual(carets, lower: 4, upper: 6)
    }
    
    func testMapUpperLowerClampsLowerToUpperWhenUnequal() {
        let carets = Carets(3 ..< 7).map(lower: { $0 + 4 }, upper: { $0 - 4 })
        AssertEqual(carets, lower: 3, upper: 3)
    }
    
    func testMapLowerUpperMapsBothAsUpperWhenEqual() {
        let carets = Carets(3 ..< 3).map(lower: { $0 + 1 }, upper: { $0 - 1 })
        AssertEqual(carets, lower: 2, upper: 2)
    }
}

#endif
