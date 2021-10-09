//
//  Interval.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

// MARK: - Interval

public struct Interval<Element: Comparable> {
    public typealias Bound = Sequences.Bound<Element>
    
    // MARK: Properties
    
    public let min: Bound
    public let max: Bound
    
    // MARK: Initializers
    
    @inlinable public init(min: Bound, max: Bound) {
        precondition(min <= max)
        
        self.min = min
        self.max = max
    }
    
    @inlinable public init(unordered bounds: (Bound, Bound)) {
        self.min = Swift.min(bounds.0, bounds.1)
        self.max = Swift.max(bounds.0, bounds.1)
    }
    
    // MARK: Utilities
    
    @inlinable public func contains(_ element: Element) -> Bool {
        element >= min && element <= max
    }
    
    // MARK: Conversions
    
    @inlinable public func path(ascends: Bool) -> Path<Element> {
        Path(interval: self, ascends: ascends)
    }
    
    @inlinable public func path(descends: Bool) -> Path<Element> {
        Path(interval: self, descends: descends)
    }
}
