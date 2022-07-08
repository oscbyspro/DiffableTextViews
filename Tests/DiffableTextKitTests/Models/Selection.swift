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
    
    func Assert<T>(_ selection: Selection<T>, lower: T, upper: T) {
        XCTAssertEqual(selection.lower, lower)
        XCTAssertEqual(selection.upper, upper)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitCaretSetsBothToSame() {
        Assert(Selection(7), lower: 7, upper: 7)
    }
    
    func testInitRangeSetsBoth() {
        Assert(Selection(3 ..< 7), lower: 3, upper: 7)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitMaxIsStartIndexToEndIndex() {
        Assert(Selection.max([7, 7, 7]), lower: 0, upper: 3)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testCollapseSetsBothCaretsToUpper() {
        let one = Selection(3 ..< 7)
        var two = one;two.collapse()
        
        Assert(one, lower: 3, upper: 7)
        Assert(two, lower: 7, upper: 7)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Utilities
    //=------------------------------------------------------------------------=
    
    func testPositionsAreLowerToUpperAsRange() {
        XCTAssertEqual(Selection(3 ..< 7).positions(), 3 ..< 7)
    }
    
    func testbMapUpperLowerMapsBothWhenUnequal() {
        let selection = Selection(3 ..< 7).map(
        lower: { $0 + 1 },
        upper: { $0 - 1 })
        
        Assert(selection, lower: 4, upper: 6)
    }
    
    func testMapUpperLowerClampsLowerToUpperWhenUnequal() {
        let selection = Selection(3 ..< 7).map(
        lower: { $0 + 4 },
        upper: { $0 - 4 })
        
        Assert(selection, lower: 3, upper: 3)
    }
    
    func testMapLowerUpperMapsBothAsUpperWhenEqual() {
        let selection = Selection(3 ..< 3).map(
        lower: { $0 + 1 },
        upper: { $0 - 1 })
        
        Assert(selection, lower: 2, upper: 2)
    }
}

#endif
