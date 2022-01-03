//
//  PatternTextStyle.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-25.
//

import DiffableTextViews

//*============================================================================*
// MARK: * PatternTextStyle
//*============================================================================*

public struct PatternTextStyle<Pattern, Value>: DiffableTextStyle where Pattern: Collection, Pattern.Element == Character, Value: RangeReplaceableCollection, Value: Equatable, Value.Element == Character {
    @usableFromInline typealias Format = PatternTextStyles.Format<Pattern>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let format: Format
    @usableFromInline var filter: Filter
    @usableFromInline var visible: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(pattern: Pattern, placeholder: Character) {
        self.format = Format(pattern: pattern, placeholder: placeholder)
        self.filter = Filter()
        self.visible = true
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Update
    //=------------------------------------------------------------------------=
    
    @inlinable public func filter(_ validation: @escaping (Character) -> Bool) -> Self {
        var result = self; result.filter.concatenate(validation); return result
    }
    
    @inlinable public func hidden() -> Self {
        var result = self; result.visible = false; return self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    @inlinable public func snapshot(editable value: Value) -> Snapshot {
        var snapshot = Snapshot()
        var valueIndex = value.startIndex
        var patternIndex = format.pattern.startIndex
        
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
        // MARK: Tail
        //=--------------------------------------=
        
        if visible, patternIndex != format.pattern.endIndex {
            snapshot.append(contentsOf: Snapshot(String(format.pattern[patternIndex...]), only: .suffix))
        }
        
        //=--------------------------------------=
        // MARK: Process Empty Value Prefix
        //=--------------------------------------=
        
        if valueIndex == value.startIndex {
            if let firstPlaceholderIndex = snapshot.firstIndex(where: { $0.character == format.placeholder }) {
                snapshot.transform(attributes: ..<firstPlaceholderIndex) { attribute in
                    attribute = .prefix
                }
            }
        }
        
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        
        return snapshot
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Merge
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
    
    //=------------------------------------------------------------------------=
    // MARK: Parse
    //=------------------------------------------------------------------------=
    
    @inlinable public func parse(snapshot: Snapshot) throws -> Value {
        var value = Value()
        
        for symbol in snapshot where symbol.is(non: .formatting) {
            try filter.validate(symbol.character)
            value.append(symbol.character)
        }
        
        try format.validate(characters: value)
        return value
    }
}
