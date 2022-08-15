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
// MARK: * Normal x Tests
//*============================================================================*

final class NormalTextStyleTests: XCTestCase {
            
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let normal = NormalTextStyle()
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFormat() {
        XCTAssertEqual(normal.format("2"), "2")
    }
    
    func testInterpret() {
        XCTAssertEqual(normal.interpret("3"), Commit("3", "3"))
    }
    
    func testResolve() {
        let snapshot = Snapshot("13") + Snapshot("o(><)o", as: .phantom)
        let proposal = Proposal(snapshot,  with: "2", in: C(1) ..< C(1))
        
        let resolved = try! normal.resolve(proposal)
        
        XCTAssertEqual(resolved.value,    "123")
        XCTAssertEqual(resolved.snapshot, "123")
    }
}

#endif
