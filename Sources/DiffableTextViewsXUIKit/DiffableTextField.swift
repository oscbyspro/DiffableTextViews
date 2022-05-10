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
// MARK: Declaration
//*============================================================================*

/// An as-you-type formatting compatible text field.
///
/// List of all available modifiers:
///
/// - environment(\\.locale, \_:)
/// - environment(\\.layoutDirection, \_:)
/// - diffableTextViews_disableAutocorrection(\_:)
/// - diffableTextViews_font(\_:)
/// - diffableTextViews_foregroundColor(\_:)
/// - diffableTextViews_multilineTextAlignment(\_:)
/// - diffableTextViews_onSubmit(\_:)
/// - diffableTextViews_submitLabel(\_:)
/// - diffableTextViews_textContentType(\_:)
/// - diffableTextViews_textFieldStyle(\_:)
/// - diffableTextViews_textInputAutocapitalization(\_:)
/// - diffableTextViews_tint(\_:)
///
public struct DiffableTextField<Style: DiffableTextStyle>: UIViewRepresentable {
    public typealias Value = Style.Value

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let title: String
    @usableFromInline let style: Style
    @usableFromInline let value: Binding<Value>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ title: String = "",
    value: Binding<Value>, style: Style) {
        self.title = title
        self.value = value
        self.style = style
    }
    
    @inlinable public init(_ title: String = "",
    value: Binding<Value>, style: () -> Style) {
        self.title = title
        self.value = value
        self.style = style()
    }
 
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(__always) func locale(_ locale: Locale) -> Self {
        Self(title, value: value, style: style.locale(locale))
    }

    //=------------------------------------------------------------------------=
    // MARK: View Life Cycle
    //=------------------------------------------------------------------------=
    
    @inlinable public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    @inlinable public func makeUIView(context: Self.Context) -> UITextField {
        context.coordinator.setup(self, context.environment)
        return context.coordinator.downstream.view
    }
    
    @inlinable public func updateUIView(_ view:  UITextField, context: Self.Context) {
        context.coordinator.update(self, context.environment)
    }
        
    //*========================================================================*
    // MARK: Coordinator
    //*========================================================================*
    
    public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Upstream = DiffableTextField
        @usableFromInline typealias Environment = EnvironmentValues
        @usableFromInline typealias Position = Unicode.UTF16.Position
        @usableFromInline typealias Status = DiffableTextKit.Status<Style>
        @usableFromInline typealias Context = DiffableTextKit.Context<Style>

        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let lock = Lock()
        @usableFromInline var context: Context!
        @usableFromInline var onSubmit = Trigger(nil)
        
        @usableFromInline var upstream: Upstream!
        @usableFromInline let downstream = Downstream()

        //=--------------------------------------------------------------------=
        // MARK: View Life Cycle
        //=--------------------------------------------------------------------=
        
        @inlinable @inline(never) func setup(
        _ upstream: Upstream, _ environment: Environment) {
            //=----------------------------------=
            // Upstream
            //=----------------------------------=
            self.upstream = upstream.locale(environment.locale)
            //=----------------------------------=
            // Downstream
            //=----------------------------------=
            self.downstream.view.delegate = self
            self.downstream.setTextFeldStyle(environment)
            self.downstream.setSensibleValues(Style.self)
            //=----------------------------------=
            // Synchronize
            //=----------------------------------=
            self.context = Context(self.pull())
            self.write()
        }
        
        @inlinable @inline(never) func update(
        _ upstream: Upstream, _ environment: Environment) {
            //=----------------------------------=
            // Upstream
            //=----------------------------------=
            self.upstream = upstream.locale(environment.locale)
            //=----------------------------------=
            // Downstream
            //=----------------------------------=
            self.downstream.setTitle(upstream.title)
            self.downstream.setDisableAutocorrection(environment)
            self.downstream.setFont(environment)
            self.downstream.setForegroundColor(environment)
            self.downstream.setKeyboardType(environment)
            self.downstream.setMultilineTextAlignment(environment)
            self.downstream.setSubmitLabel(environment)
            self.downstream.setTextContentType(environment)
            self.downstream.setTextInputAutocapitalization(environment)
            //=----------------------------------=
            // Coordinator
            //=----------------------------------=
            self.onSubmit = environment.diffableTextViews_onSubmit
            //=----------------------------------=
            // Synchronize
            //=----------------------------------=
            self.synchronize()
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Events
        //=--------------------------------------------------------------------=
        
        @inlinable @inline(never)
        public func textField(_ textField: UITextField,
        shouldChangeCharactersIn nsrange: NSRange,
        replacementString characters: String) -> Bool {
            //=----------------------------------=
            // Merge
            //=----------------------------------=
            attempt: do {
                var context = context!
                try context.merge(characters, in:
                Position(nsrange.lowerBound) ..<
                Position(nsrange.upperBound))
                //=------------------------------=
                // Push
                //=------------------------------=
                Task { @MainActor [context] in
                    // async to process special commands first
                    // as an example see: (option + backspace)
                    self.context = context
                    self.push()
                }
            //=----------------------------------=
            // Cancellation
            //=----------------------------------=
            } catch let reason {
                Info.print(cancellation: [.note(reason)])
            }
            //=----------------------------------=
            // Decline Automatic Insertion
            //=----------------------------------=
            return false
        }
        
        @inlinable @inline(never)
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            //=----------------------------------=
            // Disable Marked Text
            //=----------------------------------=
            guard textField.markedTextRange == nil else {
                Info.print(cancellation: ["marked text is disallowed"])
                return self.write()
            }
            //=----------------------------------=
            // Locked
            //=----------------------------------=
            guard !lock.isLocked else { return }
            let selection = downstream.selection
            //=----------------------------------=
            // Update
            //=----------------------------------=
            self.context.update(selection: selection, momentum: downstream.momentum)
            let autocorrected = context.selection(as: Position.self)
            //=----------------------------------=
            // Update Downstream As Needed
            //=----------------------------------=
            if  selection != autocorrected {
                lock.perform {
                    self.downstream.selection = autocorrected
                }
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Events
        //=--------------------------------------------------------------------=

        @inlinable public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder(); onSubmit(); return true
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
            // Pull
            //=----------------------------------=
            guard context.merge(self.pull()) else { return }
            //=----------------------------------=
            // Push
            //=----------------------------------=
            self.context.focus.wrapped ? self.push() : self.write()
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Synchronization
        //=--------------------------------------------------------------------=
        
        @inlinable func pull() -> Status {
            //=----------------------------------=
            // Upstream, Downstream
            //=----------------------------------=
            Status(upstream.style,
            upstream.value.wrappedValue,
            downstream.focus)
        }

        @inlinable func push() {
            //=----------------------------------=
            // Downstream, Upstream
            //=----------------------------------=
            self.write()
            self.relay()
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Synchronization
        //=--------------------------------------------------------------------=
        
        @inlinable func write() {
            //=----------------------------------=
            // Downstream
            //=----------------------------------=
            lock.perform {
                //=------------------------------=
                // Text
                //=------------------------------=
                self.downstream.text = context.text
                //=------------------------------=
                // Selection
                //=------------------------------=
                if  self.downstream.focus.wrapped {
                    self.downstream.selection = context.selection()
                }
            }
        }
        
        @inlinable func relay() {
            //=--------------------------------------=
            // Upstream
            //=--------------------------------------=
            if  self.upstream.value.wrappedValue != context.value {
                self.upstream.value.wrappedValue  = context.value
            }
        }
    }
}

#endif
