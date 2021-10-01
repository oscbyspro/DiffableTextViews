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

struct WIP_PlaceholderPatternFormat<Pattern: Sequence, Input: Sequence, Output: RangeReplaceableCollection> {
    let pattern: Pattern
    let content: (Pattern.Element) -> Output.Element
    let placeholder: (Pattern.Element) -> Bool
    let replacement: (Pattern.Element, Input.Element) -> Output.Element
    let transparent: Bool
    
    func format(_ input: Input) -> Result<Output, Never> {
        var output = Output()
        
        var inputIterator = input.makeIterator()
        var patternIterator = pattern.makeIterator()
        
        var inputElement = inputIterator.next()
        var patternElement = patternIterator.next()
        
        while inputElement != nil, patternElement != nil {
            if !placeholder(patternElement!) {
                output.append(content(patternElement!))
            } else {
                output.append(replacement(patternElement!, inputElement!))
                inputElement = inputIterator.next()
            }
            
            patternElement = patternIterator.next()
        }
        
        if transparent {
            while true {
                patternElement = patternIterator.next()
                guard patternElement != nil else { break }
                output.append(content(patternElement!))
            }
        }
        
        return .success(output)
    }
}
