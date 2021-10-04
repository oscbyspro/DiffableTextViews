//
//  Loop.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-04.
//

struct Loop<Base: BidirectionalCollection>: Sequence {
    let base: Base
    let start: Bound
    let end: Bound
    
    // MARK: Initialization
    
    @inlinable init(_ base: Base, from start: Bound, to end: Bound) {
        self.base = base
        self.start = start
        self.end = end
    }
    
    @inlinable init(_ base: Base, instruction: Instruction) {
        self.base = base
        self.start = instruction.start(base)
        self.end = instruction.end(base)
    }
    
    // MARK: Utilities
    
    @inlinable func reversed() -> Self {
        Loop(base, from: end, to: start)
    }
    
    // MARK: Sequence

    @inlinable func makeIterator() -> Iterator {
        let next = next()
        let predicate = predicate()
        
        var current = start.position
        
        if start.open, predicate(current) {
            current = next(current)
        }
        
        return Iterator(current, next, predicate)
    }
    
    // MARK: Helpers
    
    @inlinable func next() -> (Base.Index) -> Base.Index {
        start.position < end.position ? base.index(after:) : base.index(before:)
    }
    
    @inlinable func predicate() -> (Base.Index) -> Bool {
        if start.position < end.position {
            return end.open ? { $0 < end.position } : { $0 <= end.position }
        } else {
            return end.open ? { $0 > end.position } : { $0 >= end.position }
        }
    }

    // MARK: Components
        
    struct Bound {
        let open: Bool
        let position: Base.Index
        
        // MARK: Initialization
        
        @inlinable init(open: Bool, position: Base.Index) {
            self.open = open
            self.position = position
        }
        
        // MARK: Initialization: Static
        
        @inlinable static func open(_ position: Base.Index) -> Self {
            Self(open: true, position: position)
        }
        
        @inlinable static func closed(_ position: Base.Index) -> Self {
            Self(open: false, position: position)
        }
    }
    
    struct Iterator: IteratorProtocol {
        var current: Base.Index
        let step: (Base.Index) -> Base.Index
        let predicate: (Base.Index) -> Bool
        
        // MARK: Initialization
        
        @inlinable init(_ current: Base.Index, _ step: @escaping (Base.Index) -> Base.Index, _ predicate: @escaping (Base.Index) -> Bool) {
            self.current = current
            self.step = step
            self.predicate = predicate
        }
        
        // MARK: Protocol: IteratorProtocol
        
        @inlinable mutating func next() -> Base.Index? {
            guard predicate(current) else { return nil }
            
            defer { current = step(current) }
            return  current
        }
    }
    
    struct Instruction {
        let start: (Base) -> Bound
        let end: (Base) -> Bound
        
        @inlinable init(from start: @escaping (Base) -> Bound, to end: @escaping (Base) -> Bound) {
            self.start = start
            self.end = end
        }
        
        // MARK: Initialization
        
        @inlinable static var forward: Self {
            Self(from: { .closed($0.startIndex) }, to: { .open($0.endIndex) })
        }
        
        @inlinable static var backward: Self {
            Self(from: { .open($0.endIndex) }, to: { .closed($0.startIndex) })
        }
    }
}
