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
// MARK: * BasicTextField
//*============================================================================*

public final class BasicTextField: UITextField {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public private(set) var intent = Intent()
    
    //*========================================================================*
    // MARK: * Intent
    //*========================================================================*
    
    public struct Intent {
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
        
        @inlinable public init(_ wrapped: BasicTextField) { self.wrapped = wrapped }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + UIResponder
//=----------------------------------------------------------------------------=

public extension BasicTextField {

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

//=----------------------------------------------------------------------------=
// MARK: + Customization
//=----------------------------------------------------------------------------=

public extension BasicTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func setTextAlignment(_ alignment: TextAlignment) {
        self.textAlignment = NSTextAlignment(alignment, for: userInterfaceLayoutDirection)
    }
}

#endif
