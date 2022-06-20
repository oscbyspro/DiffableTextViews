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
    // MARK: Tests x State
    //=------------------------------------------------------------------------=
    
    func testAnchorIsNilByDefault() {
        XCTAssertEqual(Snapshot("ABC").anchor, nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitWithoutArgumentsIsEmpty() {
        XCTAssert(Snapshot().isEmpty)
    }
    
    func testInitCharactersDefaultAttributeIsContent() {
        XCTAssert(Snapshot("ABC").attributes.allSatisfy({ $0 == .content }))
    }
    
    func testInitAsArrayLiteral() {
        XCTAssertEqual(Snapshot("ABC"), [Symbol("A"), Symbol("B"), Symbol("C")])
    }
    
    func testInitAsStringLiteral() {
        XCTAssertEqual(Snapshot("ABC"), "ABC")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations x Anchor
    //=------------------------------------------------------------------------=
    
    func testAnchorAtIndex() {
        var snapshot = Snapshot("ABC")
        let index = snapshot.index(at: .character(1))
        
        snapshot.anchor(at: index)
        XCTAssertEqual(snapshot.anchor, index)
        
        snapshot.anchor(at: nil)
        XCTAssertEqual(snapshot.anchor, nil)
    }
    
    func testAnchorAtEndIndex() {
        var snapshot = Snapshot()
        snapshot.append("A")
        snapshot.anchorAtEndIndex()
        snapshot.append("B")
        snapshot.append("C")
        XCTAssertEqual(snapshot.anchor, snapshot.index(at: .character(1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations x Append
    //=------------------------------------------------------------------------=
    
    func testAppend() {
        var snapshot = Snapshot()
        snapshot.append("A")
        snapshot.append("B")
        snapshot.append("C")
        XCTAssertEqual(snapshot, "ABC")
    }
    
    func testAppendContentsOf() {
        var snapshot = Snapshot("AB")
        snapshot.append(contentsOf: "CDE")
        XCTAssertEqual(snapshot, "ABCDE")
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
        snapshot.insert("B", at: snapshot.index(at: .character(1)))
        XCTAssertEqual(snapshot, "ABC")
    }
    
    func testInsertContentsOf() {
        var snapshot = Snapshot("AE")
        snapshot.insert(contentsOf: "BCD", at: snapshot.index(at: .character(1)))
        XCTAssertEqual(snapshot, "ABCDE")
    }
    
    func testInsertContentsOfCharactersDefaultAttributeIsContent() {
        var snapshot = Snapshot("AE")
        snapshot.insert(contentsOf: "BCD", at: snapshot.index(at: .character(1)))
        XCTAssert(snapshot.attributes.allSatisfy({ $0 == .content }))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations x Replace
    //=------------------------------------------------------------------------=
    
    func testReplaceSubrange() {
        var snapshot = Snapshot("AxxxE")
        snapshot.replaceSubrange(snapshot.indices(at: .character(1) ..< 4), with: "BCD")
        XCTAssertEqual(snapshot, "ABCDE")
    }
    
    func testReplaceSubrangeWithCharactersDefaultAttributeIsContent() {
        var snapshot = Snapshot("AxxxE")
        snapshot.replaceSubrange(snapshot.indices(at: .character(1) ..< 4), with: "BCD")
        XCTAssert(snapshot.attributes.allSatisfy({ $0 == .content }))
    }
}

#endif
