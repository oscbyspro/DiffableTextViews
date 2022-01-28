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

#warning("Handle style creation.")
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
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Position = DiffableTextViews.Position<UTF16>
        @usableFromInline typealias State = DiffableTextViews.State<UTF16, Value>
        
        //=--------------------------------------------------------------------=
        // MARK: Properties
        //=--------------------------------------------------------------------=
        
        @usableFromInline var upstream: DiffableTextField!
        @usableFromInline var downstream:  ProxyTextField!
        
        //=--------------------------------------------------------------------=
        // MARK: Properties - Support
        //=--------------------------------------------------------------------=
        
        @usableFromInline let lock  = Lock()
        @usableFromInline let state = State()
        
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
            let range = state.indices(at: nsRange)
            let selection = range.upperBound ..< range.upperBound
            let request = Request(state.snapshot, change: (string, range))
            //=----------------------------------=
            // MARK: Attempt
            //=----------------------------------=
            do {
                let commit = try style.merge(request: request)
                //=------------------------------=
                // MARK: Push
                //=------------------------------=
                Task { @MainActor in
                    // async to process special commands first
                    // as an example see: (option + backspace)
                    self.state.selection = selection
                    self.state.update(commit: commit)
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
            self.state.update(selection: positions, momentum: downstream.momentum)
            //=----------------------------------=
            // MARK: Update Downstream If Needed
            //=----------------------------------=
            if state.positions != positions {
                lock.perform {
                    self.downstream.update(selection: state.positions)
                }
            }
        }

        //=--------------------------------------------------------------------=
        // MARK: Synchronize
        //=--------------------------------------------------------------------=
        
        @inlinable func synchronize() {
            let style = style()
            let value = upstream.value.wrappedValue
            //=------------------------------=
            // MARK: Editable
            //=------------------------------=
            if downstream.active {
                self.state.update(commit: style.editable(value: value))
                self.push()
            //=------------------------------=
            // MARK: Showcase
            //=------------------------------=
            } else {
                lock.perform {
                    self.downstream.update(text: style.showcase(value: value))
                }
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Push - Editable
        //=--------------------------------------------------------------------=
        
        @inlinable func push() {
            //=----------------------------------=
            // MARK: Downstream
            //=----------------------------------=
            lock.perform {
                // changes to UITextField's text and selection both call
                // the delegate's method: textFieldDidChangeSelection(_:)
                self.downstream.update(text: state.characters)
                self.downstream.update(selection: state.positions)
            }
            //=----------------------------------=
            // MARK: Upstream
            //=----------------------------------=
            if  self.upstream.value.wrappedValue != state.value {
                self.upstream.value.wrappedValue  = state.value
            }
        }
    }
}

#endif