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
// MARK: * ActorTextField
//*============================================================================*

@usableFromInline final class ActorTextField {
    @usableFromInline typealias Wrapped = BasicTextField
    @usableFromInline typealias Position = DiffableTextViews.Position<UTF16>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let wrapped: BasicTextField
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ wrapped: Wrapped) { self.wrapped = wrapped }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var active: Bool {
        wrapped.isEditing
    }

    @inlinable var momentum: Bool {
        wrapped.intent != nil
    }
    
    @inlinable func selection() -> Range<Position> {
        positions(wrapped.selectedTextRange!)
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
}

//=----------------------------------------------------------------------------=
// MARK: + Conversions
//=----------------------------------------------------------------------------=

extension ActorTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Offsets -> Positions
    //=------------------------------------------------------------------------=

    @inlinable func position(_ offset: UITextPosition) -> Position {
        Position(wrapped.offset(from: wrapped.beginningOfDocument, to: offset))
    }
    
    @inlinable func positions(_ offsets: UITextRange) -> Range<Position> {
        position(offsets.start) ..< position(offsets.end)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Positions -> Offsets
    //=------------------------------------------------------------------------=
    
    @inlinable func offset(_ position: Position) -> UITextPosition {
        wrapped.position(from: wrapped.beginningOfDocument, offset: position.offset)!
    }
    
    @inlinable func offsets(_ positions: Range<Position>) -> UITextRange {
        wrapped.textRange(from: offset(positions.lowerBound), to: offset(positions.upperBound))!
    }
}

#endif
