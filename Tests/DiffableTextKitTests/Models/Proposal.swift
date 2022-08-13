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
        let snapshot    = Snapshot("AxxxE")
        let replacement = Snapshot( "BCD" )
        let range = snapshot.indices(at:  Offset<Character>(1) ..< 4)
        let proposal = Proposal(snapshot, with: replacement, in: range)
        XCTAssertEqual(proposal.merged(), "ABCDE")
    }
    
    func testLazyMerged() {
        let snapshot    = Snapshot("AxxxE")
        let replacement = Snapshot( "BCD" )
        let range = snapshot.indices(at:  Offset<Character>(1) ..< 4)
        let proposal = Proposal(snapshot, with: replacement, in: range)
        XCTAssertEqual(Snapshot(proposal.lazy.merged()), "ABCDE")
    }
}

#endif
