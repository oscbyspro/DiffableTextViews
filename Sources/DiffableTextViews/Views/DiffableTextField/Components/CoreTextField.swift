//
//  CoreTextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-31.
//

#if canImport(UIKit)

import UIKit

// MARK: - CoreTextField

public final class CoreTextField: UITextField {
    
    // MARK: Properties
    
    @usableFromInline var intent: Intent? = nil

    // MARK: Intent
    
    @usableFromInline struct Intent: Equatable {
        @usableFromInline typealias Code = UIKeyboardHIDUsage
        
        // MARK: Instances
        
        @usableFromInline static let forwards  = Self(direction: .forwards,  code: .keyboardRightArrow)
        @usableFromInline static let backwards = Self(direction: .backwards, code:  .keyboardLeftArrow)
        
        // MARK: Properties
        
        @usableFromInline let direction: Direction
        @usableFromInline let code: Code
        
        // MARK: Initializers
        
        @inlinable init(direction: Direction,  code: Code) {
            self.direction = direction
            self.code = code
        }

        // MARK: Initializers, Static
        
        @inlinable static func parse(_ presses: Set<UIPress>) -> Intent? {
            guard let key = presses.first?.key else { return nil }
            
            switch key.keyCode {
            case forwards.code:  return .forwards
            case backwards.code: return .backwards
            default: return nil
            }
        }
    }
}

// MARK: - Events

extension CoreTextField {
    
    // MARK: Presses
    
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
    
    // MARK: Presses: Helpers
    
    @inlinable func processIntentStarted(_ presses: Set<UIPress>) {
        self.intent = Intent.parse(presses)
    }
    
    @inlinable func processIntentEnded(_ presses: Set<UIPress>) {
        guard let current = intent else { return }
        guard let ending = Intent.parse(presses) else { return }
        if current == ending { self.intent = nil }
    }
}

#endif
