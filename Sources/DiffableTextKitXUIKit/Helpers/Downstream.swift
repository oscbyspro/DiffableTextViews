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
// MARK: * Downstream
//*============================================================================*

@usableFromInline final class Downstream {
    @usableFromInline typealias Position = DiffableTextKit.Position<UTF16>

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var view = Base()
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
            
    @inlinable var text: String {
        get { view.text! }
        set { view.text  = newValue }
    }
    
    @inlinable var selection: Range<Position> {
        get { view.range(view.selectedTextRange!) }
        set { view.selectedTextRange = view.uirange(newValue) }
    }
    
    @inlinable var focus: Focus {
        Focus(view.isEditing)
    }

    @inlinable var momentums: Bool {
        view.intent.latest != nil
    }
    
    @inlinable var delegate: UITextFieldDelegate? {
        get { view.delegate }
        set { view.delegate = newValue }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var size: Position {
        view.position(view.endOfDocument)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Transformations
//=----------------------------------------------------------------------------=

extension Downstream {
    
    //=------------------------------------------------------------------------=
    // MARK: Direct
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    func placeholder(_ placeholder: String) {
        self.view.placeholder = placeholder
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Environment
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always)
    func autocorrectionDisabled(_ environment: EnvironmentValues) {
        let disabled = environment.diffableTextViews_autocorrectionDisabled
        self.view.autocorrectionType = disabled ? .no : .default
    }
    
    @inlinable @inline(__always)
    func font(_ environment: EnvironmentValues) {
        let font = environment.diffableTextViews_font
        self.view.font = UIFont(font ?? .body)
    }
    
    @inlinable @inline(__always)
    func foregroundColor(_ environment: EnvironmentValues) {
        let color = environment.diffableTextViews_foregroundColor
        self.view.textColor = UIColor(color ?? .primary)
    }
    
    @inlinable @inline(__always)
    func keyboardType(_ environment: EnvironmentValues) {
        self.view.keyboardType = environment.diffableTextViews_keyboardType
    }
    
    @inlinable @inline(__always)
    func multilineTextAlignment(_ environment: EnvironmentValues) {
        self.view.textAlignment = NSTextAlignment(
        environment.diffableTextViews_multilineTextAlignment,
        relativeTo: environment.layoutDirection)
    }

    @inlinable @inline(__always)
    func submitLabel(_ environment: EnvironmentValues) {
        self.view.returnKeyType = environment.diffableTextViews_submitLabel
    }
    
    @inlinable @inline(__always)
    func textContentType(_ environment: EnvironmentValues) {
        self.view.textContentType = environment.diffableTextViews_textContentType
    }
        
    @inlinable @inline(__always)
    func textFeldStyle(_ environment: EnvironmentValues) {
        self.view.borderStyle = environment.diffableTextViews_textFieldStyle
    }
    
    @inlinable @inline(__always)
    func textInputAutocapitalization(_ environment: EnvironmentValues) {
        let autocapitalization = environment.diffableTextViews_textInputAutocapitalization
        self.view.autocapitalizationType = autocapitalization ?? .sentences
    }

    @inlinable @inline(__always)
    func tint(_ environment: EnvironmentValues) {
        let color = environment.diffableTextViews_tint
        self.view.tintColor = UIColor(color ?? .accentColor)
    }
}

#endif
