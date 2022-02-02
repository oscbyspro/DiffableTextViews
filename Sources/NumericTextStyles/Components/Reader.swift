//
//  Reader.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-11-07.
//

import DiffableTextViews

//*============================================================================*
// MARK: * Reader
//*============================================================================*

@usableFromInline struct Reader {
    @usableFromInline typealias Transform<T> = ((inout T) -> Void)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let region:  Region
    @usableFromInline var changes: Changes
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
            
    @inlinable init(_ changes: Changes, in region: Region) {
        self.region  = region
        self.changes = changes
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Interprets a single sign character as a: set sign command.
    @inlinable mutating func consumeSignCommand() -> Transform<Number>? {
        guard changes.replacement.count == 1 else { return nil } // snapshot.count is O(1)
        guard let sign = region.signs[changes.replacement.first!.character] else { return nil }
        //=--------------------------------------=
        // MARK: Set Sign Command Found
        //=--------------------------------------=
        self.changes.replacement.removeAll()
        return { number in number.sign = sign }
    }
}
