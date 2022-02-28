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
    
    //*========================================================================*
    // MARK: * View
    //*========================================================================*
    
    public class View {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
                
        @usableFromInline let wrapped: BasicTextField
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ wrapped: BasicTextField) { self.wrapped = wrapped }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UIResponder
//=----------------------------------------------------------------------------=

extension BasicTextField {

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
    // MARK: Presses - Intent
    //=------------------------------------------------------------------------=
    
    @inlinable func process(new presses: Set<UIPress>) {
        intent = intent(behind: presses)
    }
    
    @inlinable func process(old presses: Set<UIPress>) {
        if intent == intent(behind: presses) { intent = nil }
    }

    @inlinable func intent(behind presses: Set<UIPress>) -> Code? {
        (presses.first?.key?.keyCode).flatMap({ Self.intents.contains($0) ? $0 : nil })
    }
    
    @usableFromInline static let intents: Set<Code> = [.keyboardLeftArrow, .keyboardRightArrow]
}

#endif
