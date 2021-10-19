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
        
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        context.coordinator.connect(uiView)

        return uiView
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        context.coordinator.source = self
        context.coordinator.synchronize()
    }
    
    // MARK: Components
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline var source: DiffableTextField!
        @usableFromInline var uiView: UITextField!
        
        @usableFromInline let lock = Lock()
        
        @usableFromInline private(set) var value: Value!
        @usableFromInline private(set) var snapshot = Snapshot()
        @usableFromInline private(set) var selection = Selection()
        
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
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn bounds: NSRange, replacementString string: String) -> Bool {
            
            // --------------------------------- //
            
            guard !lock.isLocked else { return false }
            
            // --------------------------------- //
            
            let bounds = snapshot.indices(in: bounds)
            let replacement = Snapshot(string, only: .content)
                        
            // --------------------------------- //
            
            guard let nextSnapshot = source.style
                    .merge(snapshot, with: replacement, in: bounds)
                    .map(source.style.process) else { return false }
                        
            guard let nextValue = source.style
                    .parse(nextSnapshot)
                    .map(source.style.process) else { return false }
                        
            let nextSelection = selection.update(with: bounds.upperBound).translate(to: nextSnapshot)
            
            // --------------------------------- //
            
            self.value = nextValue
            self.snapshot = nextSnapshot
            self.selection = nextSelection
                        
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

            // --------------------------------- //
            
            let nextSelection = selection.update(with: offsets)
            let nextSelectionOffset = nextSelection.offsets
            
            let changesToLowerBound = nextSelectionOffset.lowerBound - offsets.lowerBound
            let changesToUpperBound = nextSelectionOffset.upperBound - offsets.upperBound
            
            // --------------------------------- //
                                    
            self.selection = nextSelection
            uiView.setSelection(changes: (changesToLowerBound, changesToUpperBound))
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
            
            var nextValue = source.value.wrappedValue
            nextValue = source.style.process(nextValue)
                        
            var nextSnapshot = uiView.isEditing
            ? source.style.snapshot(nextValue)
            : source.style.showcase(nextValue)
            nextSnapshot = source.style.process(nextSnapshot)
            
            let nextSelection = selection.translate(to: nextSnapshot)
                
            // --------------------------------- //
            
            self.value = nextValue
            self.snapshot = nextSnapshot
            self.selection = nextSelection
        }
        
        @inlinable func push() {
            
            // --------------------------------- //
            
            lock.perform {
                // lock is needed because setting a UITextFields's text
                // also sets its selection to its last possible position
                self.uiView.setText(snapshot.characters)
                self.uiView.setSelection(selection.offsets)
            }
            
            // --------------------------------- //
            
            DispatchQueue.main.async {
                // TODO: wait for apple to come up with a better solution
                TextFields.update(&self.source.value.wrappedValue, nonduplicate: self.value)
            }
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

#endif
