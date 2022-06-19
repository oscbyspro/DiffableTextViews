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
// MARK: * Symbol x Tests
//*============================================================================*

final class SymbolTests: XCTestCase {
    typealias T = Offset<Character>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testInitDefaultAttributeIsContent() {
        XCTAssertEqual(Symbol("X").attribute, .content)
    }
    
    func testInitAsExtendedGraphemeClusterLiteral() {
        XCTAssertEqual("3", Symbol("3"))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Accessors
    //=------------------------------------------------------------------------=
    
    func testVirtual() {
        XCTAssert(Symbol("X", as: .phantom).virtual)
    }
    
    func testNonvirtual() {
        XCTAssert(Symbol("X", as: .content).nonvirtual)
    }
    
    func testContainsCharacter() {
        XCTAssert(     Symbol("X").contains("X"))
        XCTAssertFalse(Symbol("X").contains("Y"))
    }
    
    func testContainsAttribute() {
        XCTAssert(     Symbol("X", as: .insertable).contains(.insertable))
        XCTAssertFalse(Symbol("X", as: .insertable).contains(.removable ))
    }
}

#endif

