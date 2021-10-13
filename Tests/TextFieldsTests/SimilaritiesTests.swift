//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-13.
//

import XCTest
@testable import struct TextFields.Similarities
@testable import struct TextFields.SimilaritiesOptions

// MARK: - SimilaritiesTests

final class SimilaritiesTests: XCTestCase {
    typealias Options<Element> = SimilaritiesOptions<Element>
    
    // MARK: Tests
        
    func test_collectionsAreSimilarToThemselves() {
        let collection = Array(0...9)
        let expectation = collection
        
        let similarities = Similarities(in: collection, and: collection)
        
        XCTAssert(expectation.elementsEqual(similarities.lhsPrefix()))
        XCTAssert(expectation.elementsEqual(similarities.rhsPrefix()))
        XCTAssert(expectation.elementsEqual(similarities.lhsSuffix()))
        XCTAssert(expectation.elementsEqual(similarities.rhsSuffix()))
    }
    
    func test_inspection() {
        func even(element: Int) -> Bool {
            element.isMultiple(of: 2)
        }
        
        let collection = Array(0...8)
        let evens = collection.filter(even)
        
        let options = Options.inspect(.only(even))
        let similarities = Similarities(in: collection, and: evens, with: options)
        
        XCTAssert(evens.elementsEqual(similarities.rhsPrefix()))
        XCTAssert(evens.elementsEqual(similarities.rhsSuffix()))
        
        XCTAssert(collection.elementsEqual(similarities.lhsPrefix()))
        XCTAssert(collection.elementsEqual(similarities.lhsSuffix()))
    }
        
    func test_wrapper() {
        let collection = [1, 0, 0, 0, 1]
        let single     = [1]
        
        let options = Options.inspect(.only({ $0 == 1 })).produce(.wrapper)
        let similarities = Similarities(in: collection, and: single, with: options)

        XCTAssert(single.elementsEqual(similarities.lhsPrefix()))
        XCTAssert(single.elementsEqual(similarities.lhsSuffix()))
    }
    
    func test_overshoot() {
        let collection = [1, 0, 0, 0, 1]
        let single     = [1]
        
        let options = Options.inspect(.only({ $0 == 1 })).produce(.overshoot)
        let similarities = Similarities(in: collection, and: single, with: options)
    
        XCTAssert([1, 0, 0, 0].elementsEqual(similarities.lhsPrefix()))
        XCTAssert([0, 0, 0, 1].elementsEqual(similarities.lhsSuffix()))
    }
}
