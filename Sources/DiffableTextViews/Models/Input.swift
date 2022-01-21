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
    
    @inlinable init<S>(content: String, range: Range<Layout<S>.Index>) where S: Scheme {
        self.content = Snapshot(content, as: .content)
        self.range = range.lowerBound.snapshot ..< range.upperBound.snapshot
    }
}
