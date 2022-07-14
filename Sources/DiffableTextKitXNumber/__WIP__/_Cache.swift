//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

#warning("This can be removed, don't need public protocol...")
//*============================================================================*
// MARK: * Cache
//*============================================================================*

public protocol _Cache: DiffableTextCache where Style: _Style, Value: NumberTextValue {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func optional(_ proposal: Proposal) throws -> Commit<Value?>
}

//*============================================================================*
// MARK: * Cache x Internal
//*============================================================================*

@usableFromInline protocol _Cache_Internal: _Cache where Style: _Style_Internal {
    associatedtype Format: _Format where Format.FormatInput == Value
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var style: Style { get }
    
    @inlinable var adapter: _Adapter<Format> { get }
    
    @inlinable var interpreter: NumberTextReader { get }
    
    @inlinable var preferences: Preferences<Value> { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func number(_ snapshot: Snapshot) throws -> Number
    
    @inlinable func number(_ proposal: Proposal) throws -> Number
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func snapshot(_ characters: String) -> Snapshot

    @inlinable func characters(_ value: Value, _ number: Number, _ format: Format) -> String
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Cache_Internal {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var format: Format {
        adapter.format
    }
    
    @inlinable var bounds: NumberTextBounds<Value> {
        style.bounds ?? preferences.bounds
    }
    
    @inlinable var precision: NumberTextPrecision<Value> {
        style.precision ?? preferences.precision
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func value(_ number: Number) throws -> Value {
        try adapter.parse(number)
    }
    
    @inlinable func number(_ snapshot: Snapshot) throws -> Number {
        try interpreter.components.number(in: snapshot, as: Value.self)!
    }
    
    @inlinable func number(_ proposal: Proposal) throws -> Number {
        try interpreter.number(proposal, as: Value.self)!
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func characters(_ value: Value, _ number: Number, _ format: Format) -> String {
        var characters = format.sign(number.sign)
       .separator(number.separator).format(value)
        let signs = interpreter.components.signs
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        if  number.sign == .negative, value == .zero,
        let index = characters.firstIndex(of: signs[.positive]) {
            //=----------------------------------=
            // Make Positive Zero Negative
            //=----------------------------------=
            let replacement = String(signs[.negative])
            characters.replaceSubrange(index...index, with: replacement)
        }
        //=--------------------------------------=
        // Return
        //=--------------------------------------=
        return characters
    }
    
    @inlinable func snapshot(_ characters: String) -> Snapshot {
        Snapshot(characters, as: interpreter.attributes.map(_:))
    }
    
    @inlinable func commit(_ value: Value, _ number: Number, _ format: Format) -> Commit<Value> {
        Commit(value, snapshot(characters(value, number, format)))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension _Cache_Internal {
    
    //=------------------------------------------------------------------------=
    // MARK: Optional
    //=------------------------------------------------------------------------=
    
    #warning("WIP...............................................................")
    @inlinable public func optional(_ proposal: Proposal) throws -> Commit<Value?> {
        let optional = try interpreter.number(proposal, as: Value?.self)
        return try optional.map({ try Commit(resolve($0)) }) ?? Commit()
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilites
//=----------------------------------------------------------------------------=

extension _Cache_Internal {
    
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
        var value  = value
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&value)
        //=--------------------------------------=
        // Number
        //=--------------------------------------=
        let format = format.precision(precision.active())
        
        let formatted = format.format(value)
        let parseable =  snapshot(formatted)
        var number = try!  number(parseable)
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds   .autocorrect(&number)
        precision.autocorrect(&number)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        value = try! self.value(number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return self.commit(value, number, format)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func resolve(_ proposal: Proposal) throws -> Commit<Value> {
        try resolve(number(proposal))
    }
    
    /// The resolve method body, also used by styles such as: optional.
    @inlinable func resolve(_ number: Number) throws -> Commit<Value> {
        let count  = number.count()
        var number = number
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds   .autovalidate(&number)
        try precision.autovalidate(&number, count)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        let value = try self.value(number)
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(value, &number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        let format = format.precision(precision.interactive(count))
        return commit(value, number, format)
    }
}