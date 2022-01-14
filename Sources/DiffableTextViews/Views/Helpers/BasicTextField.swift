//
//  BasicTextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-31.
//

#warning("Rework: Intent.")

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * BasicTextField
//*============================================================================*

public final class BasicTextField: UITextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    #warning("Record that an 'intent' key was pressed.")
    #warning("Then convert the 'intent' to change in momentum, once.")
    @usableFromInline private(set) var intent: Direction? = nil

    //=------------------------------------------------------------------------=
    // MARK: Presses
    //=------------------------------------------------------------------------=
    
    public override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        processIntentStarted(presses)
        super.pressesBegan(presses, with: event)
    }
    
    public override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        processIntentStarted(presses)
        super.pressesChanged(presses, with: event)
    }
    
    public override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        processIntentEnded(presses)
        super.pressesEnded(presses, with: event)
    }
    
    public override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        processIntentEnded(presses)
        super.pressesCancelled(presses, with: event)
    }
    
    //
    // MARK: Presses - Intent
    //=------------------------------------------------------------------------=
    
    @inlinable func processIntentStarted(_ presses: Set<UIPress>) {
        intent = .intent(presses)
    }
    
    @inlinable func processIntentEnded(_ presses: Set<UIPress>) {
        if intent == .intent(presses) { intent = nil }
    }
}
#endif
