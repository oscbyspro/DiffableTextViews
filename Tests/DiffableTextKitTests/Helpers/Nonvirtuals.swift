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
// MARK: * Nonvirtuals x Tests
//*============================================================================*

final class NonvirtualsTests: XCTestCase {
    
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
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testItWorks() {
        snapshot = [
        Symbol("v", as: [.virtual]),
        Symbol("v", as: [.virtual]),
        Symbol("v", as: [.virtual]),

        Symbol("A", as: [.content]),
        
        Symbol("p", as: [.phantom]),
        Symbol("p", as: [.phantom]),
        Symbol("p", as: [.phantom]),
        
        Symbol("B", as: [.insertable ]),
        Symbol("C", as: [.removable  ]),
        Symbol("D", as: [.passthrough]),
        
        Symbol("v", as: [.virtual]),
        Symbol("v", as: [.virtual]),
        Symbol("v", as: [.virtual]),
        
        Symbol("E", as: [.insertable, .removable, .passthrough]),
        
        Symbol("p", as: [.phantom]),
        Symbol("p", as: [.phantom]),
        Symbol("p", as: [.phantom])]
        
        XCTAssertEqual(String(snapshot.nonvirtuals), "ABCDE")
    }
}

#endif
