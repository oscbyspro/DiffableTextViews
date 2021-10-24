//
//  DiffableTextField.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#if canImport(UIKit)

import SwiftUI

public struct DiffableTextField<Style: DiffableTextStyle>: UIViewRepresentable {
    public typealias Value = Style.Value
    public typealias UIViewType = UITextField
    
    // MARK: Properties
    
    @usableFromInline let value: Binding<Value>
    @usableFromInline let style: Style

    // MARK: Initializers
    
    @inlinable public init(value: Binding<Value>, style: Style) {
        self.value = value
        self.style = style
    }
    
    @inlinable public init(value: Binding<Value>, style: () -> Style) {
        self.value = value
        self.style = style()
    }

    // MARK: UIViewRepresentable
    
    @inlinable public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    @inlinable public func makeUIView(context: Context) -> UITextField {
        let uiView = UITextField()
        
        // --------------------------------- //
        
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // --------------------------------- //
        
        context.coordinator.connect(uiView)
        
        // --------------------------------- //

        return uiView
    }
    
    @inlinable public func updateUIView(_ uiView: UITextField, context: Context) {
        context.coordinator.source = self
        context.coordinator.synchronize()
    }
    
    // MARK: Components
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Field = TextFields.Field<UTF16>
        @usableFromInline typealias Carets = TextFields.Carets<UTF16>
        
        @usableFromInline var uiView: UITextField!
        @usableFromInline var source: DiffableTextField!

        @usableFromInline let lock = Lock()
        @usableFromInline let cache = Cache()
                
        // MARK: Setup

        @inlinable func connect(_ uiView: UIViewType) {
            self.uiView = uiView
            self.uiView.delegate = self
        }
        
        // MARK: UITextFieldDelegate
        
        @inlinable public func textFieldDidBeginEditing(_ textField: UITextField) {
            synchronize()
        }
        
        @inlinable public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            synchronize()
        }
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            // --------------------------------- //
            
            guard !lock.isLocked else { return false }
            
            // --------------------------------- //
            
            let range = cache.field.indices(in: range)
            let input = Snapshot(string, only: .content)
                        
            // --------------------------------- //
            
            guard var snapshot = source.style.merge(cache.snapshot, with: input, in: range.map(bounds: \.rhs!)) else { return false }
            source.style.process(&snapshot)
  
            guard var value = source.style.parse(snapshot) else { return false }
            source.style.process(&value)
                        
            let field = cache.field.configure(selection: range.upperBound).translate(to: snapshot)
            
            // --------------------------------- //

            self.cache.value = value
            self.cache.field = field
                        
            // --------------------------------- //
                        
            push()
                                    
            // --------------------------------- //
                        
            return false
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            
            // --------------------------------- //
            
            guard !lock.isLocked else { return }
            
            // --------------------------------- //

            guard let newValue = textField.selection() else { return }
            
            // --------------------------------- //
            
            let field = cache.field.configure(selection: newValue)
            let changesToLowerBound = field.selection.lowerBound.offset - newValue.lowerBound
            let changesToUpperBound = field.selection.upperBound.offset - newValue.upperBound
            
            // --------------------------------- //
                                    
            self.cache.field = field
            self.uiView.setSelection(changes: (changesToLowerBound, changesToUpperBound))
        }

        // MARK: Update
        
        @inlinable func synchronize() {
            pull()
            push()
        }
        
        @inlinable func pull() {
            
            // --------------------------------- //
            
            guard !lock.isLocked else { return }
            
            // --------------------------------- //
            
            var value = source.value.wrappedValue
            source.style.process(&value)
            
            // --------------------------------- //
            
            guard !displays(value) else { return }
            
            // --------------------------------- //
            
            var snapshot = snapshot(value)
            source.style.process(&snapshot)
            
            // --------------------------------- //
            
            let field = cache.field.translate(to: snapshot)
                
            // --------------------------------- //
            
            self.cache.value = value
            self.cache.field = field
        }
        
        @inlinable func push() {
            
            // --------------------------------- //
            
            lock.perform {
                // lock is needed because setting a UITextFields's text
                // also sets its selection to its last possible position
                self.uiView.setText(cache.snapshot.characters)
                self.uiView.setSelection(cache.field.selection.map(bounds: \.offset))
            }
            
            // --------------------------------- //
            
            self.cache.edits = uiView.isEditing
            
            // --------------------------------- //
            
            DispatchQueue.main.async {
                // updates asynchronously to avoid the view update cycle
                if  self.source.value.wrappedValue != self.cache.value {
                    self.source.value.wrappedValue  = self.cache.value
                }
            }
        }
        
        // MARK: Update, Helpers
        
        @inlinable func displays(_ value: Value) -> Bool {
            cache.value == value && cache.edits == uiView.isEditing
        }
        
        @inlinable func snapshot(_ value: Value) -> Snapshot {
            uiView.isEditing ? source.style.snapshot(value) : source.style.showcase(value)
        }
        
        // MARK: Cache
        
        @usableFromInline final class Cache {
            
            // MARK: Properties
            
            @usableFromInline var value: Value!
            @usableFromInline var field: Field
            @usableFromInline var edits:  Bool
            
            // MARK: Initializers
            
            @inlinable init() {
                self.field = Field()
                self.edits = false
            }
            
            // MARK: Getters
            
            @inlinable var carets: Carets {
                field.carets
            }
            
            @inlinable var snapshot: Snapshot {
                carets.snapshot
            }
        }

        // MARK: Lock
        
        @usableFromInline final class Lock {
            
            // MARK: Properties
            
            @usableFromInline private(set) var isLocked: Bool = false
            
            // MARK: Utilities
            
            @inlinable func perform(action: () -> Void) {
                let state = isLocked
                self.isLocked = true
                
                action()
                
                self.isLocked = state
            }
        }
    }
}

// MARK: - NumericTextStyle

extension DiffableTextField {
    
    // MARK: Initializers
    
    @inlinable public init<T: NumericTextSchematic>(value: Binding<T>, style: T.NumericTextStyle) where Style == T.NumericTextStyle {
        self.init(value: value, style: style)
    }
    
    @inlinable public init<T: NumericTextSchematic>(value: Binding<T>, style: () -> T.NumericTextStyle) where Style == T.NumericTextStyle {
        self.init(value: value, style: style)
    }
}

#endif
