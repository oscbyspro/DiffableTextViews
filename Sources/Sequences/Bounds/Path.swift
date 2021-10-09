//
//  Path.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-09.
//

// MARK: - Path

public struct Path<Element: Comparable> {
    public typealias Bound = Sequences.Bound<Element>
    
    // MARK: Properties
    
    public let start: Bound
    public let end: Bound
    
    // MARK: Initializers
    
    @inlinable public init(start: Bound, end: Bound) {
        self.start = start
        self.end = end
    }
    
    // MARK: Initializers: Interval

    @inlinable public init(interval: Interval<Element>, ascends: Bool) {
        self.start = ascends ? interval.min : interval.max
        self.end = ascends ? interval.max : interval.min
    }
    
    @inlinable public init(interval: Interval<Element>, descends: Bool) {
        self.init(interval: interval, ascends: !descends)
    }
    
    @inlinable public init(interval: Interval<Element>, stride distance: Int) {
        self.init(interval: interval, ascends: distance >= 0)
    }
        
    // MARK: Conversions
    
    @inlinable public func interval() -> Interval<Element> {
        Interval(min: min(start, end), max: max(start, end))
    }
}
