//
//  Field.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-27.
//

//*============================================================================*
// MARK: * Field
//*============================================================================*

@usableFromInline struct Field<Scheme: DiffableTextViews.Scheme> {
    @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>
    @usableFromInline typealias Carets = DiffableTextViews.Carets<Scheme>
    @usableFromInline typealias Selection = DiffableTextViews.Selection<Scheme>

    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let carets: Carets
    @usableFromInline var selection: Selection

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.init(snapshot: Snapshot())
    }
    
    @inlinable init(snapshot: Snapshot) {
        self.carets = Carets(snapshot: snapshot)
        self.selection = Selection(position: carets.lastIndex)
    }
    
    @inlinable init(carets: Carets, selection: Selection) {
        self.carets = carets
        self.selection = selection
    }
}

//=----------------------------------------------------------------------------=
// MARK: Field - Update
//=----------------------------------------------------------------------------=

extension Field {

    //=------------------------------------------------------------------------=
    // MARK: Carets
    //=------------------------------------------------------------------------=
    
    @inlinable func updating(carets newValue: Carets) -> Self {
        transformingAccordingToCarets(newValue).transformingAccordingToAttributes()
    }
    
    @inlinable func updating(carets newValue: Snapshot) -> Self {
        updating(carets: Carets(snapshot: newValue))
    }

    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
    
    @inlinable func updating(selection newValue: Selection, intent: Direction?) -> Self {
        transformingAccordingToSelection(newValue, intent: intent).transformingAccordingToAttributes()
    }
    
    @inlinable func updating(selection newValue: Range<Carets.Index>, intent: Direction?) -> Self {
        updating(selection: Selection(range: newValue), intent: intent)
    }
    
    @inlinable func updating(selection newValue: Carets.Index, intent: Direction?) -> Self {
        updating(selection: Selection(position: newValue), intent: intent)
    }
    
    @inlinable func updating(selection newValue: Range<Offset>, intent: Direction?) -> Self {
        updating(selection: Selection(range: indices(at: newValue)), intent: intent)
    }
    
    @inlinable func updating(selection newValue: Offset, intent: Direction?) -> Self {
        updating(selection: Selection(range: indices(at: newValue ..< newValue)), intent: intent)
    }
    
    //
    // MARK: Selection - Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func indices(at offsets: Range<Offset>) -> Range<Carets.Index> {
        let upperBound = carets.index(at: offsets.upperBound, start: selection.upperBound)
        var lowerBound = upperBound

        if !offsets.isEmpty {
            lowerBound = carets.index(at: offsets.lowerBound, start: selection.lowerBound)
        }

        return lowerBound ..< upperBound
    }
}

//=----------------------------------------------------------------------------=
// MARK: Field - Tranformations
//=----------------------------------------------------------------------------=

extension Field {

    //=------------------------------------------------------------------------=
    // MARK: Attributes
    //=------------------------------------------------------------------------=
                    
    @inlinable func transformingAccordingToAttributes() -> Field {
        func position(start: Carets.Index, preference: Direction) -> Carets.Index {
            carets.look(start: start, direction: carets[start].directionOfAttributes() ?? preference)
        }

        var result = self; result.selection = selection.preferential(position); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Carets
    //=------------------------------------------------------------------------=
            
    @inlinable func transformingAccordingToCarets(_ newValue: Carets) -> Field {
        func position(current: Carets.SubSequence, next: Carets.SubSequence) -> Carets.Index {
            _Field.similarities(current: current.lazy.map(\.rhs), next: next.lazy.map(\.rhs)).startIndex
        }
                
        let upperBound = position(current: carets.suffix(from: selection.upperBound),   next: newValue[...])
        let lowerBound = position(current: carets[selection.range], next: newValue.prefix(upTo: upperBound))
        
        return Field(carets: newValue, selection: Selection(range: lowerBound ..< upperBound))
    }

    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
        
    @inlinable func transformingAccordingToSelection(_ newValue: Selection, intent: Direction?) -> Field {
        func position(start: Carets.Index, preference: Direction) -> Carets.Index {
            if carets[start].nonlookable(direction: preference) { return start }
            
            let direction = intent ?? preference
            let next = carets.look(start: start, direction: direction)
                        
            switch direction {
            case preference: return next
            case  .forwards: return next < carets.lastIndex  ? carets.index(after:  next) : next
            case .backwards: return next > carets.firstIndex ? carets.index(before: next) : next
            }
        }
        
        var result = self; result.selection = newValue.preferential(position); return result
    }
}

//=------------------------------------------------------------------------=
// MARK: Field - Namespace
//=------------------------------------------------------------------------=

@usableFromInline enum _Field {
    
    //=------------------------------------------------------------------------=
    // MARK: Similarities
    //=------------------------------------------------------------------------=
    
    @inlinable static func similarities<Current: BidirectionalCollection, Next: BidirectionalCollection>(current lhs: Current, next rhs: Next) -> Next.SubSequence where Current.Element == Symbol, Next.Element == Symbol {
        Similarities(lhs: lhs, rhs: rhs, options: options).rhsSuffix()
    }
    
    //
    // MARK: Similarities - Options
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let options: SimilaritiesOptions<Symbol> = {
        func step(current lhs: Symbol, next rhs: Symbol) -> SimilaritiesInstruction {
            if lhs == rhs                               { return .continue      }
            else if lhs.attribute.contains(.removable)  { return .continueOnLHS }
            else if rhs.attribute.contains(.insertable) { return .continueOnRHS }
            else                                        { return .none          }
        }
        
        return .init(comparison: .instruction(step), inspection: .only(Symbol.is(non: .formatting)))
    }()
}
