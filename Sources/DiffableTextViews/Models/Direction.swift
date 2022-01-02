//
//  Direction.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-10-29.
//

//*============================================================================*
// MARK: * Direction
//*============================================================================*

@usableFromInline @frozen enum Direction {
    
    //=------------------------------------------------------------------------=
    // MARK: Instances
    //=------------------------------------------------------------------------=
    
    case forwards
    case backwards
}

//=----------------------------------------------------------------------------=
// MARK: Direction - UIKit
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import UIKit

extension Direction {
    
    //=------------------------------------------------------------------------=
    // MARK: Intent
    //=------------------------------------------------------------------------=
    
    @inlinable static func intent(_ presses: Set<UIPress>) -> Self? {
        presses.first?.key.flatMap({ intentions[$0.keyCode] })
    }
    
    //
    // MARK: Intent - Map
    //=------------------------------------------------------------------------=
    
    @usableFromInline static let intentions: [UIKeyboardHIDUsage: Self] = [
        .keyboardLeftArrow: .backwards, .keyboardRightArrow: .forwards
    ]
}

#endif
