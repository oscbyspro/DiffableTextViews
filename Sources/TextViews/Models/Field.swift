//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import struct Sequences.Walkthrough

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
    
    // MARK: Translate: To Carets
    
    #warning("Should be like configure(carets:) with a separate move(to:) method.")
    @inlinable func translate(to newValue: Carets) -> Self {
        func step(prev: Symbol, next: Symbol) -> SimilaritiesInstruction {
            if      prev == next                     { return .continue      }
            else if prev.attribute.contains(.remove) { return .continueOnLHS }
            else if next.attribute.contains(.insert) { return .continueOnRHS }
            else                                     { return .done          }
        }
        
        #warning("Think about this.")
        func inspectable(symbol: Symbol) -> Bool {
            !symbol.attribute.contains(.theme(.change))
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
        
        let nextUpperBound = position(from: carets[selection.upperBound...], to: newValue[...])
        let nextLowerBound = position(from: carets[selection], to: newValue[..<nextUpperBound])
                
        // --------------------------------- //
        
        return Field(newValue, selection: nextLowerBound ..< nextUpperBound)
    }
    
    @inlinable func translate(to newValue: Snapshot) -> Self {
        translate(to: Carets(newValue))
    }

    // MARK: Configure: Selection
    
    #warning("This should be named move to, or translate should be like this.")
    @inlinable func configure(selection newValue: Range<Carets.Index>) -> Self {
        move(to: newValue)
    }
    
    @inlinable func configure(selection newValue: Carets.Index) -> Self {
        configure(selection: newValue ..< newValue)
    }
    
    // MARK: Configure: Offsets
    
    @inlinable func configure(selection newValue: Range<Offset>) -> Self {
        configure(selection: indices(in: newValue))
    }
    
    @inlinable func configure(selection newValue: Offset) -> Self {
        configure(selection: newValue ..< newValue)
    }
    
    // MARK: Helpers: Update
    
    @inlinable func update(_ transform: (inout Field) -> Void) -> Field {
        var copy = self; transform(&copy); return copy
    }
    
    // MARK: Components: Direction
    
    @usableFromInline enum Direction {
        case forwards
        case backwards
        
        // MARK: Utilities
        
        @inlinable var opposite: Direction {
            switch self {
            case .forwards: return .backwards
            case .backwards: return .forwards
            }
        }
        
        @inlinable var step: Walkthrough<Carets>.Step {
            switch self {
            case .forwards: return .forwards
            case .backwards: return .backwards
            }
        }
    }
}

// MARK: - Move To Anchor

extension Field {
    
    // MARK: Transformations
    
    #warning("TODO.")
    @inlinable func moveInoutPositionToAnchor(_ position: Carets.Index, preference: Direction) -> Carets.Index {
        func first(in direction: Direction) -> Carets.Index? {
            switch direction {
            case .forwards:
                return carets.firstIndex(in: .stride(start: .closed(position), step: .forwards),  where: { !$0.rhs.attribute.contains(.prefix) })
            case .backwards:
                return carets.firstIndex(in: .stride(start: .closed(position), step: .backwards), where: { !$0.lhs.attribute.contains(.suffix) })
            }
        }
        
        return first(in: preference) ?? first(in: preference.opposite) ?? position
    }
}

// MARK: Move To Range

extension Field {
    
    // MARK: Transformations
    
    #warning("End with moveToAnchor with opposite preference to the direction of movement.")
    @inlinable func move(to newValue: Range<Carets.Index>) -> Field {
        func position(_ positionIn: (Range<Carets.Index>) -> Carets.Index, preference: Direction, symbol: @escaping (Carets.Element) -> Symbol) -> Carets.Index {
            let current = positionIn(selection)
            let next    = positionIn(newValue)
            
            let direction = momentum(from: current, to: next) ?? preference
            let limit: Attribute = direction == .forwards ? .suffix : .prefix
                        
            func predicate(element: Carets.Element) -> Bool {
                !symbol(element).attribute.contains(limit)
            }
            
            return carets.firstIndex(in: .stride(start: .closed(next), step: direction.step), where: predicate) ?? next
        }
        
        // --------------------------------- //
        
        var upperBound = position(\.upperBound, preference: .backwards, symbol: \.lhs)
        upperBound = moveInoutPositionToAnchor(upperBound, preference: .backwards)
        
        var lowerBound = upperBound

        if !newValue.isEmpty {
            lowerBound = position(\.lowerBound, preference:  .forwards, symbol: \.rhs)
            lowerBound = moveInoutPositionToAnchor(lowerBound, preference: .backwards)
            #warning("Not needed if position is corrected.")
//            lowerBound = min(lowerBound, upperBound)
        }
        
        // --------------------------------- //
        
        return update({ $0.selection = lowerBound ..< upperBound })
    }
    
    // MARK: Heleprs
    
    @inlinable func momentum(from first: Carets.Index, to second: Carets.Index) -> Direction? {
        if      first < second { return  .forwards }
        else if first > second { return .backwards }
        else                   { return      .none }
    }
}

// MARK: - Offsets

extension Field {
    
    // MARK: Indices: In Offsets
    
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
    
    // MARK: Path
    
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
