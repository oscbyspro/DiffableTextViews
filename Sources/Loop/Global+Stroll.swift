//
//  Stroll.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

@inlinable public func stroll<C: Collection>(
    through collection: C,
    from start: Bound<C.Index>? = nil,
    to end: Bound<C.Index>? = nil,
    step: Step<C> = .forwards()
) -> BasicLoop<C> {
    let start = start ?? (step.forwards ? .closed(collection.startIndex) : .open(collection.endIndex))
    let end   = end   ?? (step.forwards ? .open(collection.endIndex) : .closed(collection.startIndex))
    
    return BasicLoop(collection, start: start, end: end, step: step)
}
