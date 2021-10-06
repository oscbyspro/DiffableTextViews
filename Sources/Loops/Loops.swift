//
//  Stride.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-06.
//

public extension Collection {
    // MARK: Stride Loop

    @inlinable func stride(from start: Bound<Index>? = nil, to end: Bound<Index>? = nil, step: Step<Self> = .forwards) -> StrideLoop<Self> {
        let start = start ?? (step.forwards ? .closed(startIndex) : .open(endIndex))
        let end   = end   ?? (step.forwards ? .open(endIndex) : .closed(startIndex))

        return StrideLoop(self, start: start, end: end, step: step)
    }
}


public extension Collection {
    // MARK: Sequence Loop

    @inlinable func sequence(from start: Bound<Index>? = nil, to end: Bound<Index>? = nil, step: Step<Self> = .forwards) -> StrideLoop<Self> {
        var start = start ?? .closed(startIndex)
        var end   = end   ??     .open(endIndex)

        if step.forwards != (start <= end) {
            swap(&start, &end)
        }

        return StrideLoop(self, start: start, end: end, step: step)
    }
}
