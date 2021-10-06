//
//  Stride.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

@inlinable func stride<C: Collection>(
    through collection: C,
    from start: Bound<C.Index>? = nil,
    to end: Bound<C.Index>? = nil,
    step: Step<C> = .forwards()
) -> BasicLoop<C> {
    var start = start ?? .closed(collection.startIndex)
    var end   = end   ??     .open(collection.endIndex)
    
    if step.forwards != (start <= end) {
        swap(&start, &end)
    }
    
    return BasicLoop(collection, start: start, end: end, step: step)
}
