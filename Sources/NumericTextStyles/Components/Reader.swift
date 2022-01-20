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
    @usableFromInline typealias Command = (inout Number) -> Void
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline var content: Snapshot
    @usableFromInline var process: Command?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
            
    @inlinable init(_ content: Snapshot) {
        self.content = content
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func consumeSignInput(region: Region) {
        guard content.count == 1 else { return }
        guard let sign = region.signs[content.first!.character] else { return }
        //=--------------------------------------=
        // MARK: Set Sign Command Found
        //=--------------------------------------=
        self.content.removeAll()
        self.process = { number in number.sign = sign }
    }
}
