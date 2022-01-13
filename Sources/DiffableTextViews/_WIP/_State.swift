//
//  State.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-12.
//

//*============================================================================*
// MARK: * State
//*============================================================================*

@usableFromInline struct _State {
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
        // MARK: Upper
        //=--------------------------------------=
        let upper = Self.breakpoint(
            old: snapshot[selection.upperBound...],
            new: newSnapshot[...])
        //=--------------------------------------=
        // MARK: Lower
        //=--------------------------------------=
        let lower = Self.breakpoint(
            old: snapshot[selection.lowerBound..<upper.old],
            new: newSnapshot[..<upper.new])
        //=--------------------------------------=
        // MARK: Selection
        //=--------------------------------------=
        let newSelection = Self.selection(
            snapshot: newSnapshot,
            targets: (lower.new, upper.new))
        //=--------------------------------------=
        // MARK: Set
        //=--------------------------------------=
        self.snapshot  = newSnapshot
        self.selection = newSelection
    }
    
    #warning("WIP")
}

//=----------------------------------------------------------------------------=
// MARK: State - Algorithms
//=----------------------------------------------------------------------------=

extension _State {
    
    //=------------------------------------------------------------------------=
    // MARK: Breakpoint
    //=------------------------------------------------------------------------=
    
    @inlinable static func breakpoint(old: SubSequence, new: SubSequence) -> (old: Index, new: Index) {
        //=--------------------------------------=
        // MARK: Indices
        //=--------------------------------------=
        var oldIndex = old.endIndex
        var newIndex = new.endIndex
        //=--------------------------------------=
        // MARK: Attempt
        //=--------------------------------------=
        if oldIndex != old.startIndex, newIndex != new.startIndex {
            //=----------------------------------=
            // MARK: Indices, Elements
            //=----------------------------------=
            old.formIndex(before: &oldIndex)
            new.formIndex(before: &newIndex)
            //=----------------------------------=
            // MARK: Elements
            //=----------------------------------=
            var oldElement = old[oldIndex]
            var newElement = new[newIndex]
            //=----------------------------------=
            // MARK: Loop
            //=----------------------------------=
            while oldIndex != old.startIndex, newIndex != new.startIndex {
                //=------------------------------=
                // MARK: Indices, Elements
                //=------------------------------=
                if oldElement == newElement {
                    old.formIndex(before: &oldIndex)
                    oldElement = old[oldIndex]
                    new.formIndex(before: &newIndex)
                    newElement = new[newIndex]
                } else if oldElement.removable {
                    old.formIndex(before: &oldIndex)
                    oldElement = old[oldIndex]
                } else if newElement.insertable {
                    new.formIndex(before: &newIndex)
                    newElement = new[newIndex]
                } else {
                    break
                }
            }
        }
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return (oldIndex, newIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Selection
    //=------------------------------------------------------------------------=
        
    @inlinable static func selection(snapshot: Snapshot, targets: (lower: Index, upper: Index)) -> Range<Index> {
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
         let new = carets.look(start: start, direction: direction)
         
         switch direction {
         case preference: return new
         case  .forwards: return new < carets .lastIndex ? carets.index(after:  new) : new
         case .backwards: return new > carets.startIndex ? carets.index(before: new) : new
         }
     }
     
     return map({ $0.selection = newValue.preferred(position) }).autocorrected()
 }
 
 */
