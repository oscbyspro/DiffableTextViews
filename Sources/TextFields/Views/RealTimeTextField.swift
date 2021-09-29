////
////  RealTimeTextField.swift
////  
////
////  Created by Oscar Byström Ericsson on 2021-09-24.
////

#if canImport(UIKit)

import SwiftUI

@available(iOS 13.0, *)
public struct RealTimeTextField<Adapter: TextFields.Adapter>: UIViewRepresentable, Equatable where Adapter.Value: Equatable {
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
        
        if coordinator.value != value.wrappedValue {
            let nextValue = value.wrappedValue
            let nextContent = adapter.transcribe(value: nextValue)
            let nextSnapshot = adapter.snapshot(content: nextContent)
            let nextSelection = coordinator.selection.updating(snapshot: nextSnapshot)
            
            // ------------------------------ //
            
            coordinator.update(value: nextValue, snapshot: nextSnapshot, selection: nextSelection)
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
        
        // MARK: Initializers
        
        @usableFromInline override init() {
            super.init()
            
            let snapshot = Snapshot()
            let selection = Selection(snapshot)
            
            self.snapshot = snapshot
            self.selection = selection
        }
        
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
            
            let nextPosition = selection
                .position(at: replacementIndices.upperBound)
            
            let nextSelection = selection
                .updating(position: nextPosition)
                .updating(snapshot: nextSnapshot)
            
            // ------------------------------ //
                                    
            update(value: nextValue, snapshot: nextSnapshot, selection: nextSelection)

            // ------------------------------ //

            return false
        }
        
        #warning("Should use change in offsets to update uiView, similar to how it is done in selection.")
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            guard let offsets = textField.selection() else { return }

            // ------------------------------ //
            
            let nextSelection = selection.updating(offsets: offsets)
            
            let nextOffsets = nextSelection.offsets
            let changesToLowerBound = nextOffsets.lowerBound - offsets.lowerBound
            let changesToUpperBound = nextOffsets.upperBound - offsets.upperBound
            
            // ------------------------------ //
            
            #warning("This is different, and a reason why model needs to be imporved.")
            
            self.selection = nextSelection
            uiView.select(changes: (changesToLowerBound, changesToUpperBound))
        }
        
        // MARK: Updaters
        
        #warning("Bad. Must update 'snapshot' AND 'selection' before updating 'uiView'.")
        #warning("This might warrant making a Field struct.")
        
        func update(value nextValue: Value?, snapshot nextSnapshot: Snapshot, selection nextSelection: Selection) {
            self.snapshot = nextSnapshot
            self.selection = nextSelection
            
            uiView.write(nextSnapshot.characters)
            uiView.select(offsets: nextSelection.offsets)
            
            if let nextValue = nextValue {
                value = nextValue
                #warning("This modifies state during view update, apparently.")
                TextFields.update(&parent.value.wrappedValue, nonduplicate: nextValue)
            }
        }
    }
}

#endif
