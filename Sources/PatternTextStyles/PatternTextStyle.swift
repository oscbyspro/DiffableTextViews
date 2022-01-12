//
//  PatternTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import Quick
import DiffableTextViews
import Utilities

//*============================================================================*
// MARK: * PatternTextStyle
//*============================================================================*

public struct PatternTextStyle<Pattern, Value>: DiffableTextStyle, Mappable where Pattern: Collection, Pattern.Element == Character, Value: RangeReplaceableCollection, Value: Equatable, Value.Element == Character {
    @usableFromInline typealias Predicates = PatternTextStyles.Predicates<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let pattern: Pattern
    @usableFromInline let placeholder: Character
    @usableFromInline var predicates: Predicates
    @usableFromInline var visible: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(pattern: Pattern, placeholder: Character) {
        self.pattern = pattern
        self.placeholder = placeholder
        self.predicates = Predicates()
        self.visible = true
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func hidden() -> Self {
        map({ $0.visible = false })
    }
    
    @inlinable public func predicate(_ predicate: Predicate<Value>) -> Self {
        map({ $0.predicates.add(predicate) })
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Validation
    //=------------------------------------------------------------------------=
    
    @inlinable func validate<C: Collection>(_ characters: C) throws where C.Element == Character {
        let capacity = pattern.count(where: { $0 == placeholder })
        
        guard characters.count <= capacity else {
            throw Info([.mark(characters), "exceeded pattern capacity", .mark(capacity)])
        }
    }
}
