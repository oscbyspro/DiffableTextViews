//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * ProxyTextField
//*============================================================================*

public final class ProxyTextField: BasicTextField.View {
    public final class Keyboard: BasicTextField.View { }
    public final class Selection: BasicTextField.View { }
    public final class Text: BasicTextField.View { }
    public final class Traits: BasicTextField.View { }

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var keyboard: Keyboard {
        Keyboard(wrapped)
    }
    
    @inlinable public var selection: Selection {
        Selection(wrapped)
    }
    
    @inlinable public var text: Text {
        Text(wrapped)
    }
    
    @inlinable public var traits: Traits {
        Traits(wrapped)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Actions
    //=------------------------------------------------------------------------=
    
    /// Asks this object to relinquish its status as first responder in its window.
    ///
    /// SwiftUI.FocusState is the preferred focusing mechanism in most cases.
    ///
    @inlinable public func dismiss() {
        Task { @MainActor in wrapped.resignFirstResponder() }
    }
}

#endif
