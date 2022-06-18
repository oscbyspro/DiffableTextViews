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
        snapshot.append(Symbol("A"))
        snapshot.anchorAtEndIndex()
        snapshot.append(Symbol("B"))
        snapshot.append(Symbol("C"))
        XCTAssertEqual(snapshot.anchor, snapshot.index(at: .character(1)))
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
        snapshot.insert(Symbol("B"), at: snapshot.index(at: .character(1)))
        XCTAssertEqual(snapshot, Snapshot("ABC"))
    }
    
    func testInsertContentsOf() {
        var snapshot = Snapshot("AE")
        snapshot.insert(contentsOf: Snapshot("BCD"), at: snapshot.index(at: .character(1)))
        XCTAssertEqual(snapshot, Snapshot("ABCDE"))
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
        var snapshot    = Snapshot("AxxxE")
        let replacement = Snapshot( "BCD" )
        let indices = snapshot.indices(at: .character(1) ..< 4)
        snapshot.replaceSubrange(indices, with: replacement)
        XCTAssertEqual(snapshot, Snapshot("ABCDE"))
    }
    
    func testReplaceSubrangeWithCharactersDefaultAttributeIsContent() {
        var snapshot    = Snapshot("AxxxE")
        let replacement = Snapshot( "BCD" )
        let indices = snapshot.indices(at: .character(1) ..< 4)
        snapshot.replaceSubrange(indices, with: replacement)
        XCTAssert(snapshot.attributes.allSatisfy({ $0 == .content }))
    }
}

#endif
