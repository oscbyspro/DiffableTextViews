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
    
    @usableFromInline var view = Base()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
   
    @inlinable init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var focus: Focus {
        Focus(view.isEditing)
    }

    @inlinable var momentum: Bool {
        view.intent.momentum
    }
    
    @inlinable var selection: Range<Position> {
        positions(view.selectedTextRange!)
    }
    
    @inlinable var size: Position {
        position(view.endOfDocument)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func update(text: String) {
        view.text = text
    }
    
    @inlinable func update(selection: Range<Position>) {
        view.selectedTextRange = offsets(selection)
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
        Position(view.offset(from: view.beginningOfDocument, to: offset))
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
        view.position(from: view.beginningOfDocument, offset: position.offset)!
    }
    
    /// - Complexity: O(1).
    @inlinable func offsets(_ positions: Range<Position>) -> UITextRange {
        view.textRange(from: offset(positions.lowerBound), to: offset(positions.upperBound))!
    }
}

//=----------------------------------------------------------------------------=
// MARK: Transformations
//=----------------------------------------------------------------------------=

extension Downstream {
    
    //=------------------------------------------------------------------------=
    // MARK: Upstream
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    func setTitle(_ title: String) {
        self.view.placeholder = title
    }
    
    @inlinable @inline(__always)
    func setSensibleValues<T>(_ style: T.Type) where T: DiffableTextStyle {
        style.setup(self.view)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Environment
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    func setDisableAutocorrection(_ environment: EnvironmentValues) {
        let disable = environment.diffableTextViews_disableAutocorrection
        self.view.autocorrectionType = (disable ?? false) ? .no : .default
    }
    
    @inlinable @inline(__always)
    func setFont(_ environment: EnvironmentValues) {
        let font = environment.diffableTextViews_font
        self.view.font = UIFont(font ?? .standard)
    }
    
    @inlinable @inline(__always)
    func setForegroundColor(_ environment: EnvironmentValues) {
        let color = environment.diffableTextViews_foregroundColor
        self.view.textColor = UIColor(color ?? .primary)
    }
    
    @inlinable @inline(__always)
    func setKeyboardType(_ environment: EnvironmentValues) {
        self.view.keyboardType = environment.diffableTextViews_keyboardType
    }
    
    @inlinable @inline(__always)
    func setMultilineTextAlignment(_ environment: EnvironmentValues) {
        self.view.textAlignment = NSTextAlignment(
        environment.diffableTextViews_multilineTextAlignment,
        relativeTo: UIUserInterfaceLayoutDirection(environment.layoutDirection))
    }

    @inlinable @inline(__always)
    func setSubmitLabel(_ environment: EnvironmentValues) {
        self.view.returnKeyType = environment.diffableTextViews_submitLabel
    }
    
    @inlinable @inline(__always)
    func setTextContentType(_ environment: EnvironmentValues) {
        self.view.textContentType = environment.diffableTextViews_textContentType
    }
        
    @inlinable @inline(__always)
    func setTextFeldStyle(_ environment: EnvironmentValues) {
        self.view.borderStyle = environment.diffableTextViews_textFieldStyle
    }
    
    @inlinable @inline(__always)
    func setTextInputAutocapitalization(_ environment: EnvironmentValues) {
        let autocapitalization = environment.diffableTextViews_textInputAutocapitalization
        self.view.autocapitalizationType = autocapitalization ?? .sentences
    }

    @inlinable @inline(__always)
    func setTint(_ environment: EnvironmentValues) {
        let color = environment.diffableTextViews_tint
        self.view.tintColor = UIColor(color ?? .accentColor)
    }
}

#endif
