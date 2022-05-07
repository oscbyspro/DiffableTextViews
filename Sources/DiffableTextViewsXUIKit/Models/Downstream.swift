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
import SwiftUI

//*============================================================================*
// MARK: Declaration
//*============================================================================*

/// A UITextField affordance layer.
@usableFromInline final class Downstream {
    @usableFromInline typealias Position = DiffableTextKit.Position<UTF16>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var wrapped = Base()
    
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
        wrapped.intent.momentum
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
}

//=----------------------------------------------------------------------------=
// MARK: Utilities
//=----------------------------------------------------------------------------=
    
extension Downstream {

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

//=----------------------------------------------------------------------------=
// MARK: Transformations
//=----------------------------------------------------------------------------=

extension Downstream {
    
    //=------------------------------------------------------------------------=
    // MARK: Style
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    func setSensibleValues<T>(_ style: T.Type) where T: DiffableTextStyle {
        style.setup(self.wrapped)
    }
    
    @inlinable @inline(__always)
    func setTitle(_ title: String) {
        self.wrapped.placeholder = title
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Environment
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    func setDisableAutocorrection(_ environment: EnvironmentValues) {
        let disable = environment.diffableTextViews_disableAutocorrection ?? false
        self.wrapped.autocorrectionType = disable ? .no : .default
    }
    
    @inlinable @inline(__always)
    func setFont(_ environment: EnvironmentValues) {
        self.wrapped.font = UIFont(environment.diffableTextViews_font ?? .body.monospaced())
    }
    
    @inlinable @inline(__always)
    func setForegroundColor(_ environment: EnvironmentValues) {
        self.wrapped.textColor = UIColor(environment.diffableTextViews_foregroundColor ?? .primary)
    }
    
    @inlinable @inline(__always)
    func setKeyboardType(_ environment: EnvironmentValues) {
        self.wrapped.keyboardType = environment.diffableTextViews_keyboardType
    }
    
    @inlinable @inline(__always)
    func setMultilineTextAlignment(_ environment: EnvironmentValues) {
        self.wrapped.textAlignment = NSTextAlignment(
        environment.multilineTextAlignment,
        relativeTo: UIUserInterfaceLayoutDirection(environment.layoutDirection))
    }

    @inlinable @inline(__always)
    func setSubmitLabel(_ environment: EnvironmentValues) {
        self.wrapped.returnKeyType = environment.diffableTextViews_submitLabel
    }
    
    @inlinable @inline(__always)
    func setTextContentType(_ environment: EnvironmentValues) {
        self.wrapped.textContentType = environment.diffableTextViews_textContentType
    }
        
    @inlinable @inline(__always)
    func setTextFeldStyle(_ environment: EnvironmentValues) {
        self.wrapped.borderStyle = environment.diffableTextViews_textFieldStyle
    }
    
    @inlinable @inline(__always)
    func setTextInputAutocapitalization(_ environment: EnvironmentValues) {
        let autocapitalization = environment.diffableTextViews_textInputAutocapitalization
        self.wrapped.autocapitalizationType = autocapitalization ?? .sentences
    }

    @inlinable @inline(__always)
    func setTint(_ environment: EnvironmentValues) {
        self.wrapped.tintColor = UIColor(environment.diffableTextViews_tint ?? .accentColor)
    }
}


#endif
