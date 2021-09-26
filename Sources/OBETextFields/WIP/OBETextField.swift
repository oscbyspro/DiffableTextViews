////
////  OBETextField.swift
////  
////
////  Created by Oscar Byström Ericsson on 2021-09-24.
////

import SwiftUI

#warning("WIP")

@available(iOS 13.0, *)
public struct OBETextField<Adapter: OBETextFields.Adapter>: UIViewRepresentable, Equatable where Adapter.Value: Equatable {
    public typealias Value = Adapter.Value
    public typealias UIViewType = UITextField
    
    // MARK: Properties
    
    let adapter: Adapter
    let value: Binding<Value>
    
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
            let content: String = adapter.content(value: value.wrappedValue)
            let symbols: Symbols = adapter.format(content: content)
            coordinator.update(value: value.wrappedValue, symbols: symbols)
        }
    }
    
    // MARK: Equatable
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value.wrappedValue == rhs.value.wrappedValue
    }
    
    // MARK: Components

    public final class Coordinator: NSObject, UITextFieldDelegate {
        var uiView: UITextField!
        var parent: OBETextField!
                
        var field: Field!
        var value: Value!
        
        func update(value: Value, symbols: Symbols) {
            field.update(carets: symbols.carets)
            
            uiView.set(text: field.characters)
            uiView.set(selection: field.selection.offsets)
                
            updateLazily(&self.value, with: value)
            updateLazily(&parent.value.wrappedValue, with: value)
        }
        
        // MARK: Helpers
        
        func updateLazily(_ storage: inout Value, with newValue: Value) {
            if storage != newValue {
                storage = newValue
            }
        }
    }
}

