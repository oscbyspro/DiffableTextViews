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
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let range = snapshot.indices(in: range)
            let replacement = Snapshot(string, only: .content)
                        
            // --------------------------------- //
            
            guard let nextSnapshot = source.style
                    .merge(snapshot, with: replacement, in: range)
                    .map(source.style.process) else { return false }
                        
            guard let nextValue = source.style
                    .parse(nextSnapshot)
                    .map(source.style.process) else { return false }
                        
            let nextSelection = selection.update(with: range.upperBound).translate(to: nextSnapshot)
            
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
            guard let offsets = textField.selection() else { return }

            // --------------------------------- //
            
            let nextSelection = selection.update(with: offsets)
            let nextSelectionOffset = nextSelection.range.map(bounds: \.offset)
            
            let changesToLowerBound = nextSelectionOffset.lowerBound - offsets.lowerBound
            let changesToUpperBound = nextSelectionOffset.upperBound - offsets.upperBound
            
            // --------------------------------- //
                        
            self.selection = nextSelection
            uiView.select(changes: (changesToLowerBound, changesToUpperBound))
        }

        // MARK: Utilities
        
        @inlinable func synchronize() {
            pull()
            push()
        }
        
        @inlinable func pull() {
            var nextValue = source.value.wrappedValue
            nextValue = source.style.process(nextValue)
            
            func makeSnapshot() -> Snapshot {
                uiView.isEditing ? source.style.snapshot(nextValue) : source.style.showcase(nextValue)
            }
            
            if value != nextValue {
                var nextSnapshot = makeSnapshot()
                nextSnapshot = source.style.process(nextSnapshot)
                
                let nextSelection = selection.translate(to: nextSnapshot)
                
                self.value = nextValue
                self.snapshot = nextSnapshot
                self.selection = nextSelection
            }
        }
        
        @inlinable func push() {
            uiView.write(text: snapshot.characters)
            uiView.select(range: selection.range.map(bounds: \.offset))
            
            DispatchQueue.main.async {
                // TODO: wait for apple to come up with a better solution
                TextFields.update(&self.source.value.wrappedValue, nonduplicate: self.value)
            }
        }
    }
}

#endif
