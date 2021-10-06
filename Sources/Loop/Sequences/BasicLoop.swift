//
//  BasicLoop.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

public struct BasicLoop<Base: Collection>: Sequence {
    public typealias Element = Base.Element
    public typealias Index = Base.Index
    public typealias Bound = Loop.Bound<Index>
    public typealias Step = Loop.Step<Base>
    
    // MARK: Properties
    
    @usableFromInline let base: Base
    @usableFromInline let start: Bound
    @usableFromInline let end: Bound
    @usableFromInline let step: Step
    
    // MARK: Initializers
        
    @inlinable public init(_ base: Base, start: Bound, end: Bound, step: Step) {
        self.base = base
        self.start = start
        self.end = end
        self.step = step
    }
    
    // MARK: Helpers
    
    @inlinable func makeIndexIterator() -> AnyIterator<Index> {
        IndexLoop(base, start: start, end: end, step: step).makeIterator()
    }
    
    // MARK: Iterators
    
    @inlinable public func makeIterator() -> AnyIterator<Element> {
        let indexIterator = makeIndexIterator()
        
        return AnyIterator {
            guard let index = indexIterator.next() else { return nil }

            return base[index]
        }
    }
}
