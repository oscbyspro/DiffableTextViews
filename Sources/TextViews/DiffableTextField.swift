//
//  DiffableTextField.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#if os(iOS)

import SwiftUI

public struct DiffableTextField<Style: DiffableTextStyle>: UIViewRepresentable {
    public typealias UIViewType = OBETextField
    public typealias Value = Style.Value
    
    // MARK: Properties
    
    @usableFromInline let value: Binding<Value>
    @usableFromInline let style: Style

    // MARK: Initializers
    
    @inlinable public init(value: Binding<Value>, style: Style) {
        self.value = value
        self.style = style
    }

    @inlinable public init(value: Binding<Value>, style: () -> Style) {
        self.value = value
        self.style = style()
    }

    // MARK: UIViewRepresentable
    
    @inlinable public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    @inlinable public func makeUIView(context: Context) -> UIViewType {
        let uiView = OBETextField()
        
        // --------------------------------- //
        
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // --------------------------------- //
        
        context.coordinator.connect(uiView)
        
        // --------------------------------- //

        return uiView
    }
    
    @inlinable public func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.source = self
        context.coordinator.synchronize()
    }
    
    // MARK: Components
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Layout = UTF16
        @usableFromInline typealias Field  = TextViews.Field<Layout>
        @usableFromInline typealias Carets = TextViews.Carets<Layout>
        @usableFromInline typealias Offset = TextViews.Offset<Layout>
        
        // MARK: Properties
        
        @usableFromInline var uiView: Proxy<UIViewType>!
        @usableFromInline var source: DiffableTextField!

        @usableFromInline let lock  = Lock()
        @usableFromInline let cache = Cache()
                
        // MARK: Setup

        @inlinable func connect(_ uiView: UIViewType) {
            uiView.delegate = self            
            self.uiView = Proxy(uiView)
        }
        
        // MARK: UITextFieldDelegate
        
        @inlinable public func textFieldDidBeginEditing(_ textField: UITextField) {
            synchronize()
        }
        
        @inlinable public func textFieldDidEndEditing(_ textField: UITextField) {
            synchronize()
        }
        
        @inlinable public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            synchronize()
        }
        
        @inlinable public func textField(_ textField: UITextField, shouldChangeCharactersIn nsRange: NSRange, replacementString string: String) -> Bool {
                        
            // --------------------------------- //
            
            let offsets = Offset(at: nsRange.lowerBound) ..< Offset(at: nsRange.upperBound)
            let range = cache.field.indices(in: offsets)
            let input = Snapshot(string, only: .intuitive(.content))
            
            // --------------------------------- //

            guard var snapshot = source.style.merge(cache.snapshot, with: input, in: range.map(bounds: \.rhs!)) else { return false }
            source.style.process(&snapshot)
  
            guard var value = source.style.parse(snapshot) else { return false }
            source.style.process(&value)
                        
            let field = cache.field.configure(selection: range.upperBound, intent: nil).configure(carets: snapshot)
            
            // --------------------------------- //
            
            DispatchQueue.main.async {
                // async makes special commands (like: option + delete) process first
                self.cache.value = value
                self.cache.field = field
                self.push(asynchronously: false)
            }
                                    
            // --------------------------------- //
                        
            return false
        }

        @inlinable public func textFieldDidChangeSelection(_ textField: UITextField) {
            
            // --------------------------------- //
            
            guard !lock.isLocked else { return }
            
            // --------------------------------- //
                        
            let offsets = uiView.selection()
            let intent = uiView.wrapped.intent?.direction
            let field = cache.field.configure(selection: offsets, intent: intent)
            let selection = field.selection.map(bounds: \.offset)
            
            // --------------------------------- //
            
            self.cache.field = field
            
            // --------------------------------- //
            
            guard selection != offsets else { return }
            
            // --------------------------------- //
            
            lock.perform {
                self.uiView.select(selection)
            }
        }

        // MARK: Update
        
        @inlinable func synchronize() {
            if pull() { push() }
        }
        
        @inlinable func pull() -> Bool {
            
            // --------------------------------- //
            
            var value = source.value.wrappedValue
            source.style.process(&value)
            
            // --------------------------------- //
            
            guard !displays(value) else { return false }
            
            // --------------------------------- //
            
            var snapshot = snapshot(value)
            source.style.process(&snapshot)
            
            // --------------------------------- //
            
            let field = cache.field.configure(carets: snapshot)
                
            // --------------------------------- //
            
            self.cache.value = value
            self.cache.field = field
            
            // --------------------------------- //
            
            return true
        }
                 
        @inlinable func push(asynchronously: Bool = true) {
                    
            // --------------------------------- //
                                    
            lock.perform {
                // write and select both call textFieldDidChangeSelection(_:)
                self.uiView.write(cache.snapshot.characters)
                self.uiView.select(cache.field.selection.map(bounds: \.offset))
            }
            
            // --------------------------------- //
            
            self.cache.edits = self.uiView.edits

            // --------------------------------- //
            
            perform(asynchronously: asynchronously) {
                // async avoids view update loop
                self.nonduplicate(update: &self.source.value.wrappedValue, with: self.cache.value)
            }
        }
        
        // MARK: Update, Helpers
        
        @inlinable func displays(_ value: Value) -> Bool {
            cache.value == value && cache.edits == uiView.edits
        }
        
        @inlinable func snapshot(_ value: Value) -> Snapshot {
            uiView.edits ? source.style.snapshot(value) : source.style.showcase(value)
        }

        @inlinable func nonduplicate(update storage: inout Value, with newValue: Value) {
            if storage != newValue { storage = newValue }
        }
        
        @inlinable func perform(asynchronously: Bool, action: @escaping () -> Void) {
            if asynchronously { DispatchQueue.main.async(execute: action) } else { action() }
        }
        
        // MARK: Cache
        
        @usableFromInline final class Cache {
            
            // MARK: Properties
            
            @usableFromInline var value: Value!
            @usableFromInline var field: Field
            @usableFromInline var edits:  Bool
            
            // MARK: Initializers
            
            @inlinable init() {
                self.field = Field()
                self.edits = false
            }
            
            // MARK: Getters
            
            @inlinable var snapshot: Snapshot {
                field.carets.snapshot
            }
        }

        // MARK: Lock
        
        @usableFromInline final class Lock {
            
            // MARK: Properties
            
            @usableFromInline private(set) var isLocked: Bool = false
            
            // MARK: Utilities
            
            @inlinable func perform(action: () -> Void) {
                let state = isLocked
                self.isLocked = true
                
                action()
                
                self.isLocked = state
            }
        }
    }
}

#endif
