//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import DiffableTextKitXNumber

import XCTest

//*============================================================================*
// MARK: * Graph x Tests x Integers
//*============================================================================*

final class GraphTestsOnIntegers: XCTestCase {
    typealias Integer = _Input & BinaryInteger
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let integers: [any Integer.Type] = [
         Int.self,  Int8.self,  Int16.self,  Int32.self,  Int64.self,
        UInt.self, UInt8.self, UInt16.self, UInt32.self, UInt64.self,
    ]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bounds
    //=------------------------------------------------------------------------=
    
    func testMaxIsLessThanOrEqualToInt() {
        for integer in integers {
            XCTAssertLessThanOrEqual(Int(integer.max), Int.max)
        }
    }
    
    func testPrecisionIsLessThanOrEqualToInt() {
        for integer in integers {
            XCTAssertLessThanOrEqual(integer.precision, Int.precision)
        }
    }
}

#endif

