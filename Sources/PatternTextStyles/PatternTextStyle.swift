//
//  PatternTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import Quick
import DiffableTextViews

//*============================================================================*
// MARK: * PatternTextStyle
//*============================================================================*

public struct PatternTextStyle<Pattern, Value>: DiffableTextStyle, Mappable where Pattern: Collection, Pattern.Element == Character, Value: RangeReplaceableCollection, Value: Equatable, Value.Element == Character {
    @usableFromInline typealias Format = PatternTextStyles.Format<Pattern>
    @usableFromInline typealias Predicates = PatternTextStyles.Predicates<Value>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let format: Format
    @usableFromInline var predicates: Predicates
    @usableFromInline var visible: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(pattern: Pattern, placeholder: Character) {
        self.format = Format(pattern: pattern, placeholder: placeholder)
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
}
