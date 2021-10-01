//
//  PlaceholderFormat.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-30.
//

@usableFromInline struct PlaceholderPatternFormat<Base: RangeReplaceableCollection>: ParsableFormat where Base.Element: Equatable {
    @usableFromInline let pattern: Base
    @usableFromInline let placeholder: Base.Element
    @usableFromInline var transparent: Bool
    
    // MARK: Initialization
    
    @inlinable init(pattern: Base, placeholder: Base.Element, transparent: Bool = false) {
        self.pattern = pattern
        self.placeholder = placeholder
        self.transparent = transparent
    }
    
    // MARK: Protocol: Format
    
    @usableFromInline func format(_ value: Base) -> Result<Base, Never> {
        var output = Base()
        
        var valueIndex = value.startIndex
        var patternIndex = pattern.startIndex

        while valueIndex < value.endIndex, patternIndex < pattern.endIndex {
            var element = pattern[patternIndex]
            patternIndex = pattern.index(after: patternIndex)
            
            if element == placeholder {
                element = value[valueIndex]
                valueIndex = value.index(after: valueIndex)
            }
            
            output.append(element)
        }
        
        if transparent {
            output.append(contentsOf: pattern[patternIndex...])
        }
        
        return .success(output)
    }
    
    // MARK: Protocol: ParsableFormat
    
    @inlinable var parser: InversePlaceholderPatternFormat<Base> {
        InversePlaceholderPatternFormat(pattern: pattern, placeholder: placeholder, transparent: transparent)
    }
}

// MARK: -

@usableFromInline struct InversePlaceholderPatternFormat<Base: RangeReplaceableCollection>: ParsableFormat where Base.Element: Equatable {
    @usableFromInline let pattern: Base
    @usableFromInline let placeholder: Base.Element
    @usableFromInline var transparent: Bool = false
    
    // MARK: Initialization
    
    @inlinable init(pattern: Base, placeholder: Base.Element, transparent: Bool = false) {
        self.pattern = pattern
        self.placeholder = placeholder
        self.transparent = transparent
    }
        
    // MARK: Protocol: Format
    
    @usableFromInline func format(_ value: Base) -> Result<Base, Never> {
        var output = Base()
        
        var valueIndex = value.startIndex
        var patternIndex = pattern.startIndex
        
        while valueIndex < value.endIndex, patternIndex < pattern.endIndex {
            if pattern[patternIndex] == placeholder {
                let element = value[valueIndex]
                
                if transparent {
                    guard element != placeholder else { break }
                }
                
                output.append(element)
            }
            
            valueIndex = value.index(after: valueIndex)
            patternIndex = pattern.index(after: patternIndex)
        }
        
        return .success(output)
    }

    // MARK: Protocol: ParsableFormat
    
    @inlinable var parser: PlaceholderPatternFormat<Base> {
        PlaceholderPatternFormat(pattern: pattern, placeholder: placeholder, transparent: transparent)
    }
}

#warning("WIP")

struct WIP_PlaceholderPatternFormat<Pattern: Collection, Input: Collection, Output: RangeReplaceableCollection> {
    let pattern: Pattern
    let content: (Pattern.Element) -> Output.Element
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
                result.append(content(elementInPattern))
            }
        }
        
        if transparent {
            result.append(contentsOf: pattern[indexInPattern...].view(content))
        }
        
        return .success(result)
    }
}
