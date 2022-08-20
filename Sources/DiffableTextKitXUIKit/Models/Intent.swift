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
// MARK: * Intent [...]
//*============================================================================*

@usableFromInline struct Intent {
    
    @usableFromInline typealias Key = UIKeyboardHIDUsage
    
    //=------------------------------------------------------------------------=
    
    @usableFromInline private(set) var latest: Key?
    
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func insert(_ presses: Set<UIPress>) {
        parse(presses).map({ latest =  $0 })
    }
    
    @inlinable mutating func remove(_ presses: Set<UIPress>) {
        parse(presses).map({ latest == $0 ? latest = nil : () })
    }
    
    @inlinable func parse(_ presses: Set<UIPress>) -> Key? {
        if let key = presses.first?.key?.keyCode,
        key == .keyboardLeftArrow ||
        key == .keyboardRightArrow { return key }; return nil
    }
}

#endif
