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
// MARK: * Downstream
//*============================================================================*

@usableFromInline final class Downstream {
    @usableFromInline typealias Position = DiffableTextKit.Position<UTF16>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var wrapped = BasicTextField()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
   
    @inlinable init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var focus: Focus {
        Focus(wrapped.isEditing)
    }

    @inlinable var momentum: Bool {
        wrapped.directives.momentum
    }
    
    @inlinable var selection: Range<Position> {
        positions(wrapped.selectedTextRange!)
    }
    
    @inlinable var size: Position {
        position(wrapped.endOfDocument)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func update(text: String) {
        wrapped.text = text
    }
    
    @inlinable func update(selection: Range<Position>) {
        wrapped.selectedTextRange = offsets(selection)
    }
        
    @inlinable func transform(_ transform: (ProxyTextField) -> Void) {
        transform(ProxyTextField(wrapped))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Offsets -> Positions
    //=------------------------------------------------------------------------=

    /// - Complexity: O(1).
    @inlinable func position(_ offset: UITextPosition) -> Position {
        Position(wrapped.offset(from: wrapped.beginningOfDocument, to: offset))
    }
    
    /// - Complexity: O(1).
    @inlinable func positions(_ offsets: UITextRange) -> Range<Position> {
        position(offsets.start) ..< position(offsets.end)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Positions -> Offsets
    //=------------------------------------------------------------------------=
    
    /// - Complexity: O(1).
    @inlinable func offset(_ position: Position) -> UITextPosition {
        wrapped.position(from: wrapped.beginningOfDocument, offset: position.offset)!
    }
    
    /// - Complexity: O(1).
    @inlinable func offsets(_ positions: Range<Position>) -> UITextRange {
        wrapped.textRange(from: offset(positions.lowerBound), to: offset(positions.upperBound))!
    }
}

#endif
