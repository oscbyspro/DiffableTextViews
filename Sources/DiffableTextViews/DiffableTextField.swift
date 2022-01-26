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

public struct DiffableTextField<Style: UIKitDiffableTextStyle>: UIViewRepresentable {
    public typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: Environment
    //=------------------------------------------------------------------------=
    
    @usableFromInline @Environment(\.locale) var locale: Locale
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    @usableFromInline let value: Binding<Value>
    @usableFromInline let style: () -> Style
    
    //=------------------------------------------------------------------------=
    // MARK: Customization
    //=------------------------------------------------------------------------=

    @usableFromInline var setup:  ((ProxyTextField) -> Void)? = nil
    @usableFromInline var update: ((ProxyTextField) -> Void)? = nil
    @usableFromInline var submit: ((ProxyTextField) -> Void)? = nil

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ value: Binding<Value>, style: @escaping () -> Style) {
        self.value = value
        self.style = style
    }
    
    @inlinable public init(_ value: Binding<Value>, style: @escaping @autoclosure () -> Style) {
        self.value = value
        self.style = style
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func setup(_  transform: @escaping (ProxyTextField) -> Void) -> Self {
        var result = self; result.setup  = transform; return result
    }
    
    @inlinable public func update(_ transform: @escaping (ProxyTextField) -> Void) -> Self {
        var result = self; result.update = transform; return result
    }
    
    @inlinable public func submit(_ transform: @escaping (ProxyTextField) -> Void) -> Self {
        var result = self; result.submit = transform; return result
    }

    //=------------------------------------------------------------------------=
    // MARK: View Life Cycle - Coordinator
    //=------------------------------------------------------------------------=
    
    @inlinable public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: View Life Cycle - UIView
    //=------------------------------------------------------------------------=
    
    @inlinable public func makeUIView(context: Context) -> BasicTextField {
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
        Style.setup(diffableTextField: downstream)
        context.coordinator.downstream = downstream
        setup?(context.coordinator.downstream)
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        return uiView
    }
    
    //=------------------------------------------------------------------------=
    // MARK: View Life Cycle - Update
    //=------------------------------------------------------------------------=
    
    @inlinable public func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.upstream = self
        update?(context.coordinator.downstream)
        context.coordinator.synchronize()
    }
    
    //*========================================================================*
    // MARK: * Coordinator
    //*========================================================================*
    
    #warning("It should be considered that the style can change.")
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Position = DiffableTextViews.Position<UTF16>
        @usableFromInline typealias Cache = DiffableTextViews.Cache<UTF16, Value>
        
        //=--------------------------------------------------------------------=
        // MARK: Properties
        //=--------------------------------------------------------------------=
        
        @usableFromInline var upstream: DiffableTextField!
        @usableFromInline var downstream:  ProxyTextField!
        
        //=--------------------------------------------------------------------=
        // MARK: Properties - Support
        //=--------------------------------------------------------------------=
        
        @usableFromInline let lock  = Lock()
        @usableFromInline let cache = Cache()
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable func style() -> Style {
            upstream.style().locale(upstream.locale)
        }

        //=--------------------------------------------------------------------=
        // MARK: Respond To Submit Events
        //=--------------------------------------------------------------------=
        
        @inlinable public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            upstream.submit?(downstream) == nil
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Respond To Mode Change Events
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
        // MARK: Respond To Input Events
        //=--------------------------------------------------------------------=
        
        @inlinable public func textField(_ textField: UITextField, shouldChangeCharactersIn nsRange: NSRange, replacementString string: String) -> Bool {
            let style = style()
            //=----------------------------------=
            // MARK: Attempt
            //=----------------------------------=
            do {
                //=------------------------------=
                // MARK: Range, Input, Output
                //=------------------------------=
                let range = cache.state.indices(at: nsRange)
                let input = Input(content: string, range: range)
                let output = try style.downstream(snapshot: cache.snapshot, input: input)
                //=------------------------------=
                // MARK: State
                //=------------------------------=
                var state = cache.state
                state.selection = range.upperBound ..< range.upperBound
                state.update(snapshot: output.snapshot)
                //=------------------------------=
                // MARK: Push
                //=------------------------------=
                Task { @MainActor [state] in
                    // async to process special commands first
                    // as an example see: (option + backspace)
                    self.cache.state = state
                    self.cache.value = output.value
                    self.push()
                }
            //=----------------------------------=
            // MARK: Cancellation
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
            // MARK: Positions
            //=----------------------------------=
            let positions = downstream.selection()
            //=----------------------------------=
            // MARK: Corrected
            //=----------------------------------=
            var corrected = cache.state
            corrected.update(selection: positions, momentum: downstream.momentum)
            //=----------------------------------=
            // MARK: Update Downstream If Needed
            //=----------------------------------=
            if positions != corrected.positions {
                lock.perform {
                    self.cache.state = corrected
                    self.downstream.update(selection: corrected.positions)
                }
            }
        }

        //=--------------------------------------------------------------------=
        // MARK: Synchronize
        //=--------------------------------------------------------------------=
        
        #warning("FIXME.")
        #warning("Should styles be equatable?")
        @inlinable func synchronize() {
            //=----------------------------------=
            // MARK: Pull
            //=----------------------------------=
            let remote = upstream.value.wrappedValue
            //=----------------------------------=
            // MARK: Accept Or Discard
            //=----------------------------------=
            if cache.value != remote || cache.mode != downstream.mode {
                //=------------------------------=
                // MARK: Style
                //=------------------------------=
                let style = style()
                //=------------------------------=
                // MARK: Output
                //=------------------------------=
                let output = style.upstream(value: remote, mode: downstream.mode)
                //=------------------------------=
                // MARK: State
                //=------------------------------=
                var state = cache.state
                state.update(snapshot: output.snapshot)
                //=------------------------------=
                // MARK: Push
                //=------------------------------=
                self.cache.state = state
                self.cache.value = output.value
                self.push()
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Synchronize - Push
        //=--------------------------------------------------------------------=
        
        @inlinable func push() {
            //=----------------------------------=
            // MARK: Downstream
            //=----------------------------------=
            lock.perform {
                // changes to UITextField's text and selection both call
                // the delegate's method: textFieldDidChangeSelection(_:)
                self.downstream.update(text: cache.snapshot.characters)
                self.downstream.update(selection: cache.state.positions)
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
