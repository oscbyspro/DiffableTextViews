////
////  OBETextField.swift
////  
////
////  Created by Oscar Byström Ericsson on 2021-09-24.
////
//
//import SwiftUI
//
//@available(iOS 13.0, *)
//public struct OBETextField<Adapter: OBETextFields.Adapter>: UIViewRepresentable where Adapter.Value: Equatable {
//    public typealias Value = Adapter.Value
//    
//    @Binding var value: Value
//    let adapter: Adapter
//    
//    // MARK: Initializers
//    
//    public init(value: Binding<Value>, adapter: Adapter) {
//        self._value = value
//        self.adapter = adapter
//    }
//    
//    // MARK: UIViewRepresentable
//    
//    public func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//    
//    public func makeUIView(context: Context) -> UITextField {
//        let uiView = UITextField()
//        
//        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        
//        uiView.delegate = context.coordinator
//        context.coordinator.uiView = uiView
//
//        return uiView
//    }
//    
//    public func updateUIView(_ uiView: UITextField, context: Context) {
//        update(coordinator: context.coordinator)
//    }
//    
//    // MARK: Helpers
//    
//    func update(coordinator: Coordinator) {
//        coordinator.parent = self
//        
//        guard value != coordinator.cache.value else { return }
//        
//        let newContent: String = adapter.content(value: value)
//        let newFormat: Symbols = adapter.format(content: newContent)
//        let newField: Field = coordinator.cache.field.updated(format: newFormat)
//                
//        coordinator.update(value: value, format: newFormat, field: newField)
//    }
//    
//    // MARK: Equatable
//    
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.value == rhs.value
//    }
//    
//    // MARK: Cache
//    
//    final class Cache {
//        var value: Value!
//        var format: Symbols
//        var selection: Range<Int>
//        
//        var field: Field!
//    }
//    
//    // MARK: Coordinator
//    
//    public final class Coordinator: NSObject, UITextFieldDelegate {
//        var uiView: UITextField!
//        var parent: OBETextField!
//        
//        let cache = Cache()
//        
//        // MARK: Helpers
//                
//        func update(value: Value?, format: Symbols, field: Field) {
//            cache.format = format
//            cache.field = selection
//            
//            uiView.set(text: format.characters)
//            uiView.set(selection: selection.offsets)
//
//            guard let value = value else { return }
//            
//            if value != cache.value {
//                cache.value = value
//            }
//            
//            if value != source.value {
//                source.value = value
//            }
//        }
//    }
//}
