//
//  NumberParserTests.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-23.
//

import XCTest
@testable import NumericTextStyles

// MARK: - NumberParserTests

final class NumberParserTests: XCTestCase {
    
    // MARK: Setup
    
    let parser: NumberParser = .standard
    
    // MARK: Assertions
    
    func XCTAssert(input: String, output: String?) {
        XCTAssertEqual(parser.parse(input)?.characters, output)
    }
    
    // MARK: Tests
    
    func testReplacesEmptyIntegerWithZero() {
        XCTAssert(input:      "", output:      "0")
        XCTAssert(input:     "-", output:     "-0")
        XCTAssert(input:     ".", output:     "0.")
        XCTAssert(input:  ".123", output:  "0.123")
        XCTAssert(input: "-.123", output: "-0.123")
    }
}
