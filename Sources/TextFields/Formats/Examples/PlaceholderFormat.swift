//
//  PlaceholderFormat.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-30.
//

struct PlaceholderFormat<Base: RangeReplaceableCollection>: ParsableFormat where Base.Element: Equatable {
    let pattern: Base
    let placeholder: Base.Element
    var transparent: Bool = false
    
    // MARK: Protocol: Format
    
    func format(_ value: Base) -> Result<Base, Never> {
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
    
    @inlinable var inverse: InversePlaceholderFormat<Base> {
        InversePlaceholderFormat(pattern: pattern, placeholder: placeholder, transparent: transparent)
    }
}

// MARK: -

struct InversePlaceholderFormat<Base: RangeReplaceableCollection>: ParsableFormat where Base.Element: Equatable {
    let pattern: Base
    let placeholder: Base.Element
    var transparent: Bool = false
        
    // MARK: Protocol: Format
    
    func format(_ value: Base) -> Result<Base, Never> {
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
    
    @inlinable var inverse: PlaceholderFormat<Base> {
        PlaceholderFormat(pattern: pattern, placeholder: placeholder, transparent: transparent)
    }
}
