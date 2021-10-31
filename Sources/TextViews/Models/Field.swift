//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

// MARK: - Field

@usableFromInline struct Field<Layout: TextViews.Layout> {
    @usableFromInline typealias Carets = TextViews.Carets<Layout>
    @usableFromInline typealias Offset = TextViews.Offset<Layout>
    
    // MARK: Properties
    
    @usableFromInline let carets: Carets
    @usableFromInline var selection: Range<Carets.Index>
    
    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.carets = Carets(snapshot)
        self.selection = carets.lastIndex ..< carets.lastIndex
    }
    
    @inlinable init(_ field: Carets, selection: Range<Carets.Index>) {
        self.carets = field
        self.selection = selection
    }
    
    // MARK: Configure: Carets
    
    @inlinable func configure(carets newValue: Carets) -> Self {
        move(to: newValue).moveToAttributes()
    }
    
    @inlinable func configure(carets newValue: Snapshot) -> Self {
        configure(carets: Carets(newValue))
    }

    // MARK: Configure: Selection
    
    @inlinable func configure(selection newValue: Range<Carets.Index>, intent: Direction?) -> Self {
        move(to: newValue, intent: intent).moveToAttributes()
    }
    
    @inlinable func configure(selection newValue: Carets.Index, intent: Direction?) -> Self {
        configure(selection: newValue ..< newValue, intent: intent)
    }
    
    // MARK: Configure: Offsets
    
    @inlinable func configure(selection newValue: Range<Offset>, intent: Direction?) -> Self {
        configure(selection: indices(in: newValue), intent: intent)
    }
    
    @inlinable func configure(selection newValue: Offset, intent: Direction?) -> Self {
        configure(selection: newValue ..< newValue, intent: intent)
    }
    
    // MARK: Helpers: Update
    
    @inlinable func update(_ transform: (inout Field) -> Void) -> Field {
        var copy = self; transform(&copy); return copy
    }
}

// - MARK: Looks

extension Field {
    
    @inlinable func look(_ start: Carets.Index, direction: Direction) -> Carets.Index {
        direction == .forwards ? lookahead(start) : lookbehind(start)
    }

    @inlinable func lookahead(_ start: Carets.Index) -> Carets.Index {
        func predicate(element: Carets.Element) -> Bool {
            !element.rhs.attribute.contains(.prefix)
        }
        
        return carets[start...].firstIndex(where: predicate) ?? carets.lastIndex
    }
    
    @inlinable func lookbehind(_ start: Carets.Index) -> Carets.Index {
        func predicate(element: Carets.Element) -> Bool {
            !element.lhs.attribute.contains(.suffix)
        }
        
        return carets[...start].lastIndex(where: predicate) ?? carets.firstIndex
    }
}

// MARK: - Offsets

extension Field {
    
    // MARK: Indices In Offsets
    
    @inlinable func indices(in offsets: Range<Offset>) -> Range<Carets.Index> {
        var indices = [Carets.Index]()
        indices.reserveCapacity(5)
        indices.append(contentsOf: [carets.firstIndex,         carets.endIndex])
        indices.append(contentsOf: [selection.lowerBound, selection.upperBound])
        
        // --------------------------------- //
    
        func index(at offset: Offset) -> Carets.Index {
            let shortestPath = indices.map({ Path($0, offset: offset) }).min()!
            return carets.index(start: shortestPath.origin, offset: shortestPath.offset)
        }
        
        // --------------------------------- //
        
        let lowerBound = index(at: offsets.lowerBound)
        indices.append(lowerBound)
        let upperBound = index(at: offsets.upperBound)
                        
        // --------------------------------- //
        
        return lowerBound ..< upperBound
    }
    
    // MARK: Helpers, Path
    
    @usableFromInline struct Path: Comparable {
        
        // MARK: Properties
        
        @usableFromInline let origin: Carets.Index
        @usableFromInline let offset: Offset
        
        // MARK: Initializers
        
        @inlinable init(_ origin: Carets.Index, offset: Offset) {
            self.origin = origin
            self.offset = offset
        }
        
        // MARK: Comparisons
        
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            abs(lhs.offset.distance) < abs(rhs.offset.distance)
        }
    }
}

