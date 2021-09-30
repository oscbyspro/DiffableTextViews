//
//  PlaceholderFormatScheme.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-30.
//

struct PlaceholderFormatScheme<Content: RangeReplaceableCollection>: ParsableFormatScheme where Content.Element: Equatable {
    let pattern: Content
    let placeholder: Content.Element
    var transparent: Bool = false
    
    // MARK: Protocol: FormatScheme
    
    func format(_ content: Content) -> Result<Content, Never> {
        var output = Content()
        
        var contentIndex = content.startIndex
        var patternIndex = pattern.startIndex

        while contentIndex < content.endIndex, patternIndex < pattern.endIndex {
            var element = pattern[patternIndex]
            patternIndex = pattern.index(after: patternIndex)
            
            if element == placeholder {
                element = content[contentIndex]
                contentIndex = content.index(after: contentIndex)
            }
            
            output.append(element)
        }
        
        if transparent {
            output.append(contentsOf: pattern[patternIndex...])
        }
        
        return .success(output)
    }
    
    // MARK: Protocol: ParsableFormatScheme
    
    var inverse: InversePlaceholderFormatScheme<Content> {
        InversePlaceholderFormatScheme(pattern: pattern, placeholder: placeholder, transparent: transparent)
    }
}

// MARK: -

struct InversePlaceholderFormatScheme<Content: RangeReplaceableCollection>: ParsableFormatScheme where Content.Element: Equatable {
    let pattern: Content
    let placeholder: Content.Element
    var transparent: Bool = false
        
    // MARK: Protocol: FormatScheme
    
    func format(_ content: Content) -> Result<Content, Never> {
        var output = Content()
        
        var contentIndex = content.startIndex
        var patternIndex = pattern.startIndex
        
        while contentIndex < content.endIndex, patternIndex < pattern.endIndex {
            if pattern[patternIndex] == placeholder {
                let element = content[contentIndex]
                
                if transparent {
                    guard element != placeholder else { break }
                }
                
                output.append(element)
            }
            
            contentIndex = content.index(after: contentIndex)
            patternIndex = pattern.index(after: patternIndex)
        }
        
        return .success(output)
    }

    // MARK: Protocol: ParsableFormatScheme
    
    var inverse: PlaceholderFormatScheme<Content> {
        PlaceholderFormatScheme(pattern: pattern, placeholder: placeholder, transparent: transparent)
    }
}
