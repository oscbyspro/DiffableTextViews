//
//  Changes.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

//*============================================================================*
// MARK: * Changes - Start
//*============================================================================*

@inlinable func changesStartIndices(
    past: Snapshot.SubSequence,
    next: Snapshot.SubSequence)
-> (past: Snapshot.Index, next: Snapshot.Index) {
    //=------------------------------------------=
    // MARK: Indices
    //=------------------------------------------=
    var pastIndex = past.startIndex
    var nextIndex = next.startIndex
    //=------------------------------------------=
    // MARK: Attempt
    //=------------------------------------------=
    if pastIndex != past.endIndex,
       nextIndex != next.endIndex {
        //=--------------------------------------=
        // MARK: Elements
        //=--------------------------------------=
        var pastElement = past[pastIndex]
        var nextElement = next[nextIndex]
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        while pastIndex != past.endIndex,
              nextIndex != next.endIndex {
            //=----------------------------------=
            // MARK: Indices, Elements
            //=----------------------------------=
            if pastElement == nextElement {
                past.formIndex(after: &pastIndex)
                pastElement = past[pastIndex]
                next.formIndex(after: &nextIndex)
                nextElement = next[nextIndex]
            } else if pastElement.removable {
                past.formIndex(after: &pastIndex)
                pastElement = past[pastIndex]
            } else if nextElement.insertable {
                next.formIndex(after: &nextIndex)
                nextElement = next[nextIndex]
            } else {
                break
            }
        }
    }
    //=------------------------------------------=
    // MARK: Return
    //=------------------------------------------=
    return (pastIndex, nextIndex)
}

//*============================================================================*
// MARK: * Changes - End
//*============================================================================*

@inlinable func changesEndIndices(
    past: Snapshot.SubSequence,
    next: Snapshot.SubSequence)
-> (past: Snapshot.Index, next: Snapshot.Index) {
    //=------------------------------------------=
    // MARK: Indices
    //=------------------------------------------=
    var pastIndex = past.endIndex
    var nextIndex = next.endIndex
    //=------------------------------------------=
    // MARK: Attempt
    //=------------------------------------------=
    if pastIndex != past.startIndex,
       nextIndex != next.startIndex {
        //=--------------------------------------=
        // MARK: Elements
        //=--------------------------------------=
        var pastElement = past[pastIndex]
        var nextElement = next[nextIndex]
        //=--------------------------------------=
        // MARK: Loop
        //=--------------------------------------=
        while pastIndex != past.startIndex,
              nextIndex != next.startIndex {
            //=----------------------------------=
            // MARK: Indices, Elements
            //=----------------------------------=
            if pastElement == nextElement {
                past.formIndex(before: &pastIndex)
                pastElement = past[pastIndex]
                next.formIndex(before: &nextIndex)
                nextElement = next[nextIndex]
            } else if pastElement.removable {
                past.formIndex(before: &pastIndex)
                pastElement = past[pastIndex]
            } else if nextElement.insertable {
                next.formIndex(before: &nextIndex)
                nextElement = next[nextIndex]
            } else {
                break
            }
        }
    }
    //=------------------------------------------=
    // MARK: Return
    //=------------------------------------------=
    return (pastIndex, nextIndex)
}
