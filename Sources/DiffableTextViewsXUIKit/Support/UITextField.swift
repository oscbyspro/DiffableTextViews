//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import DiffableTextKit
import UIKit

//*============================================================================*
// MARK: Extension
//*============================================================================*

extension UITextField {
    @usableFromInline typealias Position = DiffableTextKit.Position<UTF16>

    //=------------------------------------------------------------------------=
    // MARK: Conversions
    //=------------------------------------------------------------------------=

    @inlinable func position(_ uiposition: UITextPosition) -> Position {
        Position(offset(from: self.beginningOfDocument, to: uiposition))
    }
    
    @inlinable func range(_ uirange: UITextRange) -> Range<Position> {
        position(uirange.start) ..< position(uirange.end)
    }
    
    @inlinable func uiposition(_ position: Position) -> UITextPosition {
        self.position(from: self.beginningOfDocument, offset: position.offset)!
    }
    
    @inlinable func uirange(_ range: Range<Position>) -> UITextRange {
        self.textRange(from: uiposition(range.lowerBound), to: uiposition(range.upperBound))!
    }    
}

#endif
