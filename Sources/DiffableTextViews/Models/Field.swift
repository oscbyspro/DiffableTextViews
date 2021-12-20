//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

import protocol Utilities.Transformable

// MARK: - Field

@usableFromInline struct Field<Scheme: DiffableTextViews.Scheme>: Transformable {
    @usableFromInline typealias Carets = DiffableTextViews.Carets<Scheme>
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>
    
    // MARK: Properties
    
    @usableFromInline let carets: Carets
    @usableFromInline var selection: Range<Carets.Index>

    // MARK: Initializers
    
    @inlinable init(_ snapshot: Snapshot = Snapshot()) {
        self.carets = Carets(snapshot)
        self.selection = carets.lastIndex ..< carets.lastIndex
    }
    
    @inlinable init(_ carets: Carets, selection: Range<Carets.Index>) {
        self.carets = carets
        self.selection = selection
    }
    
    // MARK: Getters
    
    @inlinable var offsets: Range<Offset> {
        selection.lowerBound.offset ..< selection.upperBound.offset
    }
    
    // MARK: Look
    
    @inlinable func look(_ start: Carets.Index, direction: Direction) -> Carets.Index {
        direction == .forwards ? lookahead(start) : lookbehind(start)
    }

    @inlinable func lookahead(_ start: Carets.Index) -> Carets.Index {
        carets[start...].firstIndex(where: \.nonlookaheadable) ?? carets.lastIndex
    }
    
    @inlinable func lookbehind(_ start: Carets.Index) -> Carets.Index {
        carets[...start].lastIndex(where: \.nonlookbehindable) ?? carets.firstIndex
    }
    
    // MARK: Update: Carets
    
    @inlinable func updating(carets newValue: Carets) -> Self {
        movingToCarets(newValue).movingToAttributes()
    }
    
    @inlinable func updating(carets newValue: Snapshot) -> Self {
        updating(carets: Carets(newValue))
    }

    // MARK: Update: Selection
    
    @inlinable func updating(selection newValue: Range<Carets.Index>, intent: Direction?) -> Self {
        movingToSelection(newValue, intent: intent).movingToAttributes()
    }
    
    @inlinable func updating(selection newValue: Carets.Index, intent: Direction?) -> Self {
        updating(selection: newValue ..< newValue, intent: intent)
    }
    
    // MARK: Configure: Selection, Offsets
    
    @inlinable func updating(selection newValue: Range<Offset>, intent: Direction?) -> Self {
        updating(selection: indices(in: newValue), intent: intent)
    }
    
    @inlinable func updating(selection newValue: Offset, intent: Direction?) -> Self {
        updating(selection: newValue ..< newValue, intent: intent)
    }
}

// MARK: Movements

extension Field {
    
    // MARK: To Attribute
    
    @inlinable func movingToAttributes() -> Field {
        func move(_ position: Carets.Index, preference: Direction) -> Carets.Index {
            let direction = carets[position].directionOfAttributes() ?? preference
            return look(position, direction: direction)
        }
        
        // --------------------------------- //
        
        let upperBound = move(selection.upperBound, preference: .backwards)
        var lowerBound = upperBound

        if !selection.isEmpty {
            lowerBound = move(selection.lowerBound, preference: .forwards)
            lowerBound = min(lowerBound, upperBound)
        }
        
        // --------------------------------- //
        
        return transforming({ $0.selection = lowerBound ..< upperBound })
    }

    // MARK: To Selection
    
    @inlinable func movingToSelection(_ newValue: Range<Carets.Index>, intent: Direction?) -> Field {
        func move(_ start: Carets.Index, preference: Direction) -> Carets.Index {
            if carets[start].nonlookable(direction: preference) { return start }
                        
            // --------------------------------- //
            
            let direction = intent ?? preference
            let next = look(start, direction: direction)
            
            // --------------------------------- //
            
            if direction == preference { return next }
            
            switch direction {
            case .forwards:  return next < carets.lastIndex  ? carets.index(after:  next) : next
            case .backwards: return next > carets.firstIndex ? carets.index(before: next) : next
            }
        }
        
        // --------------------------------- //
        
        let upperBound = move(newValue.upperBound, preference: .backwards)
        var lowerBound = upperBound

        if !newValue.isEmpty {
            lowerBound = move(newValue.lowerBound, preference:  .forwards)
            lowerBound = min(lowerBound, upperBound)
        }
        
        // --------------------------------- //

        return transforming({ $0.selection = lowerBound ..< upperBound })
    }
    
    // MARK: To Carets
            
    @inlinable func movingToCarets(_ newValue: Carets) -> Field {
        func step(previous lhs: Symbol, next rhs: Symbol) -> SimilaritiesInstruction {
            if lhs == rhs                               { return .continue      }
            else if lhs.attribute.contains(.removable)  { return .continueOnLHS }
            else if rhs.attribute.contains(.insertable) { return .continueOnRHS }
            else                                        { return .done          }
        }
        
        // --------------------------------- //
        
        let options = SimilaritiesOptions(comparison: .instruction(step), inspection: .only(\.nonformatting))
        
        // --------------------------------- //

        func position(from current: Carets.SubSequence, to next: Carets.SubSequence) -> Carets.Index {
            Similarities(in: current.lazy.map(\.rhs), and: next.lazy.map(\.rhs), with: options).rhsSuffix().startIndex
        }
        
        // --------------------------------- //
        
        let nextUpperBound = position(from: carets[selection.upperBound...], to: newValue[...])
        let nextLowerBound = position(from: carets[selection], to: newValue[..<nextUpperBound])
                
        // --------------------------------- //
        
        return Field(newValue, selection: nextLowerBound ..< nextUpperBound)
    }
}

// MARK: - Indices & Offsets

extension Field {
    
    // MARK: Utilities
    
    @inlinable func indices(in offsets: Range<Offset>) -> Range<Carets.Index> {
        var indices = [Carets.Index]()
        indices.reserveCapacity(5)
        indices.append(contentsOf: [carets.firstIndex, carets.endIndex])
        indices.append(contentsOf: [selection.lowerBound, selection.upperBound])
        
        // --------------------------------- //
        
        func index(at offset: Offset) -> Carets.Index {
            let shortestIndexPath = indices.map({ PathToIndex($0, offset: offset) }).min()!
            return carets.index(start: shortestIndexPath.origin, offset: shortestIndexPath.offset)
        }
        
        // --------------------------------- //
        
        let lowerBound = index(at: offsets.lowerBound)
        indices.append(lowerBound)
        let upperBound = index(at: offsets.upperBound)
                        
        // --------------------------------- //
        
        return lowerBound ..< upperBound
    }
    
    // MARK: Objects
    
    @usableFromInline struct PathToIndex: Comparable {
        
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
