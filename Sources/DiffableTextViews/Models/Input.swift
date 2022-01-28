//
//  Input.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

#warning("Rename, maybe.")

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
    
    @inlinable init<S: Scheme>(content: String, range: Range<Layout<S>.Index>) {
        self.content = Snapshot(content, as: .content)
        self.range = range.lowerBound.snapshot ..< range.upperBound.snapshot
    }
}
