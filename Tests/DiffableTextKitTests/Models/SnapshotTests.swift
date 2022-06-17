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
// MARK: * Snapshot x Tests
//*============================================================================*

final class SnapshotTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    func index(_ position: Int, in snapshot: Snapshot) -> Index {
        snapshot.index(snapshot.startIndex, offsetBy: position)
    }
    
    func indices(_ positions: Range<Int>, in snapshot: Snapshot) -> Range<Index> {
        index(positions.lowerBound, in: snapshot) ..< index(positions.upperBound, in: snapshot)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitWithoutParametersIsEmpty() {
        XCTAssert(Snapshot().isEmpty)
    }
    
    func testInitCharactersDefaultAttributeIsContent() {
        XCTAssert(Snapshot("ABC").attributes.allSatisfy({ $0 == .content }))
    }
    
    func testInitArrayLiteral() {
        XCTAssertEqual(Snapshot("ABC"), [Symbol("A"), Symbol("B"), Symbol("C")])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations x Append
    //=------------------------------------------------------------------------=
    
    func testAppend() {
        var snapshot = Snapshot()
        snapshot.append(Symbol("A"))
        snapshot.append(Symbol("B"))
        snapshot.append(Symbol("C"))
        XCTAssertEqual(snapshot, Snapshot("ABC"))
    }
    
    func testAppendContentsOf() {
        var snapshot = Snapshot("AB")
        snapshot.append(contentsOf: Snapshot("CDE"))
        XCTAssertEqual(snapshot, Snapshot("ABCDE"))
    }
    
    func testAppendContentsOfCharactersDefaultAttributeIsContent() {
        var snapshot = Snapshot()
        snapshot.append(contentsOf: "ABC")
        XCTAssert(snapshot.attributes.allSatisfy({ $0 == .content }))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations x Insert
    //=------------------------------------------------------------------------=
    
    func testInsert() {
        var snapshot = Snapshot("AC")
        snapshot.insert(Symbol("B"), at: index(1, in: snapshot))
        XCTAssertEqual(snapshot, Snapshot("ABC"))
    }
    
    func testInsertContentsOf() {
        var snapshot = Snapshot("AE")
        snapshot.insert(contentsOf: Snapshot("BCD"), at: index(1, in: snapshot))
        XCTAssertEqual(snapshot, Snapshot("ABCDE"))
    }
    
    func testInsertContentsOfCharactersDefaultAttributeIsContent() {
        var snapshot = Snapshot("AE")
        snapshot.insert(contentsOf: "BCD", at: index(1, in: snapshot))
        XCTAssert(snapshot.attributes.allSatisfy({ $0 == .content }))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations x Replace
    //=------------------------------------------------------------------------=
    
    func testReplaceSubrange() {
        var snapshot = Snapshot("AXXXE")
        snapshot.replaceSubrange(indices(1 ..< 4, in: snapshot), with: Snapshot("BCD"))
        XCTAssertEqual(snapshot, Snapshot("ABCDE"))
    }
    
    func testReplaceSubrangeWithCharactersDefaultAttributeIsContent() {
        var snapshot = Snapshot("AXXXE")
        snapshot.replaceSubrange(indices(1 ..< 4, in: snapshot), with: "BCD")
        XCTAssert(snapshot.attributes.allSatisfy({ $0 == .content }))
    }
}

#endif
