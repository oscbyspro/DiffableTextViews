//
//  Replace.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-05.
//

//*============================================================================*
// MARK: * RangeReplaceableCollection
//*============================================================================*

public extension RangeReplaceableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Replace
    //=------------------------------------------------------------------------=
    
    @inlinable func replacing<C: Collection>(_ range: Range<Index>, with elements: C) -> Self where C.Element == Element {
        var result = self; result.replaceSubrange(range, with: elements); return result
    }
}

