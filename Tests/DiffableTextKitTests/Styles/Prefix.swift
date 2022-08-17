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
        let prefix = Mock().prefix("🇸🇪")
        let result = prefix.format("🇺🇸")
        let expectation = "🇸🇪🇺🇸"
        
        XCTAssertEqual(result, expectation)
    }
    
    func testInterpret() {
        let prefix = Mock().prefix("🇸🇪")
        let result = prefix.interpret("🇺🇸")
        let expectation = Commit("🇺🇸", Snapshot("🇸🇪", as: .phantom) + "🇺🇸")
        
        XCTAssertEqual(result, expectation)
    }
    
    func testResolve() {
        let proposal = Proposal("", with: "🇺🇸", in: C(0) ..< 0)
        let resolved = try! Mock().prefix("🇸🇪").resolve(proposal)
        
        XCTAssertEqual(resolved.value,    "🇺🇸")
        XCTAssertEqual(resolved.snapshot, Snapshot("🇸🇪", as: .phantom) + "🇺🇸")
    }
    
    func testSelectionInBaseIsOffsetByPrefixSize() {
        let characters = "0123456789"
        
        let normal = Mock(selection: true)/*----------*/.interpret(characters)
        let prefix = Mock(selection: true).prefix("...").interpret(characters)
        
        XCTAssertEqual(normal.selection!.range(), normal.snapshot.range(at: C(0) ..< 10))
        XCTAssertEqual(prefix.selection!.range(), prefix.snapshot.range(at: C(3) ..< 13))
    }
}

#endif
