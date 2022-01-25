//
//  Mode.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-12-31.
//

//*============================================================================*
// MARK: * Mode
//*============================================================================*

/// A model representing the state of a text input view.
@frozen public enum Mode {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=

    
    /// Represents the state of a view that is idle.
    case showcase
    
    /// Represents the state of a view that is active.
    case editable
}
