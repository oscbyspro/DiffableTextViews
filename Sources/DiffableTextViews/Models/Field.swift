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
        transformingAccordingToCarets(newValue).transformingAccordingToAttributes()
    }
    
    @inlinable func updating(carets newValue: Snapshot) -> Self {
        updating(carets: Carets(newValue))
    }

    // MARK: Update: Selection
    
    @inlinable func updating(selection newValue: Range<Carets.Index>, intent: Direction?) -> Self {
        transformingAccordingToSelection(newValue, intent: intent).transformingAccordingToAttributes()
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

    // MARK: Transformations: Attribute
                    
    @usableFromInline func transformingAccordingToAttributes() -> Field {
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

    // MARK: Transformations: Selection
        
    @usableFromInline func transformingAccordingToSelection(_ newValue: Range<Carets.Index>, intent: Direction?) -> Field {
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
    
    // MARK: Transformations: Carets
            
    @usableFromInline func transformingAccordingToCarets(_ newValue: Carets) -> Field {
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
        
        let upperBound = position(from: carets.suffix(from: selection.upperBound), to: newValue[...])
        let lowerBound = position(from: carets[selection],     to: newValue.prefix(upTo: upperBound))
                
        // --------------------------------- //
        
        return Field(newValue, selection: lowerBound ..< upperBound)
    }
    
    // MARK: Utilities: Indices
    
    @usableFromInline func indices(in offsets: Range<Offset>) -> Range<Carets.Index> {
        var indices = [Carets.Index]()
        indices.reserveCapacity(4)
        indices.append(contentsOf: [selection.upperBound, selection.lowerBound, carets.firstIndex])
        
        // --------------------------------- //
        
        func index(at offset: Offset) -> Carets.Index {
            var shortestPathToIndex = PathToIndex(carets.lastIndex, to: offset)
            
            // indices are sorted in reverse order at compile time
            for index in indices {
                let nextPathToIndex = PathToIndex(index, to: offset)
                guard nextPathToIndex <= shortestPathToIndex else { break }
                shortestPathToIndex = nextPathToIndex
            }

            return carets.index(start: shortestPathToIndex.start, offset: shortestPathToIndex.distance)
        }
        
        // --------------------------------- //
        
        let lowerBound = index(at: offsets.lowerBound); indices.append(lowerBound)
        let upperBound = index(at: offsets.upperBound);
                        
        // --------------------------------- //
        
        return lowerBound ..< upperBound
    }
    
    // MARK: Components
    
    @usableFromInline struct PathToIndex: Comparable {
        
        // MARK: Properties
        
        @usableFromInline let start: Carets.Index
        @usableFromInline let distance: Offset
        
        // MARK: Initializers
        
        @inlinable init(_ start: Carets.Index, to destination: Offset) {
            self.start = start
            self.distance = destination - start.offset
        }

        // MARK: Comparisons
        
        @inlinable static func < (lhs: Self, rhs: Self) -> Bool {
            abs(lhs.distance.units) < abs(rhs.distance.units)
        }
    }
}
