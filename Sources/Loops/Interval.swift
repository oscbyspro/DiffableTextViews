//
//  Interval.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

public struct Interval<Element: Comparable> {
    public typealias Bound = Loops.Bound<Element>
    
    // MARK: Properties
    
    @usableFromInline let lowerBound: Bound
    @usableFromInline let upperBound: Bound
    
    // MARK: Initializers
        
    @inlinable public init(lowerBound: Bound, upperBound: Bound) {
        precondition(lowerBound <= upperBound)
        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }
    
    @inlinable public init(unchecked bounds: (Bound, Bound)) {
        self.lowerBound = bounds.0
        self.upperBound = bounds.1
    }
    
    @inlinable public init(unordered bounds: (Bound, Bound)) {
        self.lowerBound = min(bounds.0, bounds.1)
        self.upperBound = max(bounds.0, bounds.1)
    }

    // MARK: Utilities
    
    @inlinable public func contains(_ element: Element) -> Bool {
        element >= lowerBound && element <= upperBound
    }
}
