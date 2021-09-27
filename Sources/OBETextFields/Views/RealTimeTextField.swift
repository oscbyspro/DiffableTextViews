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
            let content = adapter.content(value: value.wrappedValue)
            let format = adapter.format(content: content)
            let field = coordinator.field.updating(format: format)
            
            coordinator.update(value: value.wrappedValue, field: field)
        }
    }
    
    // MARK: Equatable
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value.wrappedValue == rhs.value.wrappedValue
    }
    
    // MARK: Components
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        var uiView: UITextField!
        var parent: RealTimeTextField!
        
        var value: Value!
        var format: Format!
        var selection: Selection!
        
        // MARK: UITextFieldDelegate
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            #error("WIP")
            
            let indices: Range<Format.Index> = field.format
                .indices(in: range.lowerBound ..< range.upperBound)
            
            let replacement: Format = string
                .reduce(appending: Symbol.content)
            
            let nextContent: String = field.format
                .replacing(indices, with: replacement)
                .reduce(appending: \.character, where: \.content)
            
            let nextValue: Value? = try? parent.adapter
                .value(content: nextContent)
            
            let nextFormat: Format = parent.adapter
                .format(content: nextContent)
            
            let nextField: Field = field
                .updating(selection: field.selection.carets.index)
                .updating(format: nextFormat)
            
            update(value: nextValue, field: nextField)
        
            return false
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            guard let offsets: Range<Int> = textField.selection() else { return }
            
            field = field.updating(selection: offsets)
            uiView.set(selection: field.selection.offsets)
        }
        
        // MARK: Updaters
        
        func update(value nextValue: Value?, field nextField: Field) {
            field = nextField
            
            #warning("format should be optional and text should only be updated if format changes")
            
            uiView.set(text: nextField.format.characters)
            uiView.set(selection: nextField.selection.offsets)
            
            if let nextValue = nextValue {
                value = nextValue
                OBETextFields.update(&parent.value.wrappedValue, nonduplicate: nextValue)
            }
        }
    }
}
