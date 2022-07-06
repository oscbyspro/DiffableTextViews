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
// MARK: * Selection x Tests
//*============================================================================*

final class SelectionTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func AssertEqual<T>(_ selection: Selection<T>, lower: T, upper: T) {
        XCTAssertEqual(selection.lower, lower)
        XCTAssertEqual(selection.upper, upper)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitUncheckedIsUnchecked() {
        AssertEqual(Selection(unchecked: (1, 0)), lower: 1, upper: 0)
    }
    
    func testInitCaretSetsBothToSame() {
        AssertEqual(Selection(7), lower: 7, upper: 7)
    }
    
    func testInitRangeSetsBoth() {
        AssertEqual(Selection(3 ..< 7), lower: 3, upper: 7)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testCollapseSetsBothCaretsToUpper() {
        let one = Selection(3 ..< 7)
        var two = one;two.collapse()
        
        AssertEqual(one, lower: 3, upper: 7)
        AssertEqual(two, lower: 7, upper: 7)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities
    //=------------------------------------------------------------------------=
    
    func testRangeEqualsLowerToUpper() {
        XCTAssertEqual(Selection(3 ..< 7).range, 3 ..< 7)
    }
    
    func testbMapUpperLowerMapsBothWhenUnequal() {
        let selection = Selection(3 ..< 7).map(lower: { $0 + 1 }, upper: { $0 - 1 })
        AssertEqual(selection, lower: 4, upper: 6)
    }
    
    func testMapUpperLowerClampsLowerToUpperWhenUnequal() {
        let selection = Selection(3 ..< 7).map(lower: { $0 + 4 }, upper: { $0 - 4 })
        AssertEqual(selection, lower: 3, upper: 3)
    }
    
    func testMapLowerUpperMapsBothAsUpperWhenEqual() {
        let selection = Selection(3 ..< 3).map(lower: { $0 + 1 }, upper: { $0 - 1 })
        AssertEqual(selection, lower: 2, upper: 2)
    }
}

#endif
