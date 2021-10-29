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
    
    // MARK: Configure: Carets
    
    @inlinable func configure(carets newValue: Carets) -> Self {
        move(to: newValue)
    }
    
    @inlinable func configure(carets newValue: Snapshot) -> Self {
        configure(carets: Carets(newValue))
    }

    // MARK: Configure: Selection
    
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
        
        // MARK: Initializers
        
        @inlinable init?(_ start: Carets.Index, to end: Carets.Index) {
            if start < end { self = .forwards }
            else if start > end { self = .backwards }
            else { return nil }
        }
        
        // MARK: Utilities
        
        @inlinable var opposite: Direction {
            switch self {
            case .forwards:  return .backwards
            case .backwards: return .forwards
            }
        }
        
        @inlinable var step: Walkthrough<Carets>.Step {
            switch self {
            case .forwards:  return .forwards
            case .backwards: return .backwards
            }
        }
        
        @inlinable var side: (Carets.Element) -> Symbol {
            switch self {
            case .forwards:  return \.rhs
            case .backwards: return \.lhs
            }
        }
    }
}

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

// MARK: Move To Carets

extension Field {
    
    #warning("This works OK.")
    @inlinable func move(to nextCarets: Carets) -> Field {
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
        
        #warning("...")
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

/*
 
 Forwards momentum, upperBound(<-):
    1. if !lhs.contains(.suffix) -> return position (collides with upperBound's preference)
    2. otherwise, find first collision towards rhs (because forwards momentum)
        a) not end: return position beyond it, carets.index(lhs: collisionIndex)
        b)  at end: return position
    3, otherwise, find first collision towards lhs
 
 */

extension Field {
    
    #warning("Retarded.")
    
    @inlinable func move(to nextSelection: Range<Carets.Index>) -> Field {
        func position(_ positionIn: (Range<Carets.Index>) -> Carets.Index, preference: Direction, predicate: (Carets.Element) -> Bool) -> Carets.Index {
            let current = positionIn(selection)
            let next = positionIn(nextSelection)
            
            let direction: Direction = .init(current, to: next) ?? preference
            let limit: Attribute = direction == .forwards ? .suffix : .prefix
            
            return carets.firstIndex(in: .stride(start: .closed(next), step: direction.step), where: predicate) ?? next
        }
        
        // --------------------------------- //
        
        #warning("It should not check like this. It should check in the direction it is going.")
        let upperBound = position(\.upperBound, preference: .backwards, predicate: { !$0.lhs.attribute.contains(.suffix) })
        var lowerBound = upperBound
        
        if !nextSelection.isEmpty {
            lowerBound = position(\.lowerBound, preference:  .forwards, predicate: { !$0.rhs.attribute.contains(.prefix) })
            lowerBound = min(lowerBound, upperBound)
        }
                
        // --------------------------------- //
        
        return update({ $0.selection = lowerBound ..< upperBound })
    }
}
