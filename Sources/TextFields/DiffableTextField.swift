//
//  DiffableTextField.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#if canImport(UIKit)

import SwiftUI

@available(iOS 13.0, *)
public struct DiffableTextField<Style: DiffableTextStyle>: UIViewRepresentable {
    public typealias Value = Style.Value
    public typealias UIViewType = UITextField
    
    // MARK: Properties
    
    @usableFromInline let value: Binding<Value>
    @usableFromInline let style: Style

    // MARK: Initializers
    
    public init(value: Binding<Value>, style: Style) {
        self.value = value
        self.style = style
    }
    
    // MARK: UIViewRepresentable
    
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    public func makeUIView(context: Context) -> UITextField {
        let uiView = UITextField()
        
        // --------------------------------- //
        
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // --------------------------------- //
        
        context.coordinator.connect(uiView)
        
        // --------------------------------- //

        return uiView
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        context.coordinator.source = self
        context.coordinator.synchronize()
    }
    
    // MARK: Components
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
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
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            synchronize()
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            synchronize()
        }
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            // --------------------------------- //
            
            guard !lock.isLocked else { return false }
            
            // --------------------------------- //
            
            let range = cache.snapshot.indices(in: range)
            let input = Snapshot(string, only: .content)
                        
            // --------------------------------- //
            
            guard let snapshot = source.style
                    .merge(cache.snapshot, with: input, in: range)
                    .map(source.style.process) else { return false }
                        
            guard let value = source.style
                    .parse(snapshot)
                    .map(source.style.process) else { return false }
                        
            let selection = cache.selection.configure(with: range.upperBound).translate(to: snapshot)
            
            // --------------------------------- //
            
            self.cache.value = value
            self.cache.snapshot = snapshot
            self.cache.selection = selection
                        
            // --------------------------------- //
                        
            push()
                                    
            // --------------------------------- //
                        
            return false
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            
            // --------------------------------- //
            
            guard !lock.isLocked else { return }
                        
            // --------------------------------- //

            guard let offsets = textField.selection() else { return }
                        
            let selection = cache.selection.configure(with: offsets)
                        
            let changesToLowerBound = selection.range.lowerBound.offset - offsets.lowerBound
            let changesToUpperBound = selection.range.upperBound.offset - offsets.upperBound
            
            // --------------------------------- //
                                    
            self.cache.selection = selection
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
            value = source.style.process(value)
            
            // --------------------------------- //
            
            guard !displays(value) else { return }
            
            // --------------------------------- //
            
            var snapshot = snapshot(value)
            snapshot = source.style.process(snapshot)
            
            // --------------------------------- //
            
            let selection = cache.selection.translate(to: snapshot)
                
            // --------------------------------- //
            
            self.cache.value = value
            self.cache.snapshot = snapshot
            self.cache.selection = selection
        }
        
        @inlinable func push() {
            
            // --------------------------------- //
            
            lock.perform {
                // lock is needed because setting a UITextFields's text
                // also sets its selection to its last possible position
                self.uiView.setText(cache.snapshot.characters)
                self.uiView.setSelection(cache.selection.offsets)
            }
            
            // --------------------------------- //
            
            self.cache.editable = uiView.isEditing
            
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
            cache.value == value && cache.editable == uiView.isEditing
        }
        
        @inlinable func snapshot(_ value: Value) -> Snapshot {
            uiView.isEditing ? source.style.snapshot(value) : source.style.showcase(value)
        }
        
        // MARK: Cache
        
        @usableFromInline final class Cache {
            
            // MARK: Properties
                        
            @usableFromInline var value: Value!
            @usableFromInline var snapshot = Snapshot()
            @usableFromInline var selection = Selection()
            
            @usableFromInline var editable = false
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

#endif

