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
    
    func testValidExampleNumbers() {
        XCTAssert(input: "12345", output: "12345")
        XCTAssert(input: "-1234", output: "-1234")
        XCTAssert(input: "0.123", output: "0.123")
        XCTAssert(input: "-0.12", output: "-0.12")
        XCTAssert(input: "0.000", output: "0.000")
        XCTAssert(input: "-0.00", output: "-0.00")
    }
    
    func testReplacesEmptyIntegerWithZero() {
        XCTAssert(input:      "", output:      "0")
        XCTAssert(input:     "-", output:     "-0")
        XCTAssert(input:     ".", output:     "0.")
        XCTAssert(input:  ".123", output:  "0.123")
        XCTAssert(input: "-.123", output: "-0.123")
    }
    
    func testRemovesRedundantIntegerDigits() {
        XCTAssert(input: "00000", output:    "0")
        XCTAssert(input: "00001", output:    "1")
        XCTAssert(input: "-0000", output:   "-0")
        XCTAssert(input: "-0001", output:   "-1")
        XCTAssert(input: "000.0", output:  "0.0")
        XCTAssert(input: "000.1", output:  "0.1")
        XCTAssert(input: "-00.0", output: "-0.0")
        XCTAssert(input: "-00.1", output: "-0.1")
    }
}
