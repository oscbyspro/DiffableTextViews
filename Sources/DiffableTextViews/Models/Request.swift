//
//  Request.swift
//  
//
//  Created by Oscar Byström Ericsson on 2022-01-11.
//

//*============================================================================*
// MARK: * Request
//*============================================================================*

public struct Request {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    public let snapshot: Snapshot
    public var replacement: Snapshot
    public var range: Range<Snapshot.Index>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init<S: Scheme>(_ snapshot: Snapshot, change: (content: String, range: Range<Layout<S>.Index>)) {
        self.snapshot = snapshot
        self.replacement = Snapshot(change.content, as: .content)
        self.range = change.range.lowerBound.snapshot ..< change.range.upperBound.snapshot
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Merges the components of the request into a single snapshot.
    @inlinable public func proposal() -> Snapshot {
        var result = snapshot; result.replaceSubrange(range, with: replacement); return result
    }
}
