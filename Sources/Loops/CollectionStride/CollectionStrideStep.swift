//
//  CollectionStrideStep.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-07.
//

public struct CollectionStrideStep<Collection: Swift.Collection> {
    @usableFromInline let distance: Int
            
    // MARK: Initializers
    
    @inlinable init(_ distance: Int) {
        precondition(distance != 0)
        self.distance = distance
    }
    
    // MARK: Calculations
    
    @inlinable var forwards: Bool {
        distance > 0
    }
    
    @inlinable var backwards: Bool {
        distance < 0
    }
}

public extension CollectionStrideStep {
    // MARK: Forwards
    
    @inlinable static var forwards: Self {
        Self(+1)
    }
    
    @inlinable static func forwards(_ distance: Int) -> Self {
        Self(+distance)
    }
}

public extension CollectionStrideStep where Collection: BidirectionalCollection {
    // MARK: Backwards
    
    @inlinable static var backwards: Self {
        Self(-1)
    }
    
    @inlinable static func backwards(_ distance: Int) -> Self {
        Self(-distance)
    }
}
