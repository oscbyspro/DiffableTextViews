//
//  Input.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

//*============================================================================*
// MARK: * Input
//*============================================================================*

public struct Input {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    public let content: Snapshot
    public let range: Range<Snapshot.Index>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(content: Snapshot, range: Range<Snapshot.Index>) {
        self.content = content
        self.range = range
    }
}
