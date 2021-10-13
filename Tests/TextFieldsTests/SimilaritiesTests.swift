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
    
    //  MARK: Helpers
    
    func one(element: Int) -> Bool {
        element == 1
    }
        
    func even(element: Int) -> Bool {
        element % 2 == 0
    }
    
    func odd(element: Int) -> Bool {
        element % 2 == 1
    }
    
    // MARK: Tests
            
    func test_collectionsAreSimilarToThemselves() {
        let collection = Array(0...3)
        let similarities = Similarities(in: collection, and: collection)
        
        XCTAssert(collection.elementsEqual(similarities.lhsPrefix()))
        XCTAssert(collection.elementsEqual(similarities.rhsPrefix()))
        XCTAssert(collection.elementsEqual(similarities.lhsSuffix()))
        XCTAssert(collection.elementsEqual(similarities.rhsSuffix()))
    }
    
    func test_inspection() {
        let collection = Array(0...6)
        let evens = collection.filter(even)
        
        let options = Options.inspect(.only(even))
        let similarities = Similarities(in: collection, and: evens, with: options)
        
        XCTAssert(collection.elementsEqual(similarities.lhsPrefix()))
        XCTAssert(collection.elementsEqual(similarities.lhsSuffix()))
        XCTAssert(     evens.elementsEqual(similarities.rhsPrefix()))
        XCTAssert(     evens.elementsEqual(similarities.rhsSuffix()))
    }
        
    func test_wrapper() {
        let collection = [1, 0, 0, 0, 1]
        let ones       = [1]
        
        let options = Options.inspect(.only(one)).produce(.wrapper)
        let similarities = Similarities(in: collection, and: ones, with: options)

        XCTAssert(ones.elementsEqual(similarities.lhsPrefix()))
        XCTAssert(ones.elementsEqual(similarities.lhsSuffix()))
        XCTAssert(ones.elementsEqual(similarities.rhsPrefix()))
        XCTAssert(ones.elementsEqual(similarities.rhsSuffix()))
    }
    
    func test_overshoot() {
        let collection = [1, 0, 0, 0, 1]
        let ones       = [1]
        
        let options = Options.inspect(.only(one)).produce(.overshoot)
        let similarities = Similarities(in: collection, and: ones, with: options)
    
        XCTAssert([1, 0, 0, 0].elementsEqual(similarities.lhsPrefix()))
        XCTAssert([0, 0, 0, 1].elementsEqual(similarities.lhsSuffix()))
        XCTAssert(        ones.elementsEqual(similarities.rhsPrefix()))
        XCTAssert(        ones.elementsEqual(similarities.rhsSuffix()))
    }
}
