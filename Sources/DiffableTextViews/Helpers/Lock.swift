//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Lock
//*============================================================================*

/// A lock that allows actions to be performed inside a locked state.
///
/// Made to stop UITextFieldDelegate from responding to textFieldDidChangeSelection(\_:) in an invalid state.
///
/// - Note: This is NOT a thread lock.
///
@usableFromInline final class Lock {
    
    //=------------------------------------------------------------------------=
    // MARK: State
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
