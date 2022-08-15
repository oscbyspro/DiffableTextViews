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
// MARK: * Proposal x Tests
//*============================================================================*

final class ProposalTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMerged() {
        let proposal = Proposal("AxE", with: "BCD", in: C(1) ..< 2)
        XCTAssertEqual(proposal.merged(), "ABCDE")
    }
    
    func testLazyMerged() {
        let proposal = Proposal("AxE", with: "BCD", in: C(1) ..< 2)
        XCTAssertEqual(Snapshot(proposal.lazy.merged()), "ABCDE")
    }
}

#endif
