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
    
    @inlinable init(_ field: Carets, selection: Range<Carets.Index>) {
        self.carets = field
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
    
    @inlinable func update(carets newValue: Carets) -> Self {
        move(to: newValue).moveToAttributes()
    }
    
    @inlinable func update(carets newValue: Snapshot) -> Self {
        update(carets: Carets(newValue))
    }

    // MARK: Update: Selection
    
    @inlinable func update(selection newValue: Range<Carets.Index>, intent: Direction?) -> Self {
        move(to: newValue, intent: intent).moveToAttributes()
    }
    
    @inlinable func update(selection newValue: Carets.Index, intent: Direction?) -> Self {
        update(selection: newValue ..< newValue, intent: intent)
    }
    
    // MARK: Configure: Selection, Offsets
    
    @inlinable func update(selection newValue: Range<Offset>, intent: Direction?) -> Self {
        update(selection: indices(in: newValue), intent: intent)
    }
    
    @inlinable func update(selection newValue: Offset, intent: Direction?) -> Self {
        update(selection: newValue ..< newValue, intent: intent)
    }
}

// MARK: Movements

extension Field {
    
    // MARK: To Attribute
    
    @inlinable func moveToAttributes() -> Field {
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
        
        return transforming(using: { $0.selection = lowerBound ..< upperBound })
    }

    // MARK: To Selection
    
    @inlinable func move(to nextSelection: Range<Carets.Index>, intent: Direction?) -> Field {
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
        
        let upperBound = move(nextSelection.upperBound, preference: .backwards)
        var lowerBound = upperBound

        if !nextSelection.isEmpty {
            lowerBound = move(nextSelection.lowerBound, preference: .forwards)
            lowerBound = min(lowerBound, upperBound)
        }
        
        // --------------------------------- //

        return transforming(using: { $0.selection = lowerBound ..< upperBound })
    }
    
    // MARK: To Carets
    
    @inlinable func move(to nextCarets: Carets) -> Field {
        func step(previous lhs: Symbol, next rhs: Symbol) -> SimilaritiesInstruction {
            if lhs == rhs                               { return .continue      }
            else if lhs.attribute.contains(.removable)  { return .continueOnLHS }
            else if rhs.attribute.contains(.insertable) { return .continueOnRHS }
            else                                        { return .done          }
        }
        
        // --------------------------------- //
        
        let options = SimilaritiesOptions<Symbol>
            .compare(.instruction(step))
            .inspect(.only(\.nonformatting))
        
        // --------------------------------- //

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
