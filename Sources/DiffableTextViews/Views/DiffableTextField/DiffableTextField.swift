//
//  DiffableTextField.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#if canImport(UIKit)

import SwiftUI

//*============================================================================*
// MARK: * DiffableTextField
//*============================================================================*

public struct DiffableTextField<Style: DiffableTextStyle>: UIViewRepresentable {
    public typealias Value = Style.Value
    public typealias UIViewType = BasicTextField
    public typealias Configuration = (ProxyTextField) -> Void
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let value: Binding<Value>
    @usableFromInline let style: Style
    
    //
    // MARK: Properties - Configurations
    //=------------------------------------------------------------------------=

    @usableFromInline var setup:  Configuration? = nil
    @usableFromInline var update: Configuration? = nil
    @usableFromInline var submit: Configuration? = nil

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ value: Binding<Value>, style: Style) {
        self.value = value
        self.style = style
    }
    
    @inlinable public init(_ value: Binding<Value>, style: () -> Style) {
        self.value = value
        self.style = style()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func setup(_ setup: Configuration?) -> Self {
        var result = self; result.setup = setup; return result
    }
    
    @inlinable public func update(_ update: Configuration?) -> Self {
        var result = self; result.update = update; return result
    }
    
    @inlinable public func submit(_ submit: Configuration?) -> Self {
        var result = self; result.submit = submit; return result
    }

    //=------------------------------------------------------------------------=
    // MARK: Life - Coordinator
    //=------------------------------------------------------------------------=
    
    @inlinable public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    //
    // MARK: Life - UIView
    //=------------------------------------------------------------------------=
    
    @inlinable public func makeUIView(context: Context) -> UIViewType {
        
        //=--------------------------------------=
        // MARK: BasicTextField
        //=--------------------------------------=
        
        let uiView = BasicTextField()
        uiView.delegate = context.coordinator
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        //=--------------------------------------=
        // MARK: ProxyTextField
        //=--------------------------------------=
        
        let downstream = ProxyTextField(uiView)
        context.coordinator.downstream = downstream
        setup?(downstream)

        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        
        return uiView
    }
    
    //
    // MARK: Life - UIView - Update
    //=------------------------------------------------------------------------=
    
    @inlinable public func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.upstream = self
        update?(context.coordinator.downstream)
        context.coordinator.synchronize()
    }
    
    //*========================================================================*
    // MARK: * Coordinator
    //*========================================================================*
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Offset = DiffableTextViews.Offset<UTF16>
        @usableFromInline typealias Cache = DiffableTextViews.Cache<UTF16, Value>
        
        //=--------------------------------------------------------------------=
        // MARK: Properties
        //=--------------------------------------------------------------------=
        
        @usableFromInline var upstream: DiffableTextField!
        @usableFromInline var downstream:  ProxyTextField!
        
        //
        // MARK: Properties - Support
        //=--------------------------------------------------------------------=
        
        @usableFromInline let lock =  Lock()
        @usableFromInline let cache = Cache()
        
        //=----------------------------------------------------------------------------=
        // MARK: Delegate - Respond To Submit Events
        //=----------------------------------------------------------------------------=
        
        @inlinable public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            upstream.submit?(downstream) == nil ? true : false
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Delegate - Respond To Mode Change Events
        //=--------------------------------------------------------------------=
        
        @inlinable public func textFieldDidBeginEditing(_ textField: UITextField) {
            synchronize()
        }
        
        @inlinable public func textFieldDidEndEditing(_ textField: UITextField) {
            synchronize()
        }
        
        @inlinable public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            synchronize()
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Delegate - Respond To Input Events
        //=--------------------------------------------------------------------=
        
        @inlinable public func textField(_ textField: UITextField, shouldChangeCharactersIn nsRange: NSRange, replacementString string: String) -> Bool {
            do {
                
                //=------------------------------=
                // MARK: Process Arguments
                //=------------------------------=

                let input = Snapshot(string, only: .content)
                let offsets = Offset(at: nsRange.lowerBound) ..< Offset(at: nsRange.upperBound)
                let range = cache.field.indices(at: offsets)
                let indices = range.lowerBound.rhs! ..< range.upperBound.rhs!
                
                //=------------------------------=
                // MARK: Calculate Next State
                //=------------------------------=
                
                var snapshot = try upstream.style.merge(snapshot: cache.snapshot, with: input, in: indices)
                upstream.style.process(snapshot: &snapshot)
                
                var value = try upstream.style.parse(snapshot: snapshot)
                upstream.style.process(value: &value)
                
                let field = cache.field.updating(selection: range.upperBound, intent: nil).updating(carets: snapshot)
                
                //=------------------------------=
                // MARK: Push
                //=------------------------------=
                
                Task { @MainActor [value] in
                    // async to process special commands first
                    // see option + delete as one such example
                    // where textFieldDidChangeSelection(_:)
                    // is called after this method completes
                    self.cache.value = value
                    self.cache.field = field
                    self.push()
                }
                
            } catch let reason {
                
                //=------------------------------=
                // MARK: Respond To Cancellation
                //=------------------------------=
                
                #if DEBUG
                
                print("User input cancelled: \(reason)")
                
                #endif
            }
            
            //=----------------------------------=
            // MARK: Decline Automatic Insertion
            //=----------------------------------=
            
            return false
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Respond To Selection Change Events
        //=--------------------------------------------------------------------=
        
        @inlinable public func textFieldDidChangeSelection(_ textField: UITextField) {
            guard !lock.isLocked else { return }
            
            //=----------------------------------=
            // MARK: Correct Selection
            //=----------------------------------=
            
            let selection = downstream.selection()
            let corrected = cache.field.updating(selection: selection, intent: downstream.intent)
            
            //=----------------------------------=
            // MARK: Update Downstream If Needed
            //=----------------------------------=
            
            if selection != corrected.selection.offsets {
                lock.perform {
                    self.cache.field = corrected
                    self.downstream.update(selection: corrected.selection.offsets)
                }
            }
        }

        //=--------------------------------------------------------------------=
        // MARK: Synchronize
        //=--------------------------------------------------------------------=
        
        @inlinable func synchronize() {
            
            //=----------------------------------=
            // MARK: Pull
            //=----------------------------------=
            
            var value = upstream.value.wrappedValue
            upstream.style.process(value: &value)
            
            //=----------------------------------=
            // MARK: Evaluate New Values
            //=----------------------------------=
            
            if cache.value != value || cache.mode != downstream.mode {
                
                //=------------------------------=
                // MARK: Calculate Next State
                //=------------------------------=
                
                var snapshot = upstream.style.snapshot(value: value, mode: downstream.mode)
                upstream.style.process(snapshot: &snapshot)
                let field = cache.field.updating(carets: snapshot)
                
                //=------------------------------=
                // MARK: Push
                //=------------------------------=
                
                self.cache.value = value
                self.cache.field = field
                self.push()
            }
        }
        
        //
        // MARK: Synchronize: Push
        //=--------------------------------------------------------------------=
        
        @inlinable func push() {
            
            //=----------------------------------=
            // MARK: Downstream
            //=----------------------------------=
            
            lock.perform {
                // changes to UITextField's text and selection both call
                // the delegate's method: textFieldDidChangeSelection(_:)
                self.downstream.update(text: cache.snapshot.characters)
                self.downstream.update(selection: cache.selection.offsets)
                self.cache.mode = downstream.mode
            }
                        
            //=----------------------------------=
            // MARK: Upstream
            //=----------------------------------=
            
            if  self.upstream.value.wrappedValue != self.cache.value {
                self.upstream.value.wrappedValue  = self.cache.value
            }
        }
    }
}

#endif
