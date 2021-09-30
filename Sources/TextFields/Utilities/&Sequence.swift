//
//  &Sequence.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

extension Sequence {
    // MARK: Reduce
    
    @inlinable func reduce<Other: RangeReplaceableCollection>(into other: Other = Other(), map element: (Element) -> Other.Element, where include: (Element) -> Bool = { _ in true }) -> Other {
        reduce(into: other) { result, next in
            if include(next) {
                result.append(element(next))
            }
        }
    }
}
