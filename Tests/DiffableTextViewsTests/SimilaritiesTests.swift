//
//  SimilaritiesTests.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-13.
//

import XCTest
@testable import struct DiffableTextViews.Similarities
@testable import struct DiffableTextViews.SimilaritiesOptions

// MARK: - Inspection

final class SimilaritiesTestsOfInspection: XCTestCase {
    typealias Similarities = DiffableTextViews.Similarities<[Int], [Int]>
    typealias SimilaritiesOptions = DiffableTextViews.SimilaritiesOptions<Int>
    
    // MARK: Assertions
    
    func XCTAssert<S0: Sequence, S1: Sequence>(input: S0, output: S1) where S0.Element == S1.Element, S0.Element: Equatable {
        XCTAssertEqual(Array(input), Array(output))
    }

    // MARK: Tests
    
    func test_all() {
        let lhs = [0, 1, 2, 3, 4]
        let rhs = [0, 2, 4]
        
        // --------------------------------- //
        
        let all = SimilaritiesOptions(inspection: .all)
        let similarities = Similarities(lhs: lhs, rhs: rhs, options: all)
        
        // --------------------------------- //
        
        XCTAssert(input: similarities.lhsPrefix(), output: [0])
        XCTAssert(input: similarities.lhsSuffix(), output: [4])
        XCTAssert(input: similarities.rhsPrefix(), output: [0])
        XCTAssert(input: similarities.rhsSuffix(), output: [4])
    }
    
    func test_only() {
        let lhs = [0, 1, 2, 3, 4]
        let rhs = [0, 2, 4]
        
        // --------------------------------- //

        let evens = SimilaritiesOptions(inspection: .only({ $0 % 2 == 0 }))
        let similarities = Similarities(lhs: lhs, rhs: rhs, options: evens)
        
        // --------------------------------- //
        
        XCTAssert(input: similarities.lhsPrefix(), output: lhs)
        XCTAssert(input: similarities.lhsSuffix(), output: lhs)
        XCTAssert(input: similarities.rhsPrefix(), output: rhs)
        XCTAssert(input: similarities.rhsSuffix(), output: rhs)
    }
    
    func test_overshoots() {
        let lhs = [0, 0, 1, 0, 0, 0, 0, 1, 0, 0]
        let rhs = [1]
        
        // --------------------------------- //
        
        let ones = SimilaritiesOptions(inspection: .only({ $0 == 1 }))
        let similarities = Similarities(lhs: lhs, rhs: rhs, options: ones)
        
        // --------------------------------- //
        
        XCTAssert(input: similarities.lhsPrefix(), output: [0, 0, 1, 0, 0, 0, 0])
        XCTAssert(input: similarities.lhsSuffix(), output: [0, 0, 0, 0, 1, 0, 0])
        XCTAssert(input: similarities.rhsPrefix(), output: rhs)
        XCTAssert(input: similarities.rhsSuffix(), output: rhs)
    }
}
