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
// MARK: * Suffix x Tests
//*============================================================================*

final class SuffixTests: XCTestCase {

    typealias C = Offset<Character>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFormat() {
        XCTAssertEqual(Mock().suffix("🇸🇪").format("🇺🇸"), "🇺🇸🇸🇪")
    }
    
    func testInterpret() {
        XCTAssertEqual(Mock().suffix("🇸🇪").interpret("🇺🇸"),
        Commit("🇺🇸", "🇺🇸" + Snapshot("🇸🇪", as: .phantom)))
    }
    
    func testSelectionIsSame() {
        let characters = "0123456789"
        
        let normal = Mock(selection: true)/*----------*/.interpret(characters).snapshot
        let suffix = Mock(selection: true).suffix("...").interpret(characters).snapshot
        
        XCTAssertEqual(normal.selection!.positions(), normal.indices(at: C(0) ..< C(10)))
        XCTAssertEqual(suffix.selection!.positions(), suffix.indices(at: C(0) ..< C(10)))
    }
}

#endif
