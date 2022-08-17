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

final class SuffixTextStyleTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFormat() {
        let suffix = Mock().suffix("🇸🇪")
        let result = suffix.format("🇺🇸")
        let expectation = "🇺🇸🇸🇪"
        
        XCTAssertEqual(result, expectation)
    }
    
    func testInterpret() {
        let suffix = Mock().suffix("🇸🇪")
        let result = suffix.interpret("🇺🇸")
        let expectation = Commit("🇺🇸",  "🇺🇸" + Snapshot("🇸🇪", as: .phantom))
        
        XCTAssertEqual(result, expectation)
    }
    
    func testResolve() {
        let proposal = Proposal("", with: "🇺🇸", in: C(0) ..< 0)
        let resolved = try! Mock().suffix("🇸🇪").resolve(proposal)

        XCTAssertEqual(resolved.value,    "🇺🇸")
        XCTAssertEqual(resolved.snapshot, "🇺🇸" + Snapshot("🇸🇪", as: .phantom))
    }
    
    func testSelectionIsSame() {
        let characters = "0123456789"
        
        let normal = Mock(selection: true)/*----------*/.interpret(characters)
        let suffix = Mock(selection: true).suffix("...").interpret(characters)
        
        XCTAssertEqual(normal.selection!.positions(), normal.snapshot.indices(at: C(0) ..< 10))
        XCTAssertEqual(suffix.selection!.positions(), suffix.snapshot.indices(at: C(0) ..< 10))
    }
}

#endif
