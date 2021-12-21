//
//  ParseTests.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-21.
//

import XCTest
@testable import NumericTextStyles

// MARK: - ParseTestsOfDigits

final class ParseTestsOfDigits: XCTestCase {
    typealias Subject = _Digits
    
    // MARK: Setup
    
    let valid:    String = "12345"
    let invalidL: String = ".1234"
    let invalidM: String = "12.34"
    let invalidT: String = "1234."
    
    let parser: Subject.Parser = .decimals
    
    // MARK: Helpers

    func make(_ characters: String) -> Subject? {
        .init(characters: characters, parser: parser)
    }
    
    // MARK: Tests
    
    func test_initialization() {
        XCTAssertNotNil(make(valid))
        XCTAssertNil(make(invalidL))
        XCTAssertNil(make(invalidM))
        XCTAssertNil(make(invalidT))
    }
}

// MARK: - ParseTestsOfSeparator

final class ParseTestsOfSeparator: XCTestCase {
    typealias Subject = _Separator
    
    // MARK: Setup
    
    let dot   = "."
    let comma = ","
    let dash  = "-"
    
    let parser:   Subject.Parser = .dot
    let parserSE: Subject.Parser = .dot.locale(Locale(identifier: "sv_SE"))
    let parserUS: Subject.Parser = .dot.locale(Locale(identifier: "en_US"))

    // MARK: Helpers
    
    func components(_ characters: String) -> Components {
        Components(
            normal:  Subject(characters: characters, parser: parser),
            swedish: Subject(characters: characters, parser: parserSE),
            english: Subject(characters: characters, parser: parserUS))
    }
    
    // MARK: Tests
    
    func test_initialization() {
        components(dot).expectation {
            Components(
                normal:  Subject(characters: dot),
                swedish: Subject(characters: dot),
                english: Subject(characters: dot))
        }
        
        components(comma).expectation {
            Components(
                normal:  nil,
                swedish: Subject(characters: dot),
                english: nil)
        }
        
        components(dash).expectation {
            Components(
                normal:  nil,
                swedish: nil,
                english: nil)
        }
    }
    
    // MARK: Components
    
    struct Components {
        let normal:  Subject?
        let swedish: Subject?
        let english: Subject?
        
        func expectation(_ expectation: () -> Self) {
            let expectation = expectation()
            
            XCTAssertEqual(normal?.characters,  expectation.normal?.characters)
            XCTAssertEqual(swedish?.characters, expectation.swedish?.characters)
            XCTAssertEqual(english?.characters, expectation.english?.characters)
        }
    }
}

// MARK: - ParseTestsOfSeparator

final class ParseTestsOfSign: XCTestCase {
    typealias Subject = _Sign
    
    // MARK: Setup
    
    let plus = "+"
    let minus = "-"
    let none = ""
    let invalid = "x"
        
    // MARK: Helpers
    
    func components(_ characters: String) -> Components {
        Components(
            all:       Subject(characters: characters, parser: .all),
            positives: Subject(characters: characters, parser: .positives),
            negatives: Subject(characters: characters, parser: .negatives))
    }
    
    // MARK: Tests
    
    func test_initialization() {
        components(plus).expectation {
            Components(
                all:       Subject.positive,
                positives: Subject.positive,
                negatives: nil)
        }
        
        components(minus).expectation {
            Components(
                all:       Subject.negative,
                positives: nil,
                negatives: Subject.negative)
        }

        components(none).expectation {
            Components(
                all:       Subject.none,
                positives: Subject.none,
                negatives: Subject.none)
        }

        components(invalid).expectation {
            Components(
                all:       nil,
                positives: nil,
                negatives: nil)
        }
    }
    
    // MARK: Components
    
    struct Components {
        let all: Subject?
        let positives: Subject?
        let negatives: Subject?
        
        func expectation(_ expectation: () -> Self) {
            let expectation = expectation()
            
            XCTAssertEqual(all?.characters,       expectation.all?.characters)
            XCTAssertEqual(positives?.characters, expectation.positives?.characters)
            XCTAssertEqual(negatives?.characters, expectation.negatives?.characters)
        }
    }
}
