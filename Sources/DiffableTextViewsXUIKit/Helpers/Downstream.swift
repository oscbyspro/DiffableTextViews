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
import SwiftUI
import UIKit

//*============================================================================*
// MARK: Declaration
//*============================================================================*

@usableFromInline final class Downstream {
    @usableFromInline typealias Position = DiffableTextKit.Position<UTF16>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var view = Base()
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
   
    @inlinable init() {
        self.view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var text: String {
        get { view.text! }
        set { view.text  = newValue }
    }
    
    @inlinable var selection: Range<Position> {
        get { positions(view.selectedTextRange!) }
        set { view.selectedTextRange = uipositions(newValue) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var focus: Focus {
        Focus(view.isEditing)
    }

    @inlinable var momentum: Bool {
        view.intent.momentum
    }
    
    @inlinable var size: Position {
        position(view.endOfDocument)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Utilities
//=----------------------------------------------------------------------------=

extension Downstream {

    //=------------------------------------------------------------------------=
    // MARK: Conversions
    //=------------------------------------------------------------------------=

    @inlinable func position(_ uiposition: UITextPosition) -> Position {
        Position(view.offset(from: view.beginningOfDocument, to: uiposition))
    }
    
    @inlinable func positions(_ uipositions: UITextRange) -> Range<Position> {
        position(uipositions.start) ..< position(uipositions.end)
    }

    @inlinable func uiposition(_ position: Position) -> UITextPosition {
        view.position(from: view.beginningOfDocument, offset: position.offset)!
    }
    
    @inlinable func uipositions(_ positions: Range<Position>) -> UITextRange {
        view.textRange(from: uiposition(positions.lowerBound), to: uiposition(positions.upperBound))!
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
    func setStyleValues<T>(_ style: T.Type) where T: DiffableTextStyle {
        style.onSetup(view)
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
        relativeTo: environment.layoutDirection)
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
