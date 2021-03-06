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
    typealias Value = Int
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    var locale: Locale
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    func locale(_ locale: Locale) -> Self {
        var result = self; result.locale = locale; return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func format(_ value: Value, with cache: inout Void) -> String {
        fatalError()
    }
    
    func interpret(_ value: Value, with cache: inout Void) -> Commit<Value> {
        fatalError()
    }
    
    func resolve(_ proposal: Proposal, with cache: inout Void) throws -> Commit<Value> {
        fatalError()
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
