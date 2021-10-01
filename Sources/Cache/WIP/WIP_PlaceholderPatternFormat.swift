//
//  WIP_PlaceholderPatternFormat.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-01.
//

struct WIP_PlaceholderPatternFormat<Pattern: Collection, Input: Collection, Output: RangeReplaceableCollection> {
    let pattern: Pattern
    let element: (Pattern.Element) -> Output.Element
    let placeholder: (Pattern.Element) -> Bool
    let replacement: (Pattern.Element, Input.Element) -> Output.Element
    let transparent: Bool
    
    @usableFromInline func format(_ value: Input) -> Result<Output, Never> {
        var result = Output()
        
        var indexInValue = value.startIndex
        var indexInPattern = pattern.startIndex

        while indexInValue < value.endIndex, indexInPattern < pattern.endIndex {
            let elementInPattern = pattern[indexInPattern]
            indexInPattern = pattern.index(after: indexInPattern)
            
            if placeholder(elementInPattern) {
                let elementInValue = value[indexInValue]
                indexInValue = value.index(after: indexInValue)
                result.append(replacement(elementInPattern, elementInValue))
            } else {
                result.append(element(elementInPattern))
            }
        }
        
        if transparent {
            result.append(contentsOf: pattern[indexInPattern...].map(element))
        }
        
        return .success(result)
    }
}
