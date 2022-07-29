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
// MARK: * Default x Cache
//*============================================================================*

@usableFromInline protocol _DefaultCache<Style>: NullableTextStyle where Value == Style.Input {
    
    associatedtype Style: _DefaultStyle
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var style: Style { get set }
    
    @inlinable var preferences: Preferences<Value> { get }

    @inlinable var parser: Parser<Style.Format> { get }
    
    @inlinable var formatter: Formatter<Style.Format> { get }
        
    @inlinable var interpreter: Interpreter { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ style: Style)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func compatible(_ style: Style) -> Bool
    
    @inlinable func snapshot(_ characters: String) -> Snapshot
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _DefaultCache {

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var bounds: Bounds<Value> {
        style.bounds ?? preferences.bounds
    }

    @inlinable var precision: Precision<Value> {
        style.precision ?? preferences.precision
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.style == rhs.style
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension _DefaultCache {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Value, with cache: inout Void) -> String {
        formatter.with(precision.inactive()).format(value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Active
    //=------------------------------------------------------------------------=
    
    @inlinable public func interpret(_ value: Value, with cache: inout Void) -> Commit<Value> {
        var value = value
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds.autocorrect(&value)
        //=--------------------------------------=
        // Number
        //=--------------------------------------=
        let formatter = formatter.with(precision.active())
        let numberable = snapshot(formatter.format(value))
        var number = try! interpreter.number(numberable, as: Value.self)!
        //=--------------------------------------=
        // Autocorrect
        //=--------------------------------------=
        bounds   .autocorrect(&number)
        precision.autocorrect(&number)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        value = try! parser.parse(number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        return commit(value, number, with: formatter)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func resolve(_ proposal: Proposal,
    with cache: inout Void) throws -> Commit<Value> {
        try resolve(interpreter.number(proposal, as: Value.self)!)
    }
    
    @inlinable public func resolve(optional proposal: Proposal,
    with cache: inout Void) throws -> Commit<Value?> {
        let number = try interpreter.number(proposal, as: Value?.self)
        return try number.map({ try Commit(resolve($0)) }) ?? Commit()
    }
    
    @inlinable func resolve(_ number: Number) throws -> Commit<Value> {
        var number = number; let count = number.count
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds   .autovalidate(&number)
        try precision.autovalidate(&number, count)
        //=--------------------------------------=
        // Value
        //=--------------------------------------=
        let value = try parser.parse(number)
        //=--------------------------------------=
        // Autovalidate
        //=--------------------------------------=
        try bounds.autovalidate(value, &number)
        //=--------------------------------------=
        // Commit
        //=--------------------------------------=
        let formatter = formatter.with(precision.interactive(count))
        return commit(value, number, with: formatter)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Helpers
    //=------------------------------------------------------------------------=
    
    @inlinable func commit(_ value: Value, _ number: Number,
    with formatter: Formatter<Style.Format>) -> Commit<Value> {
        let components = interpreter.components
        let characters = formatter.format(value, number, with: components)
        return Commit(value, snapshot(characters))
    }
}
