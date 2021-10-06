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

        self.distance = distance
    }
    
    // MARK: Initializers: Public
 
    @inlinable public static var forwards: Self {
        .forwards(1)
    }
    
    @inlinable public static func forwards(_ distance: Int = 1) -> Self {
        precondition(distance > 0)
        
        return Self(+distance)
    }
}

extension Step where Base: BidirectionalCollection {
    @inlinable public static var backwards: Self {
        .backwards(1)
    }
    
    @inlinable public static func backwards(_ distance: Int = 1) -> Self {
        precondition(distance > 0)
        
        return Self(-distance)
    }
    
    @inlinable public static func distance(_ distance: Int) -> Self {
        precondition(distance != 0)

        return Self(+distance)
    }
}
