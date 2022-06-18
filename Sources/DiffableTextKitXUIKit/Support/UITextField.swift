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
        Offset(self.offset(from: self.beginningOfDocument, to: position))
    }
    
    @inlinable func offsets(at positions: UITextRange) -> Range<Offset> {
        let lower = self.offset(from: self.beginningOfDocument, to: positions.start)
        let delta = self.offset(from: positions.start,          to: positions  .end)
        return Offset(lower) ..< Offset(lower + delta)
    }
    
    @inlinable func position(at offset: Offset) -> UITextPosition {
        self.position(from: self.beginningOfDocument, offset: Int(offset))!
    }
    
    @inlinable func positions(at offsets: Range<Offset>) -> UITextRange {
        let lower = self.position(from: self.beginningOfDocument, offset: Int(offsets.lowerBound))!
        let upper = self.position(from: lower, offset: Int(offsets.upperBound-offsets.lowerBound))!
        return self.textRange(from: lower, to: upper)!
    }
}

#endif
