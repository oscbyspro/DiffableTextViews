//
//  Step.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

public struct Step<Base: Collection>: Equatable {
    // MARK: Properties
    
    public let distance: Int
    
    // MARK: Calculations
    
    @inlinable var forwards: Bool {
        distance > 0
    }
    
    @inlinable var backwards: Bool {
        distance < 0
    }
    
    // MARK: Initializers

    @inlinable init(_ distance: Int) {
        precondition(distance != 0)
        
        self.distance = distance
    }
    
    // MARK: Initializers: Public
            
    @inlinable public static func distance(_ distance: Int) -> Self {
        Self(distance)
    }
    
    @inlinable public static func forwards() -> Self {
        Self(+1)
    }
    
    @inlinable public static func backwards() -> Self {
        Self(-1)
    }
}
