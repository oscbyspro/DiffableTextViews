//
//  BasicTextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-31.
//

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * BasicTextField
//*============================================================================*

public final class BasicTextField: UITextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var intent: Direction? = nil

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
        intent = Self.intent(presses)
    }
    
    @inlinable func process(old presses: Set<UIPress>) {
        if intent == Self.intent(presses) { intent = nil }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Intent
    //=------------------------------------------------------------------------=
    
    @inlinable static func intent(_ presses: Set<UIPress>) -> Direction? {
        presses.first?.key.flatMap({ intents[$0.keyCode] })
    }
    
    @usableFromInline static let intents: [UIKeyboardHIDUsage: Direction] = [
        .keyboardLeftArrow: .backwards, .keyboardRightArrow: .forwards
    ]
}
#endif
