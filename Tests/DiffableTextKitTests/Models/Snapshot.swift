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
    // MARK: State
    //=------------------------------------------------------------------------=
    
    var snapshot = Snapshot()
    
    //=------------------------------------------------------------------------=
    // MARK: State x Setup
    //=------------------------------------------------------------------------=
    
    override func setUp() {
        snapshot = Snapshot()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func Assert(_ characters: String, _ attributes: [Attribute]) {
        XCTAssertEqual(snapshot.characters, characters)
        XCTAssertEqual(snapshot.attributes, attributes)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x State
    //=------------------------------------------------------------------------=
    
    func testAnchorIsNilByDefault() {
        XCTAssertEqual(snapshot.anchor, nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInit() {
        Assert("", [])
    }
    
    func testInitWithCharacters() {
        snapshot = Snapshot("AB")
        
        Assert("AB", [.content, .content])
    }
    
    func testInitAsArrayLiteral() {
        snapshot = [Symbol("A"), Symbol("B", as: .phantom)]
        
        Assert("AB", [.content, .phantom])
    }
    
    func testInitAsStringLiteral() {
        snapshot = "AB" as Snapshot
        
        Assert("AB", [.content, .content])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Accessors
    //=------------------------------------------------------------------------=
    
    func testNonvirtualsIgnoresVirtualSymbols() {
        snapshot = ["A", Symbol("_", as: [.virtual]), "B"]
        XCTAssertEqual(String(snapshot.nonvirtuals), "AB")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations x Anchor
    //=------------------------------------------------------------------------=
    
    func testAnchorAtIndex() {
        snapshot = Snapshot("ABC")
        let index = snapshot.index(at: .characters(1))
        
        snapshot.anchor(at: index)
        XCTAssertEqual(snapshot.anchor, index)
        
        snapshot.anchor(at: nil)
        XCTAssertEqual(snapshot.anchor, nil)
    }
    
    func testAnchorAtEndIndex() {
        snapshot.append(Symbol(" "))
        snapshot.anchorAtEndIndex()
        snapshot.append(Symbol(" "))
        
        XCTAssertEqual(snapshot.anchor, snapshot.index(at: .characters(1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations x Append
    //=------------------------------------------------------------------------=
    
    func testAppendSymbol() {
        snapshot.append(Symbol("A"))
        snapshot.append(Symbol("B", as: .phantom))
        
        Assert("AB", [.content, .phantom])
    }
    
    func testAppendCharacter() {
        snapshot.append(Character("A"))
        snapshot.append(Character("B"), as: .phantom)
        
        Assert("AB", [.content, .phantom])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations x Append x Sequence
    //=------------------------------------------------------------------------=
    
    func testAppendContentsOfSymbols() {
        snapshot.append(contentsOf: Snapshot("A", as: .content))
        snapshot.append(contentsOf: Snapshot("B", as: .phantom))
        
        Assert("AB", [.content, .phantom])
    }
    
    func testAppendContentsOfCharacters() {
        snapshot.append(contentsOf: String("A"))
        snapshot.append(contentsOf: String("B"), as: .phantom)
        
        Assert("AB", [.content, .phantom])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations x Insert
    //=------------------------------------------------------------------------=
    
    func testInsertSymbol() {
        snapshot.insert(Symbol("B", as: .phantom), at: snapshot.startIndex)
        snapshot.insert(Symbol("A", as: .content), at: snapshot.startIndex)
        
        Assert("AB", [.content, .phantom])
    }
    
    func testInsertCharacter() {
        snapshot.insert(Character("B"), at: snapshot.startIndex, as: .phantom)
        snapshot.insert(Character("A"), at: snapshot.startIndex)
        
        Assert("AB", [.content, .phantom])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations x Insert x Collection
    //=------------------------------------------------------------------------=
    
    func testInsertContentsOfSymbols() {
        snapshot.insert(contentsOf: Snapshot("B", as: .phantom), at: snapshot.startIndex)
        snapshot.insert(contentsOf: Snapshot("A", as: .content), at: snapshot.startIndex)
        
        Assert("AB", [.content, .phantom])
    }
    
    func testInsertContentsOfCharacters() {
        snapshot.insert(contentsOf: String("B"), at: snapshot.startIndex, as: .phantom)
        snapshot.insert(contentsOf: String("A"), at: snapshot.startIndex)
        
        Assert("AB", [.content, .phantom])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations x Replace
    //=------------------------------------------------------------------------=
    
    func testReplaceSubrangeWithSymbols() {
        snapshot = Snapshot(repeating: " ", count: 4)
        snapshot.replaceSubrange(snapshot.indices(at: .characters(0) ..< 2), with: Snapshot("AA", as: .content))
        snapshot.replaceSubrange(snapshot.indices(at: .characters(2) ..< 4), with: Snapshot("BB", as: .phantom))
        
        Assert("AABB", [.content, .content, .phantom, .phantom])
    }
    
    func testReplaceSubrangeWithCharacters() {
        snapshot = Snapshot(repeating: " ", count: 4)
        snapshot.replaceSubrange(snapshot.indices(at: .characters(0) ..< 2), with: Snapshot("AA", as: .content))
        snapshot.replaceSubrange(snapshot.indices(at: .characters(2) ..< 4), with: Snapshot("BB", as: .phantom))
        
        Assert("AABB", [.content, .content, .phantom, .phantom])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Invariant
    //=------------------------------------------------------------------------=
    
    func testNumberOfAttributesMustEqualNumberOfJointCharacters() {
        snapshot = Snapshot("🇸🇪🇺🇸".unicodeScalars.map(Character.init))
        Assert("🇸🇪🇺🇸", [.content, .content, .content, .content])
    }
}

#endif
