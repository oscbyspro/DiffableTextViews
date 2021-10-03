//
//  DiffableTextField.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#if canImport(UIKit)

import SwiftUI

@available(iOS 13.0, *)
public struct DiffableTextField<Style: DiffableTextStyle>: UIViewRepresentable, Equatable {
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

        uiView.delegate = context.coordinator
        context.coordinator.uiView = uiView

        return uiView
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        update(coordinator: context.coordinator)
    }
    
    // MARK: Helpers

    func update(coordinator: Coordinator) {
        coordinator.source = self
        
        if coordinator.value != value.wrappedValue {
            let nextValue = value.wrappedValue
            let nextSnapshot = style.snapshot(nextValue)
            let nextSelection = coordinator.selection.update(snapshot: nextSnapshot)
            
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
        @usableFromInline var source: DiffableTextField!
        @usableFromInline var uiView: UITextField!
        
        @usableFromInline private(set) var value: Value!
        @usableFromInline private(set) var snapshot = Snapshot()
        @usableFromInline private(set) var selection = Selection()
        
        // MARK: UITextFieldDelegate
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let replacementIndices = snapshot
                .indices(in: range)
            
            let replacementSnapshot = Snapshot
                .init(string, only: .content)
            
            let replacementProposal = snapshot
                .replace(replacementIndices, with: replacementSnapshot)
            
            // make new values
            
            let nextSnapshot = source.style
                .autocorrect(replacementProposal)
                        
            guard let nextValue = source.style.parse(nextSnapshot) else { return false }
                        
            let nextSelection = selection
                .update(position: replacementIndices.upperBound)
                .update(snapshot: nextSnapshot)
            
            // update with new values
                                    
            update(value: nextValue, snapshot: nextSnapshot, selection: nextSelection)

            return false
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            guard let offsets = textField.selection() else { return }

            // ------------------------------ //
            
            let nextSelection = selection.update(offsets: offsets)
            let nextSelectionOffset = nextSelection.offsets
            
            let changesToLowerBound = nextSelectionOffset.lowerBound - offsets.lowerBound
            let changesToUpperBound = nextSelectionOffset.upperBound - offsets.upperBound
            
            // ------------------------------ //
                        
            self.selection = nextSelection
            uiView.select(changes: (changesToLowerBound, changesToUpperBound))
        }
        
        // MARK: Updaters
        
        #warning("This might warrant making a Field struct.")
        
        func update(value nextValue: Value?, snapshot nextSnapshot: Snapshot, selection nextSelection: Selection) {
            self.snapshot = nextSnapshot
            self.selection = nextSelection
            
            uiView.write(nextSnapshot.characters)
            uiView.select(offsets: nextSelection.offsets)
            
            if let nextValue = nextValue {
                self.value = nextValue
                #warning("This modifies state during view update, apparently.")
                TextFields.update(&source.value.wrappedValue, nonduplicate: nextValue)
            }
        }
    }
}

#endif
