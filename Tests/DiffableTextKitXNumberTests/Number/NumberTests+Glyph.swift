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
// MARK: * Number x Glyph
//*============================================================================*

final class NumberTestsXGlyph: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func XCTAssertEachBitPatternIsSameAsRawValue<T>(_ type: T.Type) where T: Glyph {
        for glyph in T.allCases {
            XCTAssertEqual(glyph.rawValue, Swift.unsafeBitCast(glyph, to: UInt8.self))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testEachBitPatternIsSameAsRawValue() {
        XCTAssertEachBitPatternIsSameAsRawValue(Sign.self)
        XCTAssertEachBitPatternIsSameAsRawValue(Digit.self)
        XCTAssertEachBitPatternIsSameAsRawValue(Separator.self)
    }
}

//*============================================================================*
// MARK: * Number x Glyph x String
//*============================================================================*

final class NumberTestsXGlyphXString: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let digits = [Digit](repeating: .seven, count: 1)
    let iterations = 1

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
                    bytes.append(digit.rawValue)
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
