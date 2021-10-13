//
//  File.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-13.
//

import XCTest
@testable import struct TextFields.Similarities
@testable import struct TextFields.SimilaritiesOptions
import TextFields

// MARK: - SimilaritiesTests

final class SimilaritiesTests: XCTestCase {
    typealias Options<Element> = SimilaritiesOptions<Element>
    
    // MARK: Tests
    
    func test_inspection() {
        func even(element: Int) -> Bool {
            element.isMultiple(of: 2)
        }
        
        let collection = Array(0...8)
        let evens = collection.filter(even(element:))
        let options = Options.inspect(.only(where: even(element:)))
        let similarities = Similarities(in: collection, and: evens, with: options)
        
        XCTAssert(evens.elementsEqual(similarities.rhsPrefix()))
        XCTAssert(evens.elementsEqual(similarities.rhsSuffix()))
        XCTAssert(collection.elementsEqual(similarities.lhsPrefix()))
        XCTAssert(collection.elementsEqual(similarities.lhsSuffix()))
    }
    
    func test_collectionsAreSimilarToThemselves() {
        let collection = Array(0...9)
        let similarities = Similarities(in: collection, and: collection)
        
        XCTAssert(collection.elementsEqual(similarities.lhsPrefix()))
        XCTAssert(collection.elementsEqual(similarities.rhsPrefix()))
        XCTAssert(collection.elementsEqual(similarities.lhsSuffix()))
        XCTAssert(collection.elementsEqual(similarities.rhsSuffix()))
    }
}
