//
//  Lock.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-11-05.
//

//*============================================================================*
// MARK: * Lock
//*============================================================================*

/// A lock that allows actions to be performed inside a locked state.
///
/// Made to stop UITextFieldDelegate from responding to textFieldDidChangeSelection(\_:) in an invalid state.
///
/// - Note: This is NOT a thread lock.
///
@usableFromInline @MainActor final class Lock {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var isLocked = false
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func perform(action: () -> Void) {
        let state = isLocked
        self.isLocked = true
        
        action()
        
        self.isLocked = state
    }
}
