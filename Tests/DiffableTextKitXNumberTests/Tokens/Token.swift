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
// MARK: * Token x Tests
//*============================================================================*

final class TokenTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssertBitPatternIsSameAsRawValue<T>(_ type: T.Type) where T: Token {
        for token in T.allCases {
            XCTAssertEqual(token.ascii, Swift.unsafeBitCast(token, to: UInt8.self))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBitPatternIsSameAsRawValue() {
        XCTAssertBitPatternIsSameAsRawValue(Sign.self)
        XCTAssertBitPatternIsSameAsRawValue(Digit.self)
        XCTAssertBitPatternIsSameAsRawValue(Separator.self)
    }
}

//*============================================================================*
// MARK: * Token x Tests x String
//*============================================================================*

final class TokenTestsOnString: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let iterations = 1
    let digits = [Digit](repeating: .seven, count: 1)

    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    func collection<T>(_ type: T.Type = T.self) -> T where T: RangeReplaceableCollection {
        var result = T(); result.reserveCapacity(digits.count * iterations); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// - 1 digits and 1000000 iterations: 0.343 seconds.
    /// - 10 digits and 100000 iterations: 0.128 seconds.
    /// - 100 digits and 10000 iterations: 0.106 seconds.
    /// - 1000 digits and 1000 iterations: 0.103 seconds.
    /// - 10000 digits and 100 iterations: 0.102 seconds.
    /// - 100000 digits and 10 iterations: 0.103 seconds.
    /// - 1000000 digits and 1 iterations: 0.103 seconds.
    func test_Digits_ForEachUnicodeScalar_String() {
        measure {
            var string: String = collection()
            //=--------------------------------------=
            // Insert
            //=--------------------------------------=
            for _ in 0 ..< iterations {
                for digit in digits {
                    digit.unicode.write(to: &string)
                }
            }
        }
    }
    
    /// - 1 digits and 1000000 iterations: 0.318 seconds.
    /// - 10 digits and 100000 iterations: 0.105 seconds.
    /// - 100 digits and 10000 iterations: 0.082 seconds.
    /// - 1000 digits and 1000 iterations: 0.081 seconds.
    /// - 10000 digits and 100 iterations: 0.080 seconds.
    /// - 100000 digits and 10 iterations: 0.080 seconds.
    /// - 1000000 digits and 1 iterations: 0.081 seconds.
    func test_Digits_ForEachRawValueUInt8_String() {
        measure {
            var bytes: [UInt8] = collection()
            //=----------------------------------=
            // Insert
            //=----------------------------------=
            for _ in 0 ..< iterations {
                for digit in digits {
                    bytes.append(digit.ascii)
                }
            }
            //=----------------------------------=
            // Result
            //=----------------------------------=
            let _ = String(bytes: bytes, encoding: .utf8)
        }
    }
    
    /// - 1 digits and 1000000 iterations: 0.272 seconds.
    /// - 10 digits and 100000 iterations: 0.032 seconds.
    /// - 100 digits and 10000 iterations: 0.006 seconds.
    /// - 1000 digits and 1000 iterations: 0.001 seconds.
    /// - 10000 digits and 100 iterations: 0.000 seconds.
    /// - 100000 digits and 10 iterations: 0.000 seconds.
    /// - 1000000 digits and 1 iterations: 0.000 seconds.
    func test_Digits_UnsafeBitCastToBytes_String() {
        measure {
            var bytes: [UInt8] = collection()
            //=----------------------------------=
            // Insert
            //=----------------------------------=
            for _ in 0 ..< iterations {
                bytes.append(contentsOf: unsafeBitCast(digits, to: [UInt8].self))
            }
            //=----------------------------------=
            // Result
            //=----------------------------------=
            let _ = String(bytes: bytes, encoding: .utf8)
        }
    }
}

#endif
