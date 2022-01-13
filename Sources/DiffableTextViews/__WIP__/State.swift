//
//  State.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-12.
//

//*============================================================================*
// MARK: * State
//*============================================================================*

@usableFromInline struct State {
    @usableFromInline typealias Index = Snapshot.Index
    @usableFromInline typealias SubSequence = Snapshot.SubSequence
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var snapshot:  Snapshot
    @usableFromInline private(set) var selection: Range<Index>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init() {
        self.snapshot  = Snapshot()
        self.selection = snapshot.endIndex..<snapshot.endIndex
    }
    
    @inlinable init(snapshot: Snapshot, selection: Range<Index>) {
        self.snapshot  = snapshot
        self.selection = selection
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func update(snapshot newSnapshot: Snapshot) {
        //=--------------------------------------=
        // MARK: Upper Bound
        //=--------------------------------------=
        let newUpperBound = Self.breakpoint(
            prev: snapshot[selection.upperBound...],
            next: newSnapshot[...])
        //=--------------------------------------=
        // MARK: Lower Bound
        //=--------------------------------------=
        let newLowerBound = Self.breakpoint(
            prev: snapshot[selection.lowerBound..<newUpperBound.prev],
            next: newSnapshot[..<newUpperBound.next])
        //=--------------------------------------=
        // MARK: Selection
        //=--------------------------------------=
        let newSelection = Self.selection(
            snapshot: newSnapshot,
            lower: newUpperBound.next,
            upper: newLowerBound.next)
        //=--------------------------------------=
        // MARK: Properties
        //=--------------------------------------=
        self.snapshot = newSnapshot
        self.selection = newSelection
    }
    
    #warning("WIP")
}

//=----------------------------------------------------------------------------=
// MARK: State - Algorithms
//=----------------------------------------------------------------------------=

extension State {
    
    //=------------------------------------------------------------------------=
    // MARK: Breakpoint
    //=------------------------------------------------------------------------=
    
    @inlinable static func breakpoint(prev: SubSequence, next: SubSequence) -> (prev: Index, next: Index) {
        //=--------------------------------------=
        // MARK: Indices
        //=--------------------------------------=
        var prevIndex = prev.endIndex
        var nextIndex = next.endIndex
        //=--------------------------------------=
        // MARK: Attempt
        //=--------------------------------------=
        if prevIndex != prev.startIndex, nextIndex != next.startIndex {
            //=----------------------------------=
            // MARK: Indices
            //=----------------------------------=
            prev.formIndex(before: &prevIndex)
            next.formIndex(before: &nextIndex)
            //=----------------------------------=
            // MARK: Elements
            //=----------------------------------=
            var prevElement = prev[prevIndex]
            var nextElement = next[nextIndex]
            //=----------------------------------=
            // MARK: Loop
            //=----------------------------------=
            while prevIndex != prev.startIndex, nextIndex != next.startIndex {
                //=------------------------------=
                // MARK: Step
                //=------------------------------=
                if prevElement == nextElement {
                    prev.formIndex(before: &prevIndex)
                    prevElement = prev[prevIndex]
                    next.formIndex(before: &nextIndex)
                    nextElement = next[nextIndex]
                } else if prevElement.removable {
                    prev.formIndex(before: &prevIndex)
                    prevElement = prev[prevIndex]
                } else if nextElement.insertable {
                    next.formIndex(before: &nextIndex)
                    nextElement = next[nextIndex]
                } else {
                    break
                }
            }
        }
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return (prevIndex, nextIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
        
    @inlinable static func selection(snapshot: Snapshot, lower: Index, upper: Index) -> Range<Index> {
        
        
        
        #warning("T##message##")
        fatalError()
    }
}

#warning("...")

/*
 
 @inlinable func autocorrected() -> Self {
     func position(start: Carets.Index, preference: Direction) -> Carets.Index {
         carets.look(start: start, direction: carets[start].directionality() ?? preference)
     }
     
     return map({ $0.selection = $0.selection.preferred(position) })
 }
 
 @inlinable func updated(selection newValue: Selection, intent: Direction?) -> Self {
     func position(start: Carets.Index, preference: Direction) -> Carets.Index {
         if carets[start].nonlookable(direction: preference) { return start }
         
         let direction = intent ?? preference
         let next = carets.look(start: start, direction: direction)
         
         switch direction {
         case preference: return next
         case  .forwards: return next < carets .lastIndex ? carets.index(after:  next) : next
         case .backwards: return next > carets.startIndex ? carets.index(before: next) : next
         }
     }
     
     return map({ $0.selection = newValue.preferred(position) }).autocorrected()
 }
 
 */
