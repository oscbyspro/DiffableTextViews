//
//  SimilaritiesTests.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-13.
//

import XCTest
@testable import struct TextFields.Similarities

// MARK: - Inspection

final class SimilaritiesTestsOfInspection: XCTestCase {
    typealias Subject = Similarities<[Int], [Int]>
    typealias Options = Subject.Options
    typealias Inspection = Options.Inspection
    typealias Expectations = SimilaritiesTestsExpectations<Int>
    
    // MARK: Setup
    
    let lhs = [0, 1, 2, 3, 4]
    let rhs = [0, 2, 4]
        
    // MARK: Assertions
    
    func XCTAssert(_ inspection: Inspection, expectations: () -> Expectations) {
        let options = Options.inspect(inspection)
        
        expectations().validate(Subject(lhs: lhs, rhs: rhs, options: options))
    }
        
    // MARK: Tests
    
    func test_each() {
        let prefix = [0]
        let suffix = [4]
        
        XCTAssert(.each) {
            Expectations(
                lhsPrefix: prefix,
                lhsSuffix: suffix,
                rhsPrefix: prefix,
                rhsSuffix: suffix)
        }
    }
    
    func test_only() {
        XCTAssert(.only({ $0.isMultiple(of: 2) })) {
            Expectations(
                lhsPrefix: lhs,
                lhsSuffix: lhs,
                rhsPrefix: rhs,
                rhsSuffix: rhs)
        }
    }
}

// MARK: - Production

final class SimilaritiesTestsOfProduction: XCTestCase {
    typealias Subject = Similarities<[Int], [Int]>
    typealias Options = Subject.Options
    typealias Production = Options.Production
    typealias Expectations = SimilaritiesTestsExpectations<Int>
    
    // MARK: Setup
    
    let lhs = [1, 0, 0, 0, 1]
    let rhs = [1]
        
    // MARK: Assertions
    
    func XCTAssert(_ production: Production, expectations: () -> Expectations) {
        let options = Options
            .inspect(.only({ $0 == 1 }))
            .produce(production)
                
        expectations().validate(Subject(lhs: lhs, rhs: rhs, options: options))
    }
        
    // MARK: Tests
        
    func test_wrapper() {
        XCTAssert(.wrapper) {
            Expectations(
                lhsPrefix: rhs,
                lhsSuffix: rhs,
                rhsPrefix: rhs,
                rhsSuffix: rhs)
        }
    }
    
    func test_overshoot() {
        XCTAssert(.overshoot) {
            Expectations(
                lhsPrefix: [1, 0, 0, 0],
                lhsSuffix: [0, 0, 0, 1],
                rhsPrefix: rhs,
                rhsSuffix: rhs)
        }
    }
}

// MARK: - Expectations

struct SimilaritiesTestsExpectations<Element: Equatable> {
    let lhsPrefix: AnySequence<Element>?
    let lhsSuffix: AnySequence<Element>?
    let rhsPrefix: AnySequence<Element>?
    let rhsSuffix: AnySequence<Element>?
    
    init<S0: Sequence, S1: Sequence, S2: Sequence, S3: Sequence>(
        lhsPrefix: S0? = nil,
        lhsSuffix: S1? = nil,
        rhsPrefix: S2? = nil,
        rhsSuffix: S3? = nil
    ) where S0.Element == Element, S1.Element == Element, S2.Element == Element, S3.Element == Element {
        self.lhsPrefix = lhsPrefix.map(AnySequence.init)
        self.lhsSuffix = lhsSuffix.map(AnySequence.init)
        self.rhsPrefix = rhsPrefix.map(AnySequence.init)
        self.rhsSuffix = rhsSuffix.map(AnySequence.init)
    }
    
    func validate<LHS: BidirectionalCollection, RHS: BidirectionalCollection>(_ similarities: Similarities<LHS, RHS>) where LHS.Element == Element {
        lhsPrefix.map({ XCTAssert($0.elementsEqual(similarities.lhsPrefix())) })
        lhsSuffix.map({ XCTAssert($0.elementsEqual(similarities.lhsSuffix())) })
        rhsPrefix.map({ XCTAssert($0.elementsEqual(similarities.rhsPrefix())) })
        rhsSuffix.map({ XCTAssert($0.elementsEqual(similarities.rhsSuffix())) })
    }
}
