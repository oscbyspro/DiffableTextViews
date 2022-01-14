//
//  DiffableTextField.swift
//
//
//  Created by Oscar Byström Ericsson on 2021-09-24.
//

#if canImport(UIKit)

import Quick
import SwiftUI

//*============================================================================*
// MARK: * DiffableTextField
//*============================================================================*

public struct DiffableTextField<Style: DiffableTextStyle>: UIViewRepresentable, Transformable {
    public typealias Value = Style.Value
    public typealias UIViewType = BasicTextField
    public typealias Transformation = (ProxyTextField) -> Void
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let value: Binding<Value>
    @usableFromInline let style: Style
    
    //
    // MARK: Properties - Transformations
    //=------------------------------------------------------------------------=

    @usableFromInline var setup  = ProxyTextField.Transformations()
    @usableFromInline var update = ProxyTextField.Transformations()
    @usableFromInline var submit = ProxyTextField.Transformations()

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ value: Binding<Value>, style: Style) {
        self.value = value
        self.style = style
    }
    
    @inlinable public init(_ value: Binding<Value>, style: () -> Style) {
        self.init(value, style: style())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func setup(_ transformation: @escaping Transformation) -> Self {
        transform({ $0.setup.add(transformation) })
    }
    
    @inlinable public func update(_ transformation: @escaping Transformation) -> Self {
        transform({ $0.update.add(transformation) })
    }
    
    @inlinable public func submit(_ transformation: @escaping Transformation) -> Self {
        transform({ $0.submit.add(transformation) })
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
        style.setup(downstream)
        setup.apply(on: downstream)
        context.coordinator.downstream = downstream

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
        update.apply(on: context.coordinator.downstream)
        context.coordinator.synchronize()
    }
    
    //*========================================================================*
    // MARK: * Coordinator
    //*========================================================================*
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Offset = DiffableTextViews.Offset<UTF16>
        @usableFromInline typealias Cache = DiffableTextViews.Cache<Value, UTF16>
        
        //=--------------------------------------------------------------------=
        // MARK: Properties
        //=--------------------------------------------------------------------=
        
        @usableFromInline var upstream: DiffableTextField!
        @usableFromInline var downstream:  ProxyTextField!
        
        //=--------------------------------------------------------------------=
        // MARK: Properties - Support
        //=--------------------------------------------------------------------=
        
        @usableFromInline let lock =  Lock()
        @usableFromInline let cache = Cache()

        //=----------------------------------------------------------------------------=
        // MARK: Delegate - Respond To Submit Events
        //=----------------------------------------------------------------------------=
        
        @inlinable public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            !upstream.submit.apply(on: downstream)
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
            //=----------------------------------=
            // MARK: Process User Input
            //=----------------------------------=
            do {
                //=------------------------------=
                // MARK: Arguments
                //=------------------------------=
                #warning("Move most of this to Input init method.")
                let content = Snapshot(string, only: .content)
                let offsets = Offset(at: nsRange.lowerBound) ..< Offset(at: nsRange.upperBound)
                let selection = cache.state.indices(at: offsets)
                let input = Input(content: content, range: selection.lowerBound.snapshot ..< selection.upperBound.snapshot)
                //=------------------------------=
                // MARK: State
                //=------------------------------=
                let snapshot = try upstream.style
                    .merge(snapshot: cache.snapshot, with: input)
                    .transform(upstream.style.process)
                
                let value = try snapshot
                    .transformableValue(upstream.style.parse)
                    .transform(upstream.style.process)
                
                let state = cache.state.transform {
                    state in
                    state.selection = selection.upperBound ..< selection.upperBound
                    state.update(snapshot: snapshot)
                }
                //=------------------------------=
                // MARK: Push
                //=------------------------------=
                Task { @MainActor in
                    // async to process special commands first
                    self.cache.value = value
                    self.cache.state = state
                    self.push()
                }
            //=----------------------------------=
            // MARK: Respond To Cancellation
            //=----------------------------------=
            } catch let reason {
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
            let corrected = cache.state.transform {
                corrected in
                corrected.update(selection: selection, intent: downstream.intent)
            }
            //=----------------------------------=
            // MARK: Update Downstream If Needed
            //=----------------------------------=
            if selection != corrected.offsets {
                lock.perform {
                    self.cache.state = corrected
                    self.downstream.update(selection: corrected.offsets)
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
            let value = TransformableValue
                .init(upstream.value.wrappedValue)
                .transform(upstream.style.process)
            //=----------------------------------=
            // MARK: Accept Or Discard
            //=----------------------------------=
            if cache.value != value || cache.mode != downstream.mode {
                //=------------------------------=
                // MARK: State
                //=------------------------------=
                let snapshot = upstream.style
                    .snapshot(downstream.mode, value)
                    .transform(upstream.style.process)
                
                let state = cache.state.transform {
                    state in
                    state.update(snapshot: snapshot)
                }
                
                //=------------------------------=
                // MARK: Push
                //=------------------------------=
                self.cache.value = value
                self.cache.state = state
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
                self.downstream.update(selection:  cache.state.offsets)
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
