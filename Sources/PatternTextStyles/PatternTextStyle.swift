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

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Snapshot
//=----------------------------------------------------------------------------=

extension PatternTextStyle {

    //=------------------------------------------------------------------------=
    // MARK: Editable
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(editable value: Value) -> Snapshot {
        var snapshot = Snapshot()
        var valueIndex = value.startIndex
        var patternIndex = format.pattern.startIndex
        
        //=--------------------------------------=
        // MARK: Prefix Up To First Placeholder
        //=--------------------------------------=
        
        while patternIndex != format.pattern.endIndex {
            let patternElement = format.pattern[patternIndex]
            guard patternElement != format.placeholder else { break }
            format.pattern.formIndex(after: &patternIndex)
            snapshot.append(.prefix(patternElement))
        }
        
        //=--------------------------------------=
        // MARK: Body
        //=--------------------------------------=
        
        while patternIndex != format.pattern.endIndex, valueIndex != value.endIndex {
            let patternElement = format.pattern[patternIndex]
            format.pattern.formIndex(after:    &patternIndex)
            
            if patternElement == format.placeholder {
                let valueElement = value[valueIndex]
                value.formIndex(after:  &valueIndex)
                snapshot.append(.content(valueElement))
            } else {
                snapshot.append(.spacer(patternElement))
            }
        }
        
        //=--------------------------------------=
        // MARK: Remainders
        //=--------------------------------------=
        
        if visible, patternIndex != format.pattern.endIndex {
            snapshot.append(contentsOf: Snapshot(String(format.pattern[patternIndex...]), only: .suffix))
        }
        
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        
        return snapshot
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Merge
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
        
    //=------------------------------------------------------------------------=
    // MARK: Input
    //=------------------------------------------------------------------------=
    
    @inlinable public func merge(snapshot: Snapshot, with content: Snapshot, in range: Range<Snapshot.Index>) throws -> Snapshot {
        
        //=--------------------------------------=
        // MARK: Input
        //=--------------------------------------=
        
        var proposal = snapshot
        proposal.replaceSubrange(range, with: content)
        
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        
        let value = try parse(snapshot: proposal)
        
        //=--------------------------------------=
        // MARK: Continue
        //=--------------------------------------=
        
        return self.snapshot(editable: value)
    }
}

//=----------------------------------------------------------------------------=
// MARK: PatternTextStyle - Parse
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Value
    //=------------------------------------------------------------------------=
    
    @inlinable public func parse(snapshot: Snapshot) throws -> Value {
        
        //=--------------------------------------=
        // MARK: Value
        //=--------------------------------------=
        
        let value = Value(snapshot
            .lazy
            .filter({ !$0.attribute.contains(.formatting) })
            .map(\.character))
                          
        //=--------------------------------------=
        // MARK: Validation
        //=--------------------------------------=
        
        try format.validate(value)
        try predicates.validate(value)
        
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        
        return value
    }
}
