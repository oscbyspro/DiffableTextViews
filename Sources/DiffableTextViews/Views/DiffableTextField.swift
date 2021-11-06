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
    public typealias Configuration = (Proxy) -> Void
    
    // MARK: Properties
    
    @usableFromInline let value: Binding<Value>
    @usableFromInline let style: Style

    @usableFromInline var setup:  Configuration? = nil
    @usableFromInline var update: Configuration? = nil
    @usableFromInline var submit: Configuration? = nil

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
    
    @inlinable public func setup(_ setup: Configuration?) -> Self {
        configure({ $0.setup = setup })
    }
    
    @inlinable public func update(_ update: Configuration?) -> Self {
        configure({ $0.update = update })
    }
    
    @inlinable public func submit(_ submit: Configuration?) -> Self {
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
        
        setup?(context.coordinator.downstream)
        
        // --------------------------------- //

        return uiView
    }
    
    @inlinable public func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.upstream = self
        update?(context.coordinator.downstream)
        context.coordinator.synchronize(.async)
    }
    
    // MARK: Coordinator
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Scheme = UTF16
        @usableFromInline typealias Offset = DiffableTextViews.Offset<Scheme>
        @usableFromInline typealias Field  = DiffableTextViews.Field<Scheme>
        @usableFromInline typealias Cache  = DiffableTextViews.Cache<Scheme, Value>
        
        // MARK: Properties
        
        @usableFromInline var upstream: DiffableTextField!
        @usableFromInline var downstream: ProxyTextField<UIViewType>!

        @usableFromInline let lock  = Lock()
        @usableFromInline let cache = Cache()
                
        // MARK: Setup

        @inlinable func connect(_ uiView: UIViewType) {
            uiView.delegate = self            
            self.downstream = ProxyTextField(uiView)
        }
        
        // MARK: Delegate: Submit
        
        @inlinable public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            upstream.submit?(downstream) == nil ? true : false
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

            guard var snapshot = upstream.style.merge(cache.snapshot, with: input, in: range.map(bounds: \.rhs!)) else { return false }
            upstream.style.process(&snapshot)
  
            guard var value = upstream.style.parse(snapshot) else { return false }
            upstream.style.process(&value)
                        
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
                        
            let offsets = downstream.selection()
            let intent = downstream.wrapped.intent?.direction
            let field = cache.field.configure(selection: offsets, intent: intent)
            let selection = field.selection.map(bounds: \.offset)
            
            // --------------------------------- //
            
            self.cache.field = field
            
            // --------------------------------- //
            
            guard selection != offsets else { return }
            
            // --------------------------------- //
            
            lock.perform {
                self.downstream.select(selection)
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
            
            var value = upstream.value.wrappedValue
            upstream.style.process(&value)
            
            // --------------------------------- //
        
            if !upstream(represents: value) {
                update.insert(.upstream)
            }
         
            // --------------------------------- //
            
            if !downstream(displays: value) {
                update.insert(.downstream)

                // --------------------------------- //
                
                var snapshot = snapshot(value)
                upstream.style.process(&snapshot)
                
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
                    self.downstream.update(cache.snapshot.characters)
                    self.downstream.select(cache.field.selection.map(bounds: \.offset))
                }
                            
                self.cache.edits = self.downstream.edits
            }
                                    
            if update.contains(.upstream) {
                perform(async: update.contains(.async)) {
                    // async avoids view update loop
                    self.nonduplicate(update: &self.upstream.value.wrappedValue, with: self.cache.value)
                }
            }
        }
        
        // MARK: Synchronize: Helpers

        @inlinable func upstream(represents value: Value) -> Bool {
            upstream.value.wrappedValue == value
        }
        
        @inlinable func downstream(displays value: Value) -> Bool {
            cache.value == value && cache.edits == downstream.edits
        }

        @inlinable func snapshot(_ value: Value) -> Snapshot {
            downstream.edits ? upstream.style.snapshot(value) : upstream.style.showcase(value)
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
