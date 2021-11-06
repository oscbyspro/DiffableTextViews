//
//  DiffableTextField.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#if os(iOS)

import SwiftUI

public struct DiffableTextField<Style: DiffableTextStyle>: UIViewRepresentable {
    public typealias UIViewType = CoreTextField
    public typealias Value = Style.Value
    public typealias Proxy = ProxyTextField<UIViewType>
    
    // MARK: Properties
    
    @usableFromInline let value: Binding<Value>
    @usableFromInline let style: Style

    @usableFromInline var setup:  (Proxy) -> Void = { _ in }
    @usableFromInline var update: (Proxy) -> Void = { _ in }
    @usableFromInline var submit: (Proxy) -> Void = { _ in }

    // MARK: Initializers
    
    @inlinable public init(value: Binding<Value>, style: Style) {
        self.value = value
        self.style = style
    }
    
    @inlinable public init(value: Binding<Value>, style: () -> Style) {
        self.value = value
        self.style = style()
    }
    
    // MARK: Transformations
    
    @inlinable public func setup(_ setup: @escaping (Proxy) -> Void) -> Self {
        configure({ $0.setup = setup })
    }
    
    @inlinable public func update(_ update: @escaping (Proxy) -> Void) -> Self {
        configure({ $0.update = update })
    }
    
    @inlinable public func submit(_ submit: @escaping (Proxy) -> Void) -> Self {
        configure({ $0.submit = submit })
    }
    
    @inlinable internal func configure(_ configure: (inout Self) -> Void) -> Self {
        var copy = self; configure(&copy); return copy
    }

    // MARK: UIViewRepresentable
    
    @inlinable public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    @inlinable public func makeUIView(context: Context) -> UIViewType {
        let uiView = CoreTextField()
        
        // --------------------------------- //
        
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // --------------------------------- //
        
        context.coordinator.connect(uiView)
        
        // --------------------------------- //
        
        setup(context.coordinator.uiView)
        
        // --------------------------------- //

        return uiView
    }
    
    @inlinable public func updateUIView(_ uiView: UIViewType, context: Context) {
        update(context.coordinator.uiView)
        context.coordinator.source = self
        context.coordinator.synchronize(.async)
    }
    
    // MARK: Coordinator
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Scheme = UTF16
        @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>
        @usableFromInline typealias Field  = DiffableTextViews.Field<Scheme>
        @usableFromInline typealias Cache  = DiffableTextViews.Cache<Scheme, Value>
        
        // MARK: Properties
        
        @usableFromInline var source: DiffableTextField!
        @usableFromInline var uiView: ProxyTextField<UIViewType>!

        @usableFromInline let lock  = Lock()
        @usableFromInline let cache = Cache()
                
        // MARK: Setup

        @inlinable func connect(_ uiView: UIViewType) {
            uiView.delegate = self            
            self.uiView = ProxyTextField(uiView)
        }
        
        // MARK: Delegate: Submit
        
        @inlinable public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            source.submit(uiView)
            return false
        }
        
        // MARK: Delegate: Edits
        
        @inlinable public func textFieldDidBeginEditing(_ textField: UITextField) {
            synchronize()
        }
        
        @inlinable public func textFieldDidEndEditing(_ textField: UITextField) {
            synchronize()
        }
        
        @inlinable public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            synchronize()
        }
        
        // MARK: Delegate: Inputs
        
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
                self.push([.upstream, .downstream])
            }
                                    
            // --------------------------------- //
            
            return false
        }
        
        // MARK: Delegate: Selection

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

        // MARK: Synchronize
        
        @inlinable func synchronize(_ update: Update = []) {
            push(pull().union(update))
        }
        
        // MARK: Synchronize: Pull
        
        @inlinable func pull() -> Update {
            var update = Update()
            
            // --------------------------------- //
            
            var value = source.value.wrappedValue
            source.style.process(&value)
            
            // --------------------------------- //
        
            if !upstream(has: value) {
                update.insert(.upstream)
            }
         
            // --------------------------------- //
            
            if !downstream(has: value) {
                update.insert(.downstream)

                // --------------------------------- //
                
                var snapshot = snapshot(value)
                source.style.process(&snapshot)
                
                // --------------------------------- //
                
                let field = cache.field.configure(carets: snapshot)
                                
                // --------------------------------- //
                
                self.cache.value = value
                self.cache.field = field
            }
            
            // --------------------------------- //
                
            return update
        }
        
        // MARK: Synchronize: Push
        
        @inlinable func push(_ update: Update) {
            if update.contains(.downstream) {
                lock.perform {
                    // write and select both call textFieldDidChangeSelection(_:)
                    self.uiView.write(cache.snapshot.characters)
                    self.uiView.select(cache.field.selection.map(bounds: \.offset))
                }
                            
                self.cache.edits = self.uiView.edits
            }
                                    
            if update.contains(.upstream) {
                perform(async: update.contains(.async)) {
                    // async avoids view update loop
                    self.nonduplicate(update: &self.source.value.wrappedValue, with: self.cache.value)
                }
            }
        }
        
        // MARK: Synchronize: Helpers

        @inlinable func upstream(has value: Value) -> Bool {
            source.value.wrappedValue == value
        }
        
        @inlinable func downstream(has value: Value) -> Bool {
            cache.value == value && cache.edits == uiView.edits
        }

        @inlinable func snapshot(_ value: Value) -> Snapshot {
            uiView.edits ? source.style.snapshot(value) : source.style.showcase(value)
        }

        @inlinable func nonduplicate(update storage: inout Value, with newValue: Value) {
            if storage != newValue { storage = newValue }
        }
        
        @inlinable func perform(async: Bool, action: @escaping () -> Void) {
            if async { DispatchQueue.main.async(execute: action) } else { action() }
        }
    }
}

#endif
