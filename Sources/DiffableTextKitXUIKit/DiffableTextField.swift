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

/// An as-you-type formatting compatible text field.
///
/// List of all available modifiers:
///
/// - environment(\\.locale, \_:)
/// - environment(\\.layoutDirection, \_:)
/// - diffableTextViews_autocorrectionDisabled(\_:)
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
    
    public typealias Cache = Style.Cache
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
    // MARK: Utilities
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
    // MARK: * Coordinator
    //*========================================================================*
    
    @MainActor public final class Coordinator: NSObject, UITextFieldDelegate {

        @usableFromInline typealias Context = DiffableTextKit.Context<Style>
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var cache:   Cache!
        @usableFromInline var context: Context!
        @usableFromInline var update = Update()

        @usableFromInline var upstream: Upstream<Style>!
        @usableFromInline let downstream = Downstream()
        @usableFromInline var sidestream = Sidestream()
        
        //=--------------------------------------------------------------------=
        // MARK: Events
        //=--------------------------------------------------------------------=
        
        @inlinable @inline(never) func setup(
        _ view:/*---*/ DiffableTextField,
        _ environment: EnvironmentValues) {
            //=----------------------------------=
            // Upstream
            //=----------------------------------=
            self.upstream = Upstream(view, environment)
            //=----------------------------------=
            // Downstream
            //=----------------------------------=
            self.downstream.delegate = self
            self.downstream.textFieldStyle(environment)
            //=----------------------------------=
            // Synchronize
            //=----------------------------------=
            var update = Update()
            self.cache = self.upstream.style.cache()
            self.context = Context(self.pull(),with: &self.cache, then: &update)
            self.push(update)
        }
        
        @inlinable @inline(never) func update(
        _ view:/*---*/ DiffableTextField,
        _ environment: EnvironmentValues) {
            //=----------------------------------=
            // Upstream
            //=----------------------------------=
            self.upstream = Upstream(view, environment)
            //=----------------------------------=
            // Downstream
            //=----------------------------------=
            self.downstream.placeholder(view.title)
            self.downstream.autocorrectionDisabled(environment)
            self.downstream.font(environment)
            self.downstream.foregroundColor(environment)
            self.downstream.keyboardType(environment)
            self.downstream.multilineTextAlignment(environment)
            self.downstream.submitLabel(environment)
            self.downstream.textContentType(environment)
            self.downstream.textInputAutocapitalization(environment)
            //=----------------------------------=
            // Sidestream
            //=----------------------------------=
            self.sidestream = Sidestream(environment)
            //=----------------------------------=
            // Synchronize
            //=----------------------------------=
            self.synchronize(.acyclical)
        }
        
        @inlinable @inline(never) public func textFieldDidBeginEditing(_ view: UITextField) {
            self.synchronize([])
        }
        
        @inlinable @inline(never) public func textFieldDidEndEditing(_   view: UITextField) {
            self.synchronize([])
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Interactions
        //=--------------------------------------------------------------------=
        
        @inlinable @inline(never)
        public func textField(_ view: UITextField,
        shouldChangeCharactersIn nsrange: NSRange,
        replacementString text: String) -> Bool {
            //=----------------------------------=
            // Lock
            //=----------------------------------=
            guard !update else { return false }
            //=----------------------------------=
            // Pull
            //=----------------------------------=
            attempt: do {
                let range: Range<Offset<UTF16>> =
                Offset<UTF16>(nsrange.lowerBound) ..<
                Offset<UTF16>(nsrange.upperBound)
                
                let update = try self.context.merge(
                text, in: range, with:  &self.cache)
                //=------------------------------=
                // Push
                //=------------------------------=
                self.push(update)
            //=----------------------------------=
            // Cancellation
            //=----------------------------------=
            } catch let reason {
                Brrr.cancellation << reason
            }
            //=----------------------------------=
            // Decline Automatic Insertion
            //=----------------------------------=
            return false
        }
        
        @inlinable @inline(never) public func textFieldDidChangeSelection(_ view: UITextField) {
            //=----------------------------------=
            // Marked
            //=----------------------------------=
            if  let _ = view.markedTextRange {
                //=------------------------------=
                // Push
                //=------------------------------=
                self.push([.text, .selection])
            //=----------------------------------=
            // Normal
            //=----------------------------------=
            } else {
                //=------------------------------=
                // Lock
                //=------------------------------=
                guard !update else { return }
                //=------------------------------=
                // Pull
                //=------------------------------=
                let update = self.context.merge(
                downstream.selection,with:[.max,
               .momentums(downstream.momentums)])
                //=------------------------------=
                // Push
                //=------------------------------=
                self.push(update)
            }
        }
        
        @inlinable @inline(never) public func textFieldShouldReturn(_ view: UITextField) -> Bool {
            self.downstream.dismiss()
            self.sidestream.onSubmit?()
            return true
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Synchronization
        //=--------------------------------------------------------------------=
        
        @inlinable func synchronize(_ options: Synchronize) {
            //=----------------------------------=
            // Pull
            //=----------------------------------=
            attempt: do {
                let status = self.pull()
                let update = try self.context.merge(
                status, with: &cache, and:  options)
                //=------------------------------=
                // Push
                //=------------------------------=
                self.push(update)
            //=----------------------------------=
            // Unsynchronizable
            //=----------------------------------=
            } catch let reason {
                Brrr.unsynchronizable << reason
                //=------------------------------=
                // Dismiss
                //=------------------------------=
                Task { self.downstream.dismiss() }
            }
        }
        
        @inlinable func pull() -> Status<Style> {
            //=----------------------------------=
            // Upstream, Downstream
            //=----------------------------------=
            Status(upstream.style, upstream.value, downstream.focus)
        }
        
        @inlinable func push(_ update: Update) {
            //=----------------------------------=
            // State
            //=----------------------------------=
            self.update += update
            //=----------------------------------=
            // Value
            //=----------------------------------=
            if  let _ = self.update.remove(.value) {
                self.upstream.value = context.value
                //=------------------------------=
                // Reentrance
                //=------------------------------=
                return
            }
            //=----------------------------------=
            // Text
            //=----------------------------------=
            if  let _ = self.update.remove(.text) {
                self.downstream.text = context.text
            }
            //=----------------------------------=
            // Selection
            //=----------------------------------=
            if  let _ = self.update.remove(.selection) {
                self.downstream.selection = context.selection()
            }
        }
    }
}

#endif
