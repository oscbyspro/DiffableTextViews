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
    // MARK: View Life Cycle
    //=------------------------------------------------------------------------=
    
    @inlinable public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    @inlinable public func makeUIView(context: Self.Context) -> BasicTextField {
        let downstream = Downstream()
        let view = downstream.wrapped
        //=--------------------------------------=
        // MARK: View
        //=--------------------------------------=
        view.font = UIFont(DiffableTextFont.body.monospaced())
        view.setTextAlignment(context.environment.multilineTextAlignment)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        //=--------------------------------------=
        // MARK: Downstream
        //=--------------------------------------=
        downstream.transform(Style.onSetup)
        downstream.transform(context.environment.diffableTextField_onSetup)
        //=--------------------------------------=
        // MARK: Done
        //=--------------------------------------=
        context.coordinator.setup((self,  context.environment, downstream))
        return view
    }
    
    @inlinable public func updateUIView(_ uiView: UIViewType, context: Self.Context) {
        context.coordinator.update((self, context.environment))
    }
    
    //*========================================================================*
    // MARK: * Coordinator
    //*========================================================================*
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Upstream = DiffableTextField
        @usableFromInline typealias Environment = EnvironmentValues
        @usableFromInline typealias Position = Unicode.UTF16.Position

        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let lock = Lock()
        @usableFromInline var upstream: Upstream!
        @usableFromInline var downstream: Downstream!
        @usableFromInline var environment: Environment!
        @usableFromInline var context: Context<Style>!

        //=--------------------------------------------------------------------=
        // MARK: View Life Cycle
        //=--------------------------------------------------------------------=
        
        @inlinable func setup(_ values: (Upstream, Environment, Downstream)) {
            (upstream, environment, downstream) = values
            self.downstream.wrapped.delegate = self
            self.context = .init(self.pull()); self.write()
        }
        
        @inlinable func update(_ values: (Upstream, Environment)) {
            (upstream, environment) = values; self.synchronize()
            self.downstream.transform(environment.diffableTextField_onUpdate)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Events
        //=--------------------------------------------------------------------=
        
        @inlinable public func textField(_ textField: UITextField,
        shouldChangeCharactersIn nsrange: NSRange,
        replacementString characters: String) -> Bool {
            //=----------------------------------=
            // MARK: Merge
            //=----------------------------------=
            attempt: do {
                var context = context!
                try context.merge(characters, in:
                Position(nsrange.lowerBound) ..<
                Position(nsrange.upperBound))
                //=------------------------------=
                // MARK: Push
                //=------------------------------=
                Task { @MainActor [context] in
                    // async to process special commands first
                    // as an example see: (option + backspace)
                    self.context = context
                    self.push()
                }
            //=----------------------------------=
            // MARK: Cancellation
            //=----------------------------------=
            } catch let reason {
                Info.print(cancellation: [.note(reason)])
            }
            //=----------------------------------=
            // MARK: Decline Automatic Insertion
            //=----------------------------------=
            return false
        }
        
        @inlinable public func textFieldDidChangeSelection(_ textField: UITextField) {
            guard !lock.isLocked else { return }
            let selection = downstream.selection
            //=----------------------------------=
            // MARK: Update
            //=----------------------------------=
            self.context.update(selection: selection, momentum: downstream.momentum)
            let autocorrected = context.selection(as: Position.self)
            //=----------------------------------=
            // MARK: Update Downstream As Needed
            //=----------------------------------=
            if  selection != autocorrected {
                lock.perform {
                    self.downstream.update(selection: autocorrected)
                }
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Events
        //=--------------------------------------------------------------------=

        @inlinable public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            downstream.transform(environment.diffableTextField_onSubmit)
            downstream.wrapped.resignFirstResponder()
            return true
        }
        
        @inlinable public func textFieldDidBeginEditing(_ textField: UITextField) {
            synchronize()
        }
        
        @inlinable public func textFieldDidEndEditing(_ textField: UITextField) {
            synchronize()
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Synchronization
        //=--------------------------------------------------------------------=
        
        @inlinable func synchronize() {
            //=----------------------------------=
            // MARK: Pull
            //=----------------------------------=
            guard context.merge(self.pull()) else { return }
            //=----------------------------------=
            // MARK: Push
            //=----------------------------------=
            context.focus.value ? self.push() : self.write()
        }
        
        @inlinable func pull() -> Remote<Style> {
            //=----------------------------------=
            // MARK: Upstream, Downstream
            //=----------------------------------=
            Remote(style: self.upstream.style.locale(environment.locale),
            value: upstream.value.wrappedValue, focus: downstream.focus)
        }

        @inlinable func push() {
            //=----------------------------------=
            // MARK: Downstream
            //=----------------------------------=
            lock.perform {
                self.downstream.update(text: context.text)
                self.downstream.update(selection: context.selection())
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
                self.downstream.update(text: context.text)
            }
        }
    }
}

//*============================================================================*
// MARK: * DiffableTextField x ID
//*============================================================================*

public struct DiffableTextFieldID {
    public static let diffableTextField = Self()
}

//*============================================================================*
// MARK: * DiffableTextField x Environment
//*============================================================================*

@usableFromInline enum DiffableTextField_OnSetup: EnvironmentKey {
    @usableFromInline static let defaultValue: Trigger<ProxyTextField> = nil
}

@usableFromInline enum DiffableTextField_OnUpdate: EnvironmentKey {
    @usableFromInline static let defaultValue: Trigger<ProxyTextField> = nil
}

@usableFromInline enum DiffableTextField_OnSubmit: EnvironmentKey {
    @usableFromInline static let defaultValue: Trigger<ProxyTextField> = nil
}

//*============================================================================*
// MARK: * DiffableTextField x Environment x Values
//*============================================================================*

extension EnvironmentValues {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var diffableTextField_onSetup: Trigger<ProxyTextField> {
        get { self[DiffableTextField_OnSetup.self] }
        set { self[DiffableTextField_OnSetup.self] &+= newValue }
    }
    
    @inlinable var diffableTextField_onUpdate: Trigger<ProxyTextField> {
        get { self[DiffableTextField_OnUpdate.self] }
        set { self[DiffableTextField_OnUpdate.self] &+= newValue }
    }

    @inlinable var diffableTextField_onSubmit: Trigger<ProxyTextField> {
        get { self[DiffableTextField_OnSubmit.self] }
        set { self[DiffableTextField_OnSubmit.self] &+= newValue }
    }
}

//*============================================================================*
// MARK: * DiffableTextField x Environment x View
//*============================================================================*

public extension View {
    
    //=------------------------------------------------------------------------=
    // MARK: Setup
    //=------------------------------------------------------------------------=
    
    @inlinable func onSetup(of view: DiffableTextFieldID,
    _ action: @escaping (ProxyTextField) -> Void) -> some View {
        environment(\.diffableTextField_onSetup, Trigger(action))
    }
    
    @inlinable func onSetupScope(of view: DiffableTextFieldID) -> some View {
        environment(\.diffableTextField_onSetup, nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Update
    //=------------------------------------------------------------------------=
    
    @inlinable func onUpdate(of view: DiffableTextFieldID,
    _ action: @escaping (ProxyTextField) -> Void) -> some View {
        environment(\.diffableTextField_onUpdate, Trigger(action))
    }
    
    @inlinable func onUpdateScope(of view: DiffableTextFieldID) -> some View {
        environment(\.diffableTextField_onUpdate, nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Submit
    //=------------------------------------------------------------------------=
    
    @inlinable func onSubmit(of view: DiffableTextFieldID,
    _ action: @escaping (ProxyTextField) -> Void) -> some View {
        environment(\.diffableTextField_onSubmit, Trigger(action))
    }
    
    @inlinable func onSubmitScope(of view: DiffableTextFieldID) -> some View {
        environment(\.diffableTextField_onSubmit, nil)
    }
}

#endif
