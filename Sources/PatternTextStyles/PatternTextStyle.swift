//
//  PatternTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import DiffableTextViews
import Utilities

// MARK: - PatternTextStyle

public struct PatternTextStyle<Pattern, Value>: DiffableTextStyle, Transformable where Pattern: Collection, Pattern.Element == Character, Value: RangeReplaceableCollection, Value: Equatable, Value.Element == Character {
    
    // MARK: Properties
    
    @usableFromInline let pattern: Pattern
    @usableFromInline let placeholder: Character
    @usableFromInline var filter: (Character) -> Bool
    @usableFromInline var visible: Bool
    
    // MARK: Initializers
    
    @inlinable public init(pattern: Pattern, placeholder: Character) {
        self.pattern = pattern
        self.placeholder = placeholder
        self.filter = { _ in true }
        self.visible = true
    }
    
    // MARK: Transformations
    
    @inlinable public func hidden() -> Self {
        transforming({ $0.visible = false })
    }
    
    @inlinable public func filter(_ filter: @escaping (Character) -> Bool) -> Self {
        transforming({ $0.filter = filter })
    }
    
    // MARK: Validation
    
    @inlinable func capacity() -> Int {
        var count = 0; for element in pattern where element == placeholder { count += 1 }; return count
    }
    
    // MARK: Parse
    
    @inlinable public func parse(snapshot: Snapshot) throws -> Value {
        var value = Value()
        var count = 0
        
        for symbol in snapshot where symbol.nonformatting {
            #warning("Make a separate filter model.")
            guard filter(symbol.character) else {
                throw .cancellation(reason: "Character '\(symbol.character)' is invalid.")
            }
            
            value.append(symbol.character)
            count += 1
        }
        
        guard count <= capacity() else {
            throw .cancellation(reason: "Number of characters exceeds pattern capacity.")
        }
        
        return value
    }
    
    // MARK: Merge
    
    @inlinable public func merge(snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) throws -> Snapshot {
        let proposal = snapshot.replacing(range, with: content)
        let value = try parse(snapshot: proposal)
        return self.snapshot(editable: value)
    }
    
    // MARK: Editable
    
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
            snapshot.append(contentsOf: Snapshot(String(pattern[patternIndex...]), only: .suffix))
        }
        
        // --------------------------------- //
        
        if valueIndex == value.startIndex {
            if let firstPlaceholderIndex = snapshot.firstIndex(where: { symbol in symbol.character == placeholder }) {
                snapshot.transform(attributes: ..<firstPlaceholderIndex, with: { attribute in attribute = .prefix })
            }
        }
        
        // --------------------------------- //
        
        return snapshot
    }
}
