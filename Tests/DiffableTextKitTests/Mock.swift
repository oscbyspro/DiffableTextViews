//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Mock
//*============================================================================*

struct Mock: DiffableTextStyle {
    typealias Value = String
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    var locale: Locale
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(locale: Locale = .autoupdatingCurrent) { self.locale = locale }
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    func locale(_ locale: Locale) -> Self {
        var S0 = self; S0.locale = locale; return S0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func format(_ value: Value, with cache: inout Void) -> String {
        value
    }
    
    func interpret(_ value: Value, with cache: inout Void) -> Commit<Value> {
        Commit(value, Snapshot(value))
    }
    
    func resolve(_ proposal: Proposal, with cache: inout Void) throws -> Commit<Value> {
        interpret(proposal.merged().characters)
    }
}

#if DEBUG

import XCTest

//*============================================================================*
// MARK: * Mock x Tests
//*============================================================================*

final class MockTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func test() {
        //=--------------------------------------=
        // Setup
        //=--------------------------------------=
        let mock0 = Mock(locale: en_US)
        let mock1 = mock0.locale(sv_SE)
        //=--------------------------------------=
        // Assert
        //=--------------------------------------=
        XCTAssertNotEqual(mock0, mock1)
    }
}

#endif