// MARK: - Move To Carets

extension Field {
    
    // MARK: Movements
    
    @inlinable func move(to nextCarets: Carets) -> Field {
        func step(prev: Symbol, next: Symbol) -> SimilaritiesInstruction {
            if prev == next                          { return .continue      }
            else if prev.attribute.contains(.remove) { return .continueOnLHS }
            else if next.attribute.contains(.insert) { return .continueOnRHS }
            else                                     { return .done          }
        }
        
        func inspectable(symbol: Symbol) -> Bool {
            !symbol.attribute.contains(.composite(.change))
        }
        
        // --------------------------------- //
        
        let options = SimilaritiesOptions<Symbol>
            .produce(.overshoot)
            .compare(.instruction(step))
            .inspect(.only(inspectable))

        func position(from current: Carets.SubSequence, to next: Carets.SubSequence) -> Carets.Index {
            Similarities(in: current.lazy.map(\.rhs), and: next.lazy.map(\.rhs), with: options).rhsSuffix().startIndex
        }
        
        // --------------------------------- //
        
        let nextUpperBound = position(from: carets[selection.upperBound...], to: nextCarets[...])
        let nextLowerBound = position(from: carets[selection], to: nextCarets[..<nextUpperBound])
                
        // --------------------------------- //
        
        return Field(nextCarets, selection: nextLowerBound ..< nextUpperBound)
    }
}

// MARK: Move To Selection

extension Field {
    
    // MARK: Movements
    
    @inlinable func move(to nextSelection: Range<Carets.Index>, intent: Direction?) -> Field {
        func move(_ start: Carets.Index, preference: Direction) -> Carets.Index {
            if preferable(start, by: preference) { return start }
            
            let direction = intent ?? preference
            let next = look(start, direction: direction)
                   
            return position(target: next, side: direction, preference: preference)
        }
        
        let upperBound = move(nextSelection.upperBound, preference: .backwards)
        var lowerBound = upperBound

        if !nextSelection.isEmpty {
            lowerBound = move(nextSelection.lowerBound, preference:  .forwards)
            lowerBound = min(lowerBound, upperBound)
        }

        return update({ $0.selection = lowerBound ..< upperBound })
    }
    
    // MARK: Helpers
    
    @inlinable func preferable(_ position: Carets.Index, by preference: Direction) -> Bool {
        let element = carets[position]
        
        switch preference {
        case .forwards:  return !element.rhs.attribute.contains(.prefix)
        case .backwards: return !element.lhs.attribute.contains(.suffix)
        }
    }
    
    @inlinable func position(target position: Carets.Index, side: Direction, preference: Direction) -> Carets.Index {
        if side == preference { return position }
        
        switch side {
        case .forwards:  return position < carets.lastIndex  ? carets.index(after:  position) : position
        case .backwards: return position > carets.firstIndex ? carets.index(before: position) : position
        }
    }
}

// MARK: Move To Attributes

extension Field {
    
    // MARK: Movements
    
    @inlinable func moveToAttributes() -> Field {
        func move(_ position: Carets.Index, preference: Direction) -> Carets.Index {
            let direction = directionOfAttributes(at: position)
            return look(position, direction: direction ?? preference)
        }
        
        let upperBound = move(selection.upperBound, preference: .backwards)
        var lowerBound = upperBound

        if !selection.isEmpty {
            lowerBound = move(selection.lowerBound, preference:  .forwards)
            lowerBound = min(lowerBound, upperBound)
        }
        
        return update({ $0.selection = lowerBound ..< upperBound })
    }
    
    // MARK: Direction Of Attributes
    
    @inlinable func directionOfAttributes(at position: Carets.Index) -> Direction? {
        let element = carets[position]
        
        func containsOnBothSides(_ attribute: Attribute) -> Bool {
            element.lhs.attribute.contains(attribute) && element.rhs.attribute.contains(attribute)
        }
        
        let forwards  = containsOnBothSides(.prefix)
        let backwards = containsOnBothSides(.suffix)
        
        if forwards == backwards { return nil }
        return forwards ? .forwards : .backwards
    }
}
