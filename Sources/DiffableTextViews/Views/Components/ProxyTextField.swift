//
//  ProxyTextField.swift
//  
//
//  Created by Oscar Byström Ericsson on 2021-09-26.
//

#if canImport(UIKit)

import UIKit

//*============================================================================*
// MARK: * ProxyTextField
//*============================================================================*

/// An affordance layer wrapping a UITextField object.
/// Makes it easier to enforce UITextField's UTF-16 layout, as well as which properties and methods may be called.
///
/// ---------------------------------
///
/// - UITextField.text is never nil.
/// - UITextField.selectedTextRange is never nil.
/// - UITextField.font is never nil.
///
/// ---------------------------------
///
public final class ProxyTextField {
    @usableFromInline typealias Wrapped = BasicTextField
    @usableFromInline typealias Offset = DiffableTextViews.Offset<UTF16>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let wrapped: Wrapped
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ wrapped: Wrapped) {
        self.wrapped = wrapped
    }
    
    //*========================================================================*
    // MARK: * Configuration
    //*========================================================================*
    
    public struct Transformations {
        
        //=--------------------------------------------------------------------=
        // MARK: Properties
        //=--------------------------------------------------------------------=
        
        @usableFromInline var transformations: [(ProxyTextField) -> Void]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init() {
            self.transformations = []
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable mutating func add(_ transformation: @escaping (ProxyTextField) -> Void) {
            self.transformations.append(transformation)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @discardableResult @inlinable func apply(on proxy: ProxyTextField) -> Bool {
            for transformation in transformations {
                transformation(proxy)
            }
            
            return !transformations.isEmpty
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: ProxyTextField - Internal
//=----------------------------------------------------------------------------=

extension ProxyTextField {
    
    //
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var text: String {
        wrapped.text!
    }
    
    #warning("Make this a property, maybe.")
    /// - Complexity: O(1).
    @inlinable func selection() -> Range<Offset> {
        offsets(in: wrapped.selectedTextRange!)
    }
    
    @inlinable var intent: Direction? {
        wrapped.intent
    }
    
    @inlinable var mode: Mode {
        wrapped.isEditing ? .editable : .showcase
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// - Complexity: High.
    @inlinable func update(text: String) {
        wrapped.text = text
    }
        
    /// - Complexity: High.
    @inlinable func update(selection: Range<Offset>) {
        wrapped.selectedTextRange = positions(in: selection)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Offsets
    //=------------------------------------------------------------------------=

    /// - Complexity: O(1).
    @inlinable func offsets(in range: UITextRange) -> Range<Offset> {
        offset(at: range.start) ..< offset(at: range.end)
    }
    
    /// - Complexity: O(1).
    @inlinable func offset(at position: UITextPosition) -> Offset {
        .init(at: wrapped.offset(from: wrapped.beginningOfDocument, to: position))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Positions
    //=------------------------------------------------------------------------=
    
    /// - Complexity: O(1).
    @inlinable func position(at offset: Offset) -> UITextPosition {
        wrapped.position(from: wrapped.beginningOfDocument, offset: offset.units)!
    }
    
    /// - Complexity: O(1).
    @inlinable func positions(in offsets: Range<Offset>) -> UITextRange {
        wrapped.textRange(from: position(at: offsets.lowerBound), to: position(at: offsets.upperBound))!
    }
}

//=----------------------------------------------------------------------------=
// MARK: ProxyTextField - Actions
//=----------------------------------------------------------------------------=

public extension ProxyTextField {
    
    // MARK: Resign
    
    @inlinable func resign() {
        wrapped.resignFirstResponder()
    }
}

//=----------------------------------------------------------------------------=
// MARK: ProxyTextField - Transformations
//=----------------------------------------------------------------------------=

public extension ProxyTextField {
    
    //=------------------------------------------------------------------------=
    // MARK: Autocorrect
    //=------------------------------------------------------------------------=
    
    @inlinable func autocorrect(_ autocorrect: UITextAutocorrectionType) {
        wrapped.autocorrectionType = autocorrect
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Entry
    //=------------------------------------------------------------------------=
        
    @inlinable func entry(secure: Bool) {
        wrapped.isSecureTextEntry = secure
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Font
    //=------------------------------------------------------------------------=
    
    @inlinable func font(_ font: UIFont) {
        wrapped.font = font
    }
        
    @inlinable func font(_ font: OBEFont) {
        wrapped.font = UIFont(font)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Keyboard
    //=------------------------------------------------------------------------=
    
    @inlinable func keyboard(_ keyboard: UIKeyboardType) {
        wrapped.keyboardType = keyboard
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Key
    //=------------------------------------------------------------------------=
    
    @inlinable func key(return: UIReturnKeyType) {
        wrapped.returnKeyType = `return`
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tint
    //=------------------------------------------------------------------------=
        
    @inlinable func tint(color: UIColor) {
        wrapped.tintColor = color
    }
}

#endif
