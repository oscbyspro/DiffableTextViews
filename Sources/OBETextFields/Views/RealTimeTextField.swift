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
            let content = adapter.translate(value: value.wrappedValue)
            let format = adapter.format(content: content)
            
            coordinator.update(value: value.wrappedValue, format: format)
        }
    }
    
    // MARK: Equatable
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value.wrappedValue == rhs.value.wrappedValue
    }
    
    // MARK: Components
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline var uiView: UITextField!
        @usableFromInline var parent: RealTimeTextField!
        
        @usableFromInline private(set) var value: Value!
        @usableFromInline private(set) var format: Format!
        @usableFromInline private(set) var selection: Selection!
        
        // MARK: UITextFieldDelegate
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            #error("WIP")
            
            let indices: Range<Format.Index> = format
                .indices(in: range.lowerBound ..< range.upperBound)
            
            let replacement: Format = string
                .reduce(appending: Symbol.content)
            
            let nextContent: String = format
                .replacing(indices, with: replacement)
                .reduce(appending: \.character, where: \.content)
            
            let nextValue: Value? = try? parent.adapter
                .parse(content: nextContent)
            
            let nextFormat: Format = parent.adapter
                .format(content: nextContent)
            
            let nextSelection: Selection = selection
                .updating(bounds: indices)
                .updating(format: nextFormat)
            
            update(format: nextFormat)
            update(selection: nextSelection)
            update(value: nextValue)
        
            return false
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            guard let offsets: Range<Int> = textField.selection() else { return }
            
            #error("WIP")
            
            let selection = selection.updating(bounds: <#T##Range<Format.Index>#>)
            
            field = field.updating(selection: offsets)
            uiView.set(selection: field.selection.offsets)
        }
        
        // MARK: Updaters
                
        @inlinable func update(format newValue: Format) {
            format = newValue
        
            uiView.set(text: format.characters)
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
