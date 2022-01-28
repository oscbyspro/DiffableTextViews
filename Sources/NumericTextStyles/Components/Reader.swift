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
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let region: Region
    @usableFromInline var request: Request
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
            
    @inlinable init(_ request: Request, in region: Region) {
        self.region  = region
        self.request = request
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Interprets a single sign character as a: set sign command.
    @inlinable mutating func consumeSignCommand() -> Transform<Number>? {
        guard request.replacement.count == 1 else { return nil } // snapshot.count is O(1)
        guard let sign = region.signs[request.replacement.first!.character] else { return nil }
        //=--------------------------------------=
        // MARK: Set Sign Command Found
        //=--------------------------------------=
        self.request.replacement.removeAll()
        return { number in number.sign = sign }
    }
}
