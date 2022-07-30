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
// MARK: * UITextField
//*============================================================================*

extension UITextField {
    @usableFromInline typealias Offset = DiffableTextKit.Offset<UTF16>
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func offset(at position: UITextPosition) -> Offset {
        Offset(offset(from: beginningOfDocument, to: position))
    }
    
    @inlinable func offsets(at positions: UITextRange) -> Range<Offset> {
        let lower = offset(at:   positions.start)
        let count = offset(from: positions.start, to: positions.end)
        return lower ..< lower + Offset(count)
    }
    
    @inlinable func position(at offset: Offset) -> UITextPosition {
        position(from: beginningOfDocument, offset: Int(offset))!
    }
    
    @inlinable func positions(at offsets: Range<Offset>) -> UITextRange {
        let lower = position(at: offsets.lowerBound)
        let upper = position(from: lower, offset: offsets.count)!
        return textRange(from: lower, to: upper)!
    }
}

#endif
