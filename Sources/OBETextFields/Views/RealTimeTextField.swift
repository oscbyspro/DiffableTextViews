////
////  OBETextField.swift
////  
////
////  Created by Oscar Byström Ericsson on 2021-09-24.
////

import SwiftUI

#warning("WIP")

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
        var parent: RealTimeTextField!
                
        var field: Field!
        var value: Value!
        
        // MARK: Protocol: UITextFieldDelegate
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let indices: Symbols.Indices = field.carets.base
                .indices(in: range.lowerBound ..< range.upperBound)
            
            let replacement: Symbols = string
                .reduce(appending: Symbol.content)
            
            let nextContent: String = field.carets.base
                .replacing(indices.startIndex ..< indices.endIndex, with: replacement)
                .reduce(appending: \.character, where: { $0.attribute == .content })
            
            let nextValue: Value? = try? parent.adapter
                .value(content: nextContent)
            
            let nextSymbols: Symbols = parent.adapter
                .format(content: nextContent)
            
//            let nextSelection = field................................
//
//            let nextSelection: Selection = cache.selection
//                .moved(to: indices.upperBound ..< indices.upperBound)
//                .moved(to: nextFormat.carets)
//
//            update(value: nextValue, format: nextFormat, selection: nextSelection)
//
            #error("WIP")
            
            return false
        }
        
        #warning("Unsure if it works correctly. Untested. Improvised.")
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            guard let offsets: Range<Int> = textField.selection() else { return }
            
            let indices: Carets.Indices = field.carets.indices(in: offsets)
            let selection = Field.Selection(indices)
            let uiSelection: Range<Int> = selection.offsets
            
            field.update(selection: selection)
            uiView.set(selection: uiSelection)
        }
        
        // MARK: Updaters
        
        func update(value: Value, symbols: Symbols) {
            field.update(symbols: symbols)
            
            uiView.set(text: field.symbols.characters)
            uiView.set(selection: field.selection.offsets)
                
            updateLazily(&self.value, with: value)
            updateLazily(&parent.value.wrappedValue, with: value)
        }
    }
}
