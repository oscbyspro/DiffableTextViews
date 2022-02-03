//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if canImport(UIKit)

import SwiftUI

//*============================================================================*
// MARK: * DiffableTextField
//*============================================================================*

public struct DiffableTextField<Style: UIKitDiffableTextStyle>: UIViewRepresentable {
    public typealias Value = Style.Value
    public typealias Proxy = ProxyTextField
    
    //=------------------------------------------------------------------------=
    // MARK: Environment
    //=------------------------------------------------------------------------=
    
    @usableFromInline @Environment(\.locale) var locale: Locale
    @usableFromInline @Environment(\.diffableTextField_onSetup)  var onSetup:  (Proxy) -> Void
    @usableFromInline @Environment(\.diffableTextField_onUpdate) var onUpdate: (Proxy) -> Void
    @usableFromInline @Environment(\.diffableTextField_onSubmit) var onSubmit: (Proxy) -> Void

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
        context.coordinator.downstream = ProxyTextField(uiView)
        Style.onSetup(context.coordinator.downstream)
        self .onSetup(context.coordinator.downstream)
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
        onUpdate(context.coordinator.downstream)
        context.coordinator.synchronize()
    }
    
    //*========================================================================*
    // MARK: * Coordinator
    //*========================================================================*
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Position = DiffableTextViews.Position<UTF16>
        @usableFromInline typealias Storage = DiffableTextViews.Storage<Style,UTF16>
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=

        @usableFromInline let lock = Lock()
        @usableFromInline let storage = Storage()
        @usableFromInline var upstream: DiffableTextField!
        @usableFromInline var downstream:  ProxyTextField!
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=

        @inlinable func style() -> Style {
            upstream.style.locale(upstream.locale)
        }

        //=--------------------------------------------------------------------=
        // MARK: Respond To Submit Events
        //=--------------------------------------------------------------------=
        
        @inlinable public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            upstream.onSubmit(downstream); return true
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
            let range = storage.selection.indices(at: nsRange)
            let changes = Changes(storage.snapshot, change: (string, range))
            //=----------------------------------=
            // MARK: Attempt
            //=----------------------------------=
            attempt: do {
                let commit = try style.merge(changes: changes)
                //=------------------------------=
                // MARK: Push
                //=------------------------------=
                Task { @MainActor in
                    // async to process special commands first
                    // as an example see: (option + backspace)
                    self.storage.change(selection: range.upperBound)
                    self.storage.active(style: style, commit: commit)
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
            self.storage.selection.update(selection: positions, momentum: downstream.momentum)
            //=----------------------------------=
            // MARK: Update Downstream If Needed
            //=----------------------------------=
            if storage.selection.positions != positions {
                lock.perform {
                    self.downstream.update(selection: storage.selection.positions)
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
            // MARK: Pull
            //=------------------------------=
            guard updatable(style: style, value: value) else { return }
            //=------------------------------=
            // MARK: Push - Active
            //=------------------------------=
            if downstream.active {
                self.storage.active(style: style, commit: style.commit(value: value))
                self.push()
            //=------------------------------=
            // MARK: Push - Inactive
            //=------------------------------=
            } else {
                lock.perform {
                    self.storage.inactive(style: style, value: value)
                    self.downstream.update(text: style.format(value: value))
                }
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Push
        //=--------------------------------------------------------------------=
        
        @inlinable func push() {
            self.storage.active = downstream.active
            //=----------------------------------=
            // MARK: Downstream
            //=----------------------------------=
            lock.perform {
                // changes to UITextField's text and selection both call
                // the delegate's method: textFieldDidChangeSelection(_:)
                self.downstream.update(text: storage.snapshot.characters)
                self.downstream.update(selection: storage.selection.positions)
            }
            //=----------------------------------=
            // MARK: Upstream
            //=----------------------------------=
            if  self.upstream.value.wrappedValue != storage.value {
                self.upstream.value.wrappedValue  = storage.value
            }
        }
                
        //=--------------------------------------------------------------------=
        // MARK: Comparisons
        //=--------------------------------------------------------------------=
        
        @inlinable func updatable(style: Style, value: Value) -> Bool {
            value != storage.value || downstream.active != storage.active || style != storage.style
        }
    }
}

//*============================================================================*
// MARK: * DiffableTextField x Configurations
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
// MARK: * DiffableTextField x Configurations x Environment
//*============================================================================*

extension EnvironmentValues {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var diffableTextField_onSetup: (ProxyTextField) -> Void {
        get { self[DiffableTextField_OnSetup.self] }
        set { self[DiffableTextField_OnSetup.self] = newValue }
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
// MARK: * DiffableTextField x Configurations x View
//*============================================================================*

public extension View {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func diffableTextField_onSetup(
        _ onSetup: @escaping (ProxyTextField) -> Void) -> some View {
        environment(\.diffableTextField_onSetup, onSetup)
    }
    
    @inlinable func diffableTextField_onUpdate(
        _ onUpdate: @escaping (ProxyTextField) -> Void) -> some View {
        environment(\.diffableTextField_onUpdate, onUpdate)
    }
    
    @inlinable func diffableTextField_onSubmit(
        _ onSubmit: @escaping (ProxyTextField) -> Void) -> some View {
        environment(\.diffableTextField_onSubmit, onSubmit)
    }
}

#endif
