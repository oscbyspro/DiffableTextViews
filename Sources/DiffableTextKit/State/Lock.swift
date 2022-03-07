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
public final class Lock {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var _isLocked = false
    @inlinable public var  isLocked: Bool { _isLocked }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func perform(action: () -> Void) {
        let state = _isLocked
        self._isLocked = true
        
        action()
        
        self._isLocked = state
    }
}
