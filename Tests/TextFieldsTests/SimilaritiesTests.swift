//
//  SimilaritiesTests.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-13.
//

import XCTest
@testable import struct TextFields.Similarities

// MARK: - SimilaritiesTestsOfInspection

final class SimilaritiesTestsOfInspection: XCTestCase {
    typealias Similarities = TextFields.Similarities<[Int], [Int]>
    typealias Options = Similarities.Options
    typealias Inspection = Options.Inspection
    
    // MARK: Setup
    
    let lhs = [0, 1, 2, 3, 4]
    let rhs = [0, 2, 4]
    
    //  MARK: Helpers
    
    func similarities(_ inspection: Inspection) -> Similarities {
        .init(lhs: lhs, rhs: rhs, options: .inspect(inspection))
    }
    
    // MARK: Tests
    
    func test_each() {
        let similarities = similarities(.each)
        
        let prefix = [0]
        let suffix = [4]
        
        XCTAssert(prefix.elementsEqual(similarities.lhsPrefix()))
        XCTAssert(suffix.elementsEqual(similarities.lhsSuffix()))
        XCTAssert(prefix.elementsEqual(similarities.rhsPrefix()))
        XCTAssert(suffix.elementsEqual(similarities.rhsSuffix()))
    }
    
    func test_only() {
        let similarities = similarities(.only({ $0.isMultiple(of: 2) }))

        XCTAssert(lhs.elementsEqual(similarities.lhsPrefix()))
        XCTAssert(lhs.elementsEqual(similarities.lhsSuffix()))
        XCTAssert(rhs.elementsEqual(similarities.rhsPrefix()))
        XCTAssert(rhs.elementsEqual(similarities.rhsSuffix()))
    }
}

// MARK: - SimilaritiesTestsOfProductions

final class SimilaritiesTestsOfProductions: XCTestCase {
    typealias Similarities = TextFields.Similarities<[Int], [Int]>
    typealias Options = Similarities.Options
    typealias Production = Options.Production
    
    // MARK: Setup
    
    let lhs = [1, 0, 0, 0, 1]
    let rhs = [1]
    
    //  MARK: Helpers
    
    func similarities(_ production: Production) -> Similarities {
        let options = Options
            .inspect(.only({ $0 == 1 }))
            .produce(production)
        
        return .init(lhs: lhs, rhs: rhs, options: options)
    }
        
    // MARK: Tests
        
    func test_wrapper() {
        let similarities = similarities(.wrapper)

        XCTAssert(rhs.elementsEqual(similarities.lhsPrefix()))
        XCTAssert(rhs.elementsEqual(similarities.lhsSuffix()))
        XCTAssert(rhs.elementsEqual(similarities.rhsPrefix()))
        XCTAssert(rhs.elementsEqual(similarities.rhsSuffix()))
    }
    
    func test_overshoot() {
        let similarities = similarities(.overshoot)
        
        XCTAssert([1, 0, 0, 0].elementsEqual(similarities.lhsPrefix()))
        XCTAssert([0, 0, 0, 1].elementsEqual(similarities.lhsSuffix()))
        XCTAssert(         rhs.elementsEqual(similarities.rhsPrefix()))
        XCTAssert(         rhs.elementsEqual(similarities.rhsSuffix()))
    }
}
