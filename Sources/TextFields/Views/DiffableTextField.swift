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
            let nextSnapshot = style.format(nextValue)
            let nextSelection = coordinator.selection.convert(to: nextSnapshot)
            
            // ------------------------------ //
                        
            coordinator.update(value: nextValue, snapshot: nextSnapshot, selection: nextSelection)
        }
    }
    
    // MARK: Components
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline var source: DiffableTextField!
        @usableFromInline var uiView: UITextField!
        
        @usableFromInline private(set) var value: Value!
        @usableFromInline private(set) var snapshot = Layout()
        @usableFromInline private(set) var selection = Selection()
        
        // MARK: UITextFieldDelegate
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let range = snapshot.indices(in: range)
            let replacement = Layout(string, only: .content)
            let proposal = snapshot.replace(range, with: replacement)
            
            // try to make new values
            
            guard let nextLayout = source.style.accept(proposal) else { return false }
            guard let nextValue = source.style.parse(nextLayout) else { return false }
            let nextSelection = selection.update(with: range.upperBound).convert(to: nextLayout)
            
            // update with new values

            update(value: nextValue, snapshot: nextLayout, selection: nextSelection)

            return false
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            guard let offsets = textField.selection() else { return }

            // ------------------------------ //
            
            let nextSelection = selection.update(with: offsets)
            let nextSelectionOffset = nextSelection.range.map(bounds: \.offset)
            
            let changesToLowerBound = nextSelectionOffset.lowerBound - offsets.lowerBound
            let changesToUpperBound = nextSelectionOffset.upperBound - offsets.upperBound
            
            // ------------------------------ //
                        
            self.selection = nextSelection
            uiView.select(changes: (changesToLowerBound, changesToUpperBound))
        }
        
        // MARK: Updaters
        
        #warning("Remember to refactor this, eventually.")
        func update(value nextValue: Value?, snapshot nextSnapshot: Layout, selection nextSelection: Selection) {
            self.snapshot = nextSnapshot
            self.selection = nextSelection
            
            uiView.write(text: nextSnapshot.characters)
            uiView.select(range: nextSelection.range.map(bounds: \.offset))
            
            if let nextValue = nextValue {
                self.value = nextValue
                DispatchQueue.main.async {
                    // TODO: wait for apple to come up with a better solution
                    TextFields.update(&self.source.value.wrappedValue, nonduplicate: nextValue)
                }
            }
        }
    }
}

#endif
