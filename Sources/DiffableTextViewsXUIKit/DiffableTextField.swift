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
    
    @usableFromInline let style: Style
    @usableFromInline let value: Binding<Value>
    @usableFromInline let title: String

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ title: String = "",
    value: Binding<Value>, style: Style) {
        self.style = style
        self.value = value
        self.title = title
    }
    
    @inlinable public init(_ title: String = "",
    value: Binding<Value>, style: () -> Style) {
        self.style = style()
        self.value = value
        self.title = title
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
    // MARK: Declaration
    //*========================================================================*
    
    @MainActor public final class Coordinator: NSObject, UITextFieldDelegate {
        @usableFromInline typealias Position = Unicode.UTF16.Position
        @usableFromInline typealias Status = DiffableTextKit.Status<Style>
        @usableFromInline typealias Context = DiffableTextKit.Context<Style>
        @usableFromInline typealias Upstream = DiffableTextViewsXUIKit.Upstream<Style>

        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let lock = Lock()
        
        @usableFromInline var context: Context!
        @usableFromInline var actions = Actions()
        
        @usableFromInline var upstream: Upstream!
        @usableFromInline let downstream = Downstream()
        
        //=--------------------------------------------------------------------=
        // MARK: View Life Cycle
        //=--------------------------------------------------------------------=
        
        @inlinable @inline(never)
        func setup(_ parent: DiffableTextField, _ environment: EnvironmentValues) {
            //=----------------------------------=
            // Upstream
            //=----------------------------------=
            self.upstream = Upstream(parent, environment)
            //=----------------------------------=
            // Downstream
            //=----------------------------------=
            self.downstream.delegate = self
            self.downstream.setTextFeldStyle(environment)
            //=----------------------------------=
            // Synchronize
            //=----------------------------------=
            self.context = Context(self.pull()); self.push(.text)
        }
        
        @inlinable @inline(never)
        func update(_ parent: DiffableTextField, _ environment: EnvironmentValues) {
            //=----------------------------------=
            // Upstream
            //=----------------------------------=
            self.upstream = Upstream(parent, environment)
            //=----------------------------------=
            // Downstream
            //=----------------------------------=
            self.downstream.setPlaceholder(parent.title)
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
            self.actions = Actions(environment)
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
            // Lock
            //=----------------------------------=
            if lock.isLocked { return false }
            //=----------------------------------=
            // Pull
            //=----------------------------------=
            attempt: do {
                let update = try self.context.merge(characters,
                in: Range(nsrange: nsrange, as: Position.self))
                //=------------------------------=
                // Push
                //=------------------------------=
                self.push(update)
                self.lock.task {
                    // see [option + backspace]
                    await self.push(.selection)
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
            // Marked
            //=----------------------------------=
            if let S0 = textField.markedTextRange {
                //=------------------------------=
                // Print
                //=------------------------------=
                Info.print(cancellation:[
                "marked text",
                .mark(textField.text(in: S0)!),
                "sessions have been disabled"])
                //=------------------------------=
                // Reset
                //=------------------------------=
                return self.push([.text, .selection])
            //=----------------------------------=
            // Normal
            //=----------------------------------=
            } else {
                //=------------------------------=
                // Lock
                //=------------------------------=
                if lock.isLocked { return }
                //=------------------------------=
                // Pull
                //=------------------------------=
                let update = self.context.merge(
                selection: downstream.selection,
                momentums: downstream.momentums)
                //=------------------------------=
                // Push
                //=------------------------------=
                self.push(update)
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Events
        //=--------------------------------------------------------------------=

        @inlinable public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder(); actions.onSubmit?(); return true
        }
        
        @inlinable public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.synchronize()
        }
        
        @inlinable public func textFieldDidEndEditing(_ textField: UITextField) {
            self.synchronize()
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Synchronization
        //=--------------------------------------------------------------------=
        
        @inlinable func synchronize() {
            //=----------------------------------=
            // Pull
            //=----------------------------------=
            let status = self.pull()
            let update = self.context.merge(status)
            //=----------------------------------=
            // Push
            //=----------------------------------=
            self.push(update)
        }
        
        @inlinable func pull() -> Status {
            //=----------------------------------=
            // Upstream, Downstream
            //=----------------------------------=
            Status(upstream.style, upstream.value.wrappedValue, downstream.focus)
        }
        
        @inlinable func push(_ update: Update) {
            self.lock.perform {
                //=------------------------------=
                // Text
                //=------------------------------=
                if update.contains(.text) {
                    self.downstream.text = context.text
                }
                //=------------------------------=
                // Selection
                //=------------------------------=
                if update.contains(.selection) {
                    self.downstream.selection = context.selection()
                }
                //=------------------------------=
                // Value
                //=------------------------------=
                if update.contains(.value) {
                    self.upstream.value.wrappedValue = context.value
                }
            }
        }
    }
}

#endif
