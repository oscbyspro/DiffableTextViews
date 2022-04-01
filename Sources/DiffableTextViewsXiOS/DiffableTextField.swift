//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import DiffableTextKit
import SwiftUI

//*============================================================================*
// MARK: * DiffableTextField
//*============================================================================*

public struct DiffableTextField<Style: DiffableTextStyle>: UIViewRepresentable {
    public typealias Value = Style.Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let style: Style
    @usableFromInline let value: Binding<Value>

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
    // MARK: View Life Cycle - Coordinator
    //=------------------------------------------------------------------------=
    
    @inlinable public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: View Life Cycle - UIView
    //=------------------------------------------------------------------------=
    
    @inlinable public func makeUIView(context: Self.Context) -> BasicTextField {
        let downstream = Downstream()
        let wrapped = downstream.wrapped
        //=--------------------------------------=
        // MARK: View
        //=--------------------------------------=
        wrapped.font = UIFont(DiffableTextFont.body.monospaced())
        wrapped.setTextAlignment(context.environment.multilineTextAlignment)
        wrapped.setContentHuggingPriority(.defaultHigh, for: .vertical)
        wrapped.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        //=--------------------------------------=
        // MARK: Downstream
        //=--------------------------------------=
        downstream.transform(Style.onSetup)
        downstream.transform(context.environment.diffableTextField_onSetup)
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        wrapped.delegate = context.coordinator
        context.coordinator.downstream = downstream
        return wrapped
    }
    
    //=------------------------------------------------------------------------=
    // MARK: View Life Cycle - Update
    //=------------------------------------------------------------------------=
    
    @inlinable public func updateUIView(_ uiView: UIViewType, context: Self.Context) {
        context.coordinator.update(self, context.environment)
    }
    
    //*========================================================================*
    // MARK: * Coordinator
    //*========================================================================*
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Upstream = DiffableTextField
        @usableFromInline typealias Context = DiffableTextKit.Context<Style, UTF16>

        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let lock = Lock()
        @usableFromInline var context = Context()
        
        @usableFromInline var upstream: Upstream!
        @usableFromInline var downstream: Downstream!
        @usableFromInline var environment: EnvironmentValues!

        //=--------------------------------------------------------------------=
        // MARK: Upstream
        //=--------------------------------------------------------------------=
                
        @inlinable func update(_ upstream: Upstream, _ environment: EnvironmentValues) {
            self.upstream = upstream; self.environment = environment
            self.synchronize() // on update is same as on did update
            self.downstream.transform(environment.diffableTextField_onUpdate)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Synchronize
        //=--------------------------------------------------------------------=
        
        @inlinable func synchronize() {
            //=----------------------------------=
            // MARK: Pull
            //=----------------------------------=
            guard  context.pull(
            style: upstream.style.locale(environment.locale),
            value: upstream.value.wrappedValue,
            focus: downstream.focus) else { return }
            //=----------------------------------=
            // MARK: Push
            //=----------------------------------=
            context.focus.value ? self.push() : self.write()
        }

        @inlinable func push() {
            //=----------------------------------=
            // MARK: Downstream
            //=----------------------------------=
            lock.perform {
                self.downstream.update(text: context.field.characters)
                self.downstream.update(selection: context.field.positions)
            }
            //=----------------------------------=
            // MARK: Upstream
            //=----------------------------------=
            if  self.upstream.value.wrappedValue != context.value {
                self.upstream.value.wrappedValue  = context.value
            }
        }

        @inlinable func write() {
            //=----------------------------------=
            // MARK: Downstream
            //=----------------------------------=
            lock.perform {
                self.downstream.update(text: context.formatted())
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Respond To Submit Events
        //=--------------------------------------------------------------------=
        
        @inlinable public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            downstream.transform(environment.diffableTextField_onSubmit); return  true
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
        
        @inlinable public func textField(_ textField: UITextField,
        shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let style = context.style!
            let range = context.field.indices(at: range)
            let changes = Changes(context.field.snapshot, change: (range, string))
            //=----------------------------------=
            // MARK: Merge
            //=----------------------------------=
            merge: do {
                let commit = try style.merge(changes)
                //=------------------------------=
                // MARK: Push
                //=------------------------------=
                Task { @MainActor in
                    // async to process special commands first
                    // as an example see: (option + backspace)
                    self.context.set(selection: range.upperBound)
                    self.context.focused(style: style, commit: commit)
                    self.push()
                }
            //=----------------------------------=
            // MARK: Cancellation
            //=----------------------------------=
            } catch let reason {
                Info.print([.cancellation, .note(reason)])
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
            let selection = downstream.selection
            //=----------------------------------=
            // MARK: Update
            //=----------------------------------=
            self.context.update(selection: selection, momentum: downstream.momentum)
            //=----------------------------------=
            // MARK: Update Downstream If Needed
            //=----------------------------------=
            if selection != context.field.positions {
                lock.perform {
                    self.downstream.update(selection: context.field.positions)
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * DiffableTextField x ID
//*============================================================================*

public struct DiffableTextFieldID { public static let diffableTextField = Self() }

//*============================================================================*
// MARK: * DiffableTextField x Environment
//*============================================================================*

@usableFromInline enum DiffableTextField_OnSetup:  EnvironmentKey {
    @usableFromInline static let defaultValue: (ProxyTextField) -> Void = { _ in }
}

@usableFromInline enum DiffableTextField_OnUpdate: EnvironmentKey {
    @usableFromInline static let defaultValue: (ProxyTextField) -> Void = { _ in }
}

@usableFromInline enum DiffableTextField_OnSubmit: EnvironmentKey {
    @usableFromInline static let defaultValue: (ProxyTextField) -> Void = { _ in }
}

//*============================================================================*
// MARK: * DiffableTextField x Environment x Values
//*============================================================================*

extension EnvironmentValues {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var diffableTextField_onSetup:  (ProxyTextField) -> Void {
        get { self[DiffableTextField_OnSetup .self] }
        set { self[DiffableTextField_OnSetup .self] = newValue }
    }
    
    @inlinable var diffableTextField_onUpdate: (ProxyTextField) -> Void {
        get { self[DiffableTextField_OnUpdate.self] }
        set { self[DiffableTextField_OnUpdate.self] = newValue }
    }

    @inlinable var diffableTextField_onSubmit: (ProxyTextField) -> Void {
        get { self[DiffableTextField_OnSubmit.self] }
        set { self[DiffableTextField_OnSubmit.self] = newValue }
    }
}

//*============================================================================*
// MARK: * DiffableTextField x Environment x View
//*============================================================================*

public extension View {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func onSetup(of  view: DiffableTextFieldID,
    _ action: @escaping (ProxyTextField) -> Void) -> some View {
        environment(\.diffableTextField_onSetup,  action)
    }
    
    @inlinable func onUpdate(of view: DiffableTextFieldID,
    _ action: @escaping (ProxyTextField) -> Void) -> some View {
        environment(\.diffableTextField_onUpdate, action)
    }
    
    @inlinable func onSubmit(of view: DiffableTextFieldID,
    _ action: @escaping (ProxyTextField) -> Void) -> some View {
        environment(\.diffableTextField_onSubmit, action)
    }
}

#endif
