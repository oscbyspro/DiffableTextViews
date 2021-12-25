//
//  PatternTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import DiffableTextViews
import Utilities

// MARK: - PatternTextStyle

#warning("WIP")
public struct PatternTextStyle<Pattern, Value>: DiffableTextStyle, Transformable where Pattern: Collection, Pattern.Element == Character, Value: RangeReplaceableCollection, Value: Equatable, Value.Element == Character {
    
    // MARK: Properties
    
    @usableFromInline var pattern: Pattern
    @usableFromInline var placeholder: Character
    @usableFromInline var visible: Bool
    
    // MARK: Initializers
    
    @inlinable public init(pattern: Pattern, placeholder: Character) {
        self.pattern = pattern
        self.placeholder = placeholder
        self.visible = true
    }
    
    // MARK: Transformations
    
    @inlinable public func hidden() -> Self {
        transforming({ $0.visible = false })
    }
    
    // MARK: Value: Parse
    
    @inlinable public func parse(snapshot: Snapshot) -> Value? {
        snapshot.reduce(into: Value()) { result, symbol in
            if symbol.nonformatting {
                result.append(symbol.character)
            }
        }
    }
    
    // MARK: Snapshot: Editable
    
    @inlinable public func snapshot(editable value: Value) -> Snapshot {
        var snapshot = Snapshot()
        var valueIndex = value.startIndex
        var patternIndex = pattern.startIndex
        
        // --------------------------------- //
        
        while patternIndex != pattern.endIndex, valueIndex != value.endIndex {
            let patternElement = pattern[patternIndex]
            pattern.formIndex(after:    &patternIndex)
            
            if patternElement == placeholder {
                let valueElement = value[valueIndex]
                value.formIndex(after:  &valueIndex)
                snapshot.append(.content(valueElement))
            } else {
                snapshot.append(.spacer(patternElement))
            }
        }
        
        // --------------------------------- //
        
        if visible, patternIndex != pattern.endIndex {
            let patternTail = pattern[patternIndex...]
            snapshot.append(contentsOf: Snapshot(String(patternTail), only: .suffix))
        }
        
        // --------------------------------- //
        
        return snapshot
    }
}
