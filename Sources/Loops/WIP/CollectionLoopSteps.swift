//
//  CollectionLoopSteps.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-08.
//

public struct CollectionLoopSteps<Collection: Swift.Collection> {
    public let distance: Int
    
    // MARK: Initializers
    
    @inlinable init(unchecked distance: Int) {
        precondition(distance != .zero)
        
        self.distance = distance
    }
    
    // MARK: Calculations
    
    @inlinable public var forwards: Bool {
        distance > 0
    }
    
    @inlinable public var backwards: Bool {
        distance < 0
    }
    
    // MARK: Utilities
    
    @inlinable public func reversed() -> Self where Collection: BidirectionalCollection {
        Self(unchecked: -distance)
    }
}

public extension CollectionLoopSteps {
    // MARK: Forwards
    
    @inlinable static var forwards: Self {
        Self(unchecked: +1)
    }
    
    @inlinable static func forwards(_ distance: UInt) -> Self {
        Self(unchecked: +Int(distance))
    }
}

public extension CollectionLoopSteps where Collection: BidirectionalCollection {
    // MARK: Backwards
    
    @inlinable static var backwards: Self {
        Self(unchecked: -1)
    }
    
    @inlinable static func backwards(_ distance: UInt) -> Self {
        Self(unchecked: -Int(distance))
    }
}

public extension CollectionLoopSteps where Collection: BidirectionalCollection {
    @inlinable static func distance(_ distance: Int) -> Self {
        Self(unchecked: -Int(distance))
    }
}


#warning("...")

/*
 
 collection.stride(from: start, to: nil, step: .backwards).firstIndex(where: predicate)
 
 */


