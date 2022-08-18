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
// MARK: * Cache
//*============================================================================*

@usableFromInline protocol _Cache: NullableTextStyle {
    
    associatedtype Style: _Default where Style.Input == Value
    
    associatedtype Format: _Format where Format.FormatInput == Value
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var style: Style { get set }
    
    @inlinable var preferences: Preferences<Value> { get }

    @inlinable var parser: Parser<Format> { get }
    
    @inlinable var formatter: Formatter<Format> { get }
        
    @inlinable var interpreter: Interpreter { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ style: Style)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func merge(_ style: Style) -> Bool
    
    @inlinable func snapshot(_ characters: String) -> Snapshot
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension _Cache {

    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var bounds: _Bounds<Value> {
        style.bounds ?? preferences.bounds
    }

    @inlinable var precision: _Precision<Value> {
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

extension _Cache {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=
    
    @inlinable public func format(_ value: Value, with cache: inout Void) -> String {
        formatter.precision(precision.inactive()).format(value)
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
        let formatter = formatter.precision(precision.active())
        let numberable = self.snapshot(formatter.format(value))
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
        return Commit(value,snapshot(formatter.format(
        value, number, with: interpreter.components)))
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
        var number = number
        let count  = Count(number)
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
        let precision = precision.interactive(count)
        let formatter = formatter.precision(precision)
        return Commit(value,snapshot(formatter.format(
        value, number, with: interpreter.components)))
    }
}
