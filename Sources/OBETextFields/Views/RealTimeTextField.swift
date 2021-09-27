////
////  RealTimeTextField.swift
////  
////
////  Created by Oscar Byström Ericsson on 2021-09-24.
////

import SwiftUI

@available(iOS 13.0, *)
public struct RealTimeTextField<Adapter: OBETextFields.Adapter>: UIViewRepresentable, Equatable where Adapter.Value: Equatable {
    public typealias Value = Adapter.Value
    public typealias UIViewType = UITextField
    
    // MARK: Properties
    
    @usableFromInline let adapter: Adapter
    @usableFromInline let value: Binding<Value>
    
    // MARK: Initializers
    
    public init(value: Binding<Value>, adapter: Adapter) {
        self.value = value
        self.adapter = adapter
    }
    
    // MARK: UIViewRepresentable
    
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    public func makeUIView(context: Context) -> UITextField {
        let uiView = UITextField()

        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        uiView.delegate = context.coordinator
        context.coordinator.uiView = uiView

        return uiView
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        update(coordinator: context.coordinator)
    }
    
    // MARK: Helpers

    func update(coordinator: Coordinator) {
        coordinator.parent = self
        
        if value.wrappedValue != coordinator.value {
            let nextContent = adapter.transcribe(value: value.wrappedValue)
            let nextSnapshot = adapter.snapshot(content: nextContent)
            let nextSelection = coordinator.selection.updating(snapshot: nextSnapshot)
            
            // ------------------------------ //
            
            coordinator.update(snapshot: nextSnapshot)
            coordinator.update(selection: nextSelection)
        }
    }
    
    // MARK: Equatable
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value.wrappedValue == rhs.value.wrappedValue
    }
    
    // MARK: Components
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline var parent: RealTimeTextField!
        @usableFromInline var uiView: UITextField!
        
        @usableFromInline private(set) var snapshot: Snapshot!
        @usableFromInline private(set) var selection: Selection!
        @usableFromInline private(set) var value: Value!
        
        // MARK: UITextFieldDelegate
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let replacementIndices = snapshot
                .indices(in: range.lowerBound ..< range.upperBound)
            
            let replacementSnapshot = string
                .reduce(into: Snapshot(), appending: Symbol.content)
            
            let nextContent = snapshot
                .replacing(replacementIndices, with: replacementSnapshot)
                .reduce(into: String(), appending: \.character, where: \.content)
            
            // ------------------------------ //
            
            guard let nextValue = try? parent.adapter.parse(content: nextContent) else { return false }
                        
            // ------------------------------ //
            
            let nextSnapshot = parent.adapter
                .snapshot(content: nextContent)
            
            let nextLocation = replacementIndices
                .upperBound
            
            let nextSelection = selection
                .updating(location: nextLocation)
                .updating(snapshot: nextSnapshot)
            
            // ------------------------------ //
                        
            update(snapshot: nextSnapshot)
            update(selection: nextSelection)
            update(value: nextValue)
            
            // ------------------------------ //

            return false
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            guard let offsets = textField.selection() else { return }

            // ------------------------------ //

            let nextSelection = selection.updating(bounds: offsets)
            
            // ------------------------------ //
            
            update(selection: nextSelection)
        }
        
        // MARK: Updaters
                
        @inlinable func update(snapshot newValue: Snapshot) {
            snapshot = newValue
            uiView.set(text: snapshot.characters)
        }
        
        @inlinable func update(selection newValue: Selection) {
            selection = newValue
            uiView.set(selection: newValue.offsets)
        }
        
        @inlinable func update(value newValue: Value?) {
            guard let newValue = newValue else { return }
            
            value = newValue
            OBETextFields.update(&parent.value.wrappedValue, nonduplicate: newValue)
        }
    }
}
