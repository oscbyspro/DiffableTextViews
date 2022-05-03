//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import DiffableTestKit
@testable import DiffableTextKit

//*============================================================================*
// MARK: Declaration
//*============================================================================*

final class SupportTestsXCache: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testObjectForKey() {
        let storage = Cache<Int, Value>()
        storage.insert(Value("ABC"), as: 123)
        XCTAssertEqual(Value("ABC"), storage.access(123))
    }
    
    //*========================================================================*
    // MARK: Value
    //*========================================================================*
    
    final class Value: Equatable {
        
        //=------------------------------------------------------------------------=
        // MARK: State
        //=------------------------------------------------------------------------=
        
        let content: String
        
        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
        init(_ content: String) { self.content = content }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        static func == (lhs: Value, rhs: Value) -> Bool {
            lhs.content == rhs.content
        }
    }
}

#endif
