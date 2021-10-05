//
//  Loop.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-04.
//

#warning("WIP. Continue in .playground.")
#warning("Implement stride also, maybe.")
struct Loop<Base: Collection>: Sequence {
    typealias Index = Base.Index
    typealias Element = Base.Element
    
    // MARK: Storage
    
    let base: Base
    let bounds: Bounds
    let step: Step

    // MARK: Initialization
    
    @inlinable init(_ base: Base, bounds: Bounds, step: Step) {
        var bounds = bounds
        var step = step
        
        if step.backwards {
            bounds.swap()
            step.negate()
        }
                        
        self.base = base
        self.bounds = bounds
        self.step = step
    }
        
    /// Default.
    @inlinable init(_ base: Base, from start: Bound? = nil, to end: Bound? = nil, step: Step = .forwards()) {
        let bounds = Bounds(start ?? .closed(base.startIndex), end ?? .open(base.endIndex))
        self.init(base, bounds: bounds, step: step)
    }
    
    /// Originates in start and proceeds in the direction of step.
    @inlinable init(_ base: Base, origin start: Bound, step: Step = .forwards()) {
        let bounds = step.forwards ? Bounds(start, .open(base.endIndex)) : Bounds(start, .closed(base.startIndex))
 
        self.init(base, bounds: bounds, step: step.absolute())
    }
    
    @inlinable init(_ base: Base, towards end: Bound, step: Step = .forwards()) {
        let bounds = step.forwards ? Bounds(.closed(base.startIndex), end) : Bounds(.open(base.endIndex), end)
        self.init(base, bounds: bounds, step: step.absolute())
    }

    // MARK: Helpers
    
    @inlinable func makeNext() -> (Index) -> Index? {
        let offset = bounds.ascends ? step.distance : -step.distance
        
        return { index in
            base.index(index, offsetBy: offset, limitedBy: bounds.end.position)
        }
    }

    @inlinable func makeValidate() -> (Index) -> Bool {
        switch (bounds.ascends, bounds.end.open) {
        case (true,   true): return { $0 <  bounds.end.position }
        case (true,  false): return { $0 <= bounds.end.position }
        case (false,  true): return { $0 >  bounds.end.position }
        case (false, false): return { $0 >= bounds.end.position }
        }
    }
    
    // MARK: Protocol: Sequence
    
    @inlinable func makeIterator() -> AnyIterator<Element> {
        let next = makeNext()
        let validate = makeValidate()
        
        var current = bounds.start.position as Index?
        
        if bounds.start.open {
            current = current.flatMap(next)
        }
        
        print(bounds.start, bounds.end)
        
        return AnyIterator {
            guard let index = current, validate(index) else { return nil }
            
            defer { current = next(index) }
            return base[index]
        }
    }
    
    // MARK: Components
        
    struct Bound: Comparable {
        let position: Index
        let open: Bool
        
        // MARK: Initialization
        
        @inlinable init(_ position: Index, open: Bool) {
            self.position = position
            self.open = open
        }
        
        @inlinable static func open(_ position: Index) -> Self {
            Self(position, open: true)
        }
        
        @inlinable static func closed(_ position: Index) -> Self {
            Self(position, open: false)
        }
        
        // MARK: Protocol: Comparable
        
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.position < rhs.position
        }
    }
    
    struct Bounds {
        var start: Bound
        var end: Bound
        
        // MARK: Initialization
        
        @inlinable init(_ start: Bound, _ end: Bound) {
            self.start = start
            self.end = end
        }
        
        // MARK: Utilities
        
        @inlinable var ascends: Bool {
            start <= end
        }
        
        @inlinable mutating func swap() {
            Swift.swap(&start, &end)
        }
    }
     
    struct Step: Equatable {
        var distance: Int
        
        // MARK: Initialization
                
        @inlinable init(_ distance: Int) {
            precondition(distance != 0)
            self.distance = distance
        }
                
        @inlinable static func distance(_ distance: Int) -> Self {
            Self(distance)
        }
                
        @inlinable static func forwards() -> Self {
            Self(+1)
        }
        
        @inlinable static func backwards() -> Self where Base: BidirectionalCollection {
            Self(-1)
        }
        
        // MARK: Utilities
        
        @inlinable var forwards: Bool {
            distance > 0
        }
        
        @inlinable var backwards: Bool {
            distance < 0
        }
        
        @inlinable mutating func negate() {
            self.distance.negate()
        }
        
        @inlinable func absolute() -> Self {
            Self(abs(distance))
        }
    }
}
