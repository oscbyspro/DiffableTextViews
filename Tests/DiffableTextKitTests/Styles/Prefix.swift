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
// MARK: * Prefix x Tests
//*============================================================================*

final class PrefixTextStyleTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFormat() {
        XCTAssertEqual(Mock().prefix("🇸🇪").format("🇺🇸"), "🇸🇪🇺🇸")
    }
    
    func testInterpret() {
        XCTAssertEqual(Mock().prefix("🇸🇪").interpret("🇺🇸"),
        Commit("🇺🇸",  Snapshot("🇸🇪", as: .phantom) + "🇺🇸"))
    }
    
    func testResolve() {
        let proposal = Proposal("", with: "🇺🇸", in: C(0) ..< 0)
        let resolved = try! Mock().prefix("🇸🇪").resolve(proposal)
        
        XCTAssertEqual(resolved.value,    "🇺🇸")
        XCTAssertEqual(resolved.snapshot, Snapshot("🇸🇪", as: .phantom) + "🇺🇸")
    }
    
    func testSelectionInBaseIsOffsetByPrefixSize() {
        let characters = "0123456789"
        
        let normal = Mock(selection: true)/*----------*/.interpret(characters).snapshot
        let prefix = Mock(selection: true).prefix("...").interpret(characters).snapshot
        
        XCTAssertEqual(normal.selection!.positions(), normal.indices(at: C(0) ..< 10))
        XCTAssertEqual(prefix.selection!.positions(), prefix.indices(at: C(3) ..< 13))
    }
}

#endif
