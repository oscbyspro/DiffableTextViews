//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit
import Foundation

//*============================================================================*
// MARK: * Style
//*============================================================================*

public struct _NumberTextStyle<Format: NumberTextFormat>: NumberTextStyleProtocol {
    public typealias Adapter = NumberTextAdapter<Format>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var adapter: Adapter
    public var bounds: Bounds
    public var precision: Precision
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ format: Format) {
        self.adapter = Adapter(format)
        self.bounds = adapter.preferred()
        self.precision = adapter.preferred()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func locale(_ locale: Locale) -> Self {
        var result = self; result.adapter.update(locale); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.adapter == rhs.adapter
        && lhs.bounds == rhs.bounds
        && lhs.precision == rhs.precision
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension _NumberTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Value) -> String {
        format.precision(precision.inactive()).format(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Active
    //=------------------------------------------------------------------------=
    
    @inlinable public func interpret(_ value: Value) -> Commit<Value> {
        var value = value; let style = format.precision(precision.active())
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&value)
        //=--------------------------------------=
        // Number
        //=--------------------------------------=
        let formatted = style.format(value)
        let parseable = snapshot(formatted)
        var number = try! adapter.number(parseable)
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&number)
        precision.autocorrect(&number)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        value = try! adapter.value(number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return commit(value, number, style)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func resolve(_ proposal: Proposal) throws -> Commit<Value> {
        try resolve(number(proposal)!)
    }
    
    /// The resolve method body, also used by styles such as: optional.
    @inlinable func resolve(_ number: Number) throws -> Commit<Value> {
        var number = number; let count = number.count()
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(&number)
        try precision.autovalidate(&number, count)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        let value = try adapter.value(number)
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(value, &number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        let style = format.precision(precision.interactive(count))
        return commit(value, number, style)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Helpers
//=----------------------------------------------------------------------------=

extension _NumberTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Snapshot
    //=------------------------------------------------------------------------=
    
    /// Assumes characters contain at least one content character.
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        //=--------------------------------------=
        // Snapshot
        //=--------------------------------------=
        var snapshot = characters.reduce(into: Snapshot()) { snapshot, character in
            snapshot.append(reader.attributes[character])
        }
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        adapter.autocorrect(&snapshot); return snapshot
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Commit
    //=------------------------------------------------------------------------=
    
    @inlinable func commit(_ value: Value, _ number: Number, _ style: Format) -> Commit<Value> {
        //=--------------------------------------=
        // Style
        //=--------------------------------------=
        let style = style.sign(number.sign).separator(number.separator)
        //=--------------------------------------=
        // Characters
        //=--------------------------------------=
        var characters = style.format(value); self.fix(number.sign, for: value, in: &characters)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return Commit(value, snapshot(characters))
    }
    
    /// This method exists because formatting zero always yields a positive sign.
    @inlinable func fix(_ sign: Sign, for value: Value, in characters: inout String)  {
        //=--------------------------------------=
        // Correctable
        //=--------------------------------------=
        guard sign == .negative, value == .zero, let index = characters.firstIndex(
        of: reader.components.signs[sign.toggled()]) else { return }
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        characters.replaceSubrange(index...index, with: String(reader.components.signs[sign]))
    }
}
