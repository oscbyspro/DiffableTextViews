//
//  PlaceholderPatternFormatter.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-01.
//

//@usableFromInline struct PlaceholderPatternFormatter<Base: RangeReplaceableCollection>: BidirectionalFormatter where Base.Element: Equatable {
//    @usableFromInline let pattern: Base
//    @usableFromInline let placeholder: Base.Element
//    @usableFromInline let transparent: Bool
//    
//    // MARK: Initialization
//
//    @inlinable init(pattern: Base, placeholder: Base.Element, transparent: Bool = false) {
//        self.pattern = pattern
//        self.placeholder = placeholder
//        self.transparent = transparent
//    }
//
//    // MARK: Protocol: Formatter
//
//    @usableFromInline func format(_ value: Base) -> Result<Base, Never> {
//        var output = Base()
//
//        var valueIndex = value.startIndex
//        var patternIndex = pattern.startIndex
//
//        while valueIndex < value.endIndex, patternIndex < pattern.endIndex {
//            var element = pattern[patternIndex]
//            patternIndex = pattern.index(after: patternIndex)
//
//            if element == placeholder {
//                element = value[valueIndex]
//                valueIndex = value.index(after: valueIndex)
//            }
//
//            output.append(element)
//        }
//
//        if transparent {
//            output.append(contentsOf: pattern[patternIndex...])
//        }
//
//        return .success(output)
//    }
//    
//    // MARK: Protocol: BidirectionalFormatter
//    
//    @usableFromInline func parse(_ value: Base) -> Result<Base, Never> {
//        var output = Base()
//
//        var valueIndex = value.startIndex
//        var patternIndex = pattern.startIndex
//
//        while valueIndex < value.endIndex, patternIndex < pattern.endIndex {
//            if pattern[patternIndex] == placeholder {
//                let element = value[valueIndex]
//
//                if transparent {
//                    guard element != placeholder else { break }
//                }
//
//                output.append(element)
//            }
//
//            valueIndex = value.index(after: valueIndex)
//            patternIndex = pattern.index(after: patternIndex)
//        }
//
//        return .success(output)
//    }
//}
