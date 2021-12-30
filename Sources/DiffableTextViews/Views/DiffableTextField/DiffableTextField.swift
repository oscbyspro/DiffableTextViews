//
//  DiffableTextField.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#if canImport(UIKit)

import SwiftUI
import protocol Utilities.Transformable

// MARK: - DiffableTextField

public struct DiffableTextField<Style: DiffableTextStyle>: UIViewRepresentable, Transformable {
    public typealias Value = Style.Value
    public typealias UIViewType = BasicTextField
    public typealias Configuration = (ProxyTextField) -> Void
    
    // MARK: Properties
    
    @usableFromInline let value: Binding<Value>
    @usableFromInline let style: Style

    @usableFromInline var setup:  Configuration? = nil
    @usableFromInline var update: Configuration? = nil
    @usableFromInline var submit: Configuration? = nil

    // MARK: Initializers
    
    @inlinable public init(_ value: Binding<Value>, style: Style) {
        self.value = value
        self.style = style
    }
    
    @inlinable public init(_ value: Binding<Value>, style: () -> Style) {
        self.value = value
        self.style = style()
    }

    // MARK: Transformations
    
    @inlinable public func setup(_ setup: Configuration?) -> Self {
        transforming({ $0.setup = setup })
    }
    
    @inlinable public func update(_ update: Configuration?) -> Self {
        transforming({ $0.update = update })
    }
    
    @inlinable public func submit(_ submit: Configuration?) -> Self {
        transforming({ $0.submit = submit })
    }

    // MARK: UIViewRepresentable
    
    @inlinable public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    @inlinable public func makeUIView(context: Context) -> UIViewType {
        let uiView = BasicTextField()
        context.coordinator.downstream = ProxyTextField(uiView)
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        uiView.delegate = context.coordinator
        setup?(context.coordinator.downstream)
        return uiView
    }
    
    @inlinable public func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.upstream = self
        update?(context.coordinator.downstream)
        context.coordinator.synchronize()
    }
    
    // MARK: Coordinator
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Offset = DiffableTextViews.Offset<UTF16>
        @usableFromInline typealias Cache = DiffableTextViews.Cache<UTF16, Value>
        
        // MARK: Properties
        
        @usableFromInline var upstream: DiffableTextField!
        @usableFromInline var downstream:  ProxyTextField!
        
        @usableFromInline let lock  =  Lock()
        @usableFromInline let cache = Cache()
        
        // MARK: Submit
        
        @inlinable public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            upstream.submit?(downstream) == nil ? true : false
        }
        
        // MARK: Mode
        
        @inlinable public func textFieldDidBeginEditing(_ textField: UITextField) {
            synchronize()
        }
        
        @inlinable public func textFieldDidEndEditing(_ textField: UITextField) {
            synchronize()
        }
        
        @inlinable public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            synchronize()
        }
        
        // MARK: Input
        
        @inlinable public func textField(_ textField: UITextField, shouldChangeCharactersIn nsRange: NSRange, replacementString string: String) -> Bool {
            do {
                
                // --------------------------------- //
                // MARK: Interpret
                // --------------------------------- //
                
                let input = Snapshot(string, only: .content)
                let offsets = Offset(at: nsRange.lowerBound) ..< Offset(at: nsRange.upperBound)
                let range = cache.field.indices(at: offsets)
                let indices = range.lowerBound.rhs! ..< range.upperBound.rhs!
                
                // --------------------------------- //
                // MARK: Calculate Next State
                // --------------------------------- //
                
                var snapshot = try upstream.style.merge(snapshot: cache.snapshot, with: input, in: indices)
                upstream.style.process(snapshot: &snapshot)
                
                var value = try upstream.style.parse(snapshot: snapshot)
                upstream.style.process(value: &value)
                
                let field = cache.field.updating(selection: range.upperBound, intent: nil).updating(carets: snapshot)
                
                // --------------------------------- //
                // MARK: Push
                // --------------------------------- //
                
                Task { @MainActor [value] in
                    // async to process special commands first
                    // see option + delete as one such example
                    self.cache.value = value
                    self.cache.field = field
                    self.push()
                }
                
            } catch let reason {
                
                // --------------------------------- //
                // MARK: Cancellation
                // --------------------------------- //
                
                #if DEBUG
                
                print("User input cancelled: \(reason)")
                
                #endif
            }
            
            // --------------------------------- //
            // MARK: Decline Automatic Insertion
            // --------------------------------- //
            
            return false
        }
        
        // MARK: Selection
        
        @inlinable public func textFieldDidChangeSelection(_ textField: UITextField) {
            guard !lock.isLocked else { return }
            
            // --------------------------------- //
            // MARK: Calculate Corrected Outcome
            // --------------------------------- //
            
            let selection = downstream.selection()
            let corrected = cache.field.updating(selection: selection, intent: downstream.intent)
            
            // --------------------------------- //
            // MARK: Update Downstream If Needed
            // --------------------------------- //
            
            if selection != corrected.selection.offsets {
                lock.perform {
                    self.cache.field = corrected
                    self.downstream.update(selection: corrected.selection.offsets)
                }
            }
        }

        // MARK: Synchronize
        
        @inlinable func synchronize() {
            
            // --------------------------------- //
            // MARK: Pull
            // --------------------------------- //
            
            var value = upstream.value.wrappedValue
            upstream.style.process(value: &value)
            
            // --------------------------------- //
            // MARK: Compare
            // --------------------------------- //
            
            if cache.value != value || cache.edits != downstream.edits {
                
                // --------------------------------- //
                // MARK: Calculate Next State
                // --------------------------------- //
                
                var snapshot = downstream.edits
                ? upstream.style.snapshot(editable: value)
                : upstream.style.snapshot(showcase: value)
                upstream.style.process(snapshot: &snapshot)
                let field = cache.field.updating(carets: snapshot)
                
                // --------------------------------- //
                // MARK: Push
                // --------------------------------- //
                
                self.cache.value = value
                self.cache.field = field
                self.push()
            }
        }
        
        // MARK: Synchronize: Push
        
        @inlinable func push() {
            
            // --------------------------------- //
            // MARK: Downstream
            // --------------------------------- //
            
            lock.perform {
                // changes to UITextField's text and selection both call
                // the delegate's method: textFieldDidChangeSelection(_:)
                self.downstream.update(text: cache.snapshot.characters)
                self.downstream.update(selection: cache.selection.offsets)
                self.cache.edits = downstream.edits
            }
                        
            // --------------------------------- //
            // MARK: Upstream
            // --------------------------------- //
            
            if  self.upstream.value.wrappedValue != self.cache.value {
                self.upstream.value.wrappedValue  = self.cache.value
            }
        }
    }
}

#endif
