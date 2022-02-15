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
// MARK: * BasicTextField
//*============================================================================*

public final class BasicTextField: UITextField {
    @usableFromInline typealias Code = UIKeyboardHIDUsage
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var intent: Code? = nil
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// A bool describing the intent to move in the direction of change.
    ///
    /// The intent of left and right key presses should be interpreted as a desire to continue in the direction
    /// with momentum. This is because the direction of text is based on its content, where left-to-right and
    /// right-to-left text respond to left and right keys presses in opposite ways.
    ///
    @inlinable var momentum: Bool {
        intent != nil
    }

    //=------------------------------------------------------------------------=
    // MARK: Presses
    //=------------------------------------------------------------------------=
    
    public override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        process(new: presses)
        super.pressesBegan(presses, with: event)
    }
    
    public override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        process(new: presses)
        super.pressesChanged(presses, with: event)
    }
    
    public override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        process(old: presses)
        super.pressesEnded(presses, with: event)
    }
    
    public override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        process(old: presses)
        super.pressesCancelled(presses, with: event)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Presses - Process
    //=------------------------------------------------------------------------=
    
    @inlinable func process(new presses: Set<UIPress>) {
        intent = intent(behind: presses)
    }
    
    @inlinable func process(old presses: Set<UIPress>) {
        if intent == intent(behind: presses) { intent = nil }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Intent
    //=------------------------------------------------------------------------=
    
    @inlinable func intent(behind presses: Set<UIPress>) -> Code? {
        (presses.first?.key?.keyCode).flatMap({ Self.intents.contains($0) ? $0 : nil })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Intent - Constants
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let intents = Set<Code>([.keyboardLeftArrow, .keyboardRightArrow])
}

#endif
