//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import SwiftUI
import UIKit

//*============================================================================*
// MARK: Declaration
//*============================================================================*

/// An as-you-type formatting compatible UITextField.
///
/// UITextField has two selection methods: drag and drop and keyboard inputs.
///
///  - Use static selection for drag and drop.
///  - Use momentum selection for keyboard inputs.
///
@usableFromInline final class Base: UITextField {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var intent = Intent()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @usableFromInline init() {
        super.init(frame: .zero)
        self.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //*========================================================================*
    // MARK: Intent
    //*========================================================================*
    
    @usableFromInline struct Intent {
        @usableFromInline typealias Key = UIKeyboardHIDUsage
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline private(set) var latest: Key?
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var momentum: Bool { latest != nil }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable mutating func insert(_ presses: Set<UIPress>) {
            parse(presses).map({ latest =  $0 })
        }
        
        @inlinable mutating func remove(_ presses: Set<UIPress>) {
            parse(presses).map({ latest == $0 ? latest = nil : () })
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Parse
        //=--------------------------------------------------------------------=
        
        @inlinable func parse(_ presses: Set<UIPress>) -> Key? {
            if let key = presses.first?.key?.keyCode,
            key == .keyboardLeftArrow ||
            key == .keyboardRightArrow { return key }; return nil
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: UIResponder
//=----------------------------------------------------------------------------=

extension Base {

    //=------------------------------------------------------------------------=
    // MARK: Presses
    //=------------------------------------------------------------------------=
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        intent.insert(presses); super.pressesBegan(presses, with: event)
    }
    
    override func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        intent.insert(presses); super.pressesChanged(presses, with: event)
    }
    
    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        intent.remove(presses); super.pressesEnded(presses, with: event)
    }
    
    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        intent.remove(presses); super.pressesCancelled(presses, with: event)
    }
}

#endif
