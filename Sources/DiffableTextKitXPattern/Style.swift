//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import DiffableTextKit

//*============================================================================*
// MARK: * Style
//*============================================================================*

public struct PatternTextStyle<Value>: DiffableTextStyle where Value: Equatable,
Value: RangeReplaceableCollection, Value.Element == Character {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let pattern: String
    @usableFromInline var placeholders = Placeholders()
    @usableFromInline var hidden = false
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ pattern: String) { self.pattern = pattern }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Marks a single character as a placeholder.
    @inlinable public func placeholders(_ character: Character,
    where predicate: @escaping (Character) -> Bool) -> Self {
        var S0 = self; S0.placeholders = .init((character, predicate)); return S0
    }
    
    /// Marks multiple characters as placeholders.
    @inlinable public func placeholders(_ placeholders: [Character: (Character) -> Bool]) -> Self {
        var S0 = self; S0.placeholders = .init(placeholders); return S0
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Hides the pattern's suffix.
    ///
    /// Characters after the last value, or from the first placeholder, are excluded.
    ///
    /// ```
    /// |+|1|2|_|(|3|4|5|)|_|6|7|8|-|9|~
    /// |x|o|o|x|x|o|o|o|x|x|o|o|o|x|o|~ (HIDDEN)
    /// ```
    ///
    /// ```
    /// |+|1|2|_|(|3|4|5|)|_|6|7|8|-|9|#|-|#|#|~
    /// |x|o|o|x|x|o|o|o|x|x|o|o|o|x|o|x|x|x|x|~ (VISIBLE)
    /// ```
    ///
    @inlinable public func hidden(_ hidden: Bool = true) -> Self {
        var S0 = self;  S0.hidden = hidden; return S0
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

extension PatternTextStyle {
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive
    //=------------------------------------------------------------------------=
    
    /// - Mismatches are separated.
    @inlinable public func format(_ value: Value, with cache: inout Void) -> String {
        reduce(with: value, into: String()) {
            characters, virtuals, nonvirtual in
            characters.append(contentsOf: virtuals)
            characters.append(nonvirtual)
        } none: {
            characters, virtuals in
            characters.append(contentsOf: virtuals)
        } done: {
            characters, virtuals, mismatches in
            //=----------------------------------=
            // Pattern
            //=----------------------------------=
            if !hidden {
                characters.append(contentsOf: virtuals)
            }
            //=----------------------------------=
            // Mismatches
            //=----------------------------------=
            if !mismatches.isEmpty {
                characters.append("|")
                characters.append(contentsOf: mismatches)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Active
    //=------------------------------------------------------------------------=
    
    /// - Mismatches are removed.
    @inlinable public func interpret(_ value: Value, with cache: inout Void) -> Commit<Value> {
        reduce(with: value, into: Commit()) {
            commit, virtuals, nonvirtual in
            commit.snapshot.append(contentsOf: virtuals, as: .phantom)
            commit.snapshot.append(nonvirtual)
            commit.value   .append(nonvirtual)
        } none: {
            commit, virtuals in
            commit.snapshot.append(contentsOf: virtuals, as: .phantom)
            commit.select({ $0.endIndex })
        } done: {
            commit, virtuals, mismatches in
            //=----------------------------------=
            // Pattern
            //=----------------------------------=
            if !hidden {
                commit.snapshot.append(contentsOf: virtuals, as: .phantom)
            }
            //=----------------------------------=
            // Mismatches
            //=----------------------------------=
            if !mismatches.isEmpty {
                Brrr.autocorrection << Info([.mark(value), "has invalid suffix \(mismatches)"])
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Interactive
    //=------------------------------------------------------------------------=
    
    /// - Mismatches throw an error.
    @inlinable public func resolve(_ proposal: Proposal, with cache: inout Void) throws -> Commit<Value> {
        try reduce(with: proposal.lazy.merged().nonvirtuals(), into: Commit()) {
            commit, virtuals, nonvirtual in
            commit.snapshot.append(contentsOf: virtuals, as: .phantom)
            commit.snapshot.append(nonvirtual)
            commit.value   .append(nonvirtual)
        } none: {
            commit, virtuals in
            commit.snapshot.append(contentsOf: virtuals, as: .phantom)
            commit.select({ $0.endIndex })
        } done: {
            commit, virtuals, mismatches in
            //=----------------------------------=
            // Pattern
            //=----------------------------------=
            if !hidden {
                commit.snapshot.append(contentsOf: virtuals, as: .phantom)
            }
            //=----------------------------------=
            // Mismatches
            //=----------------------------------=
            if !mismatches.isEmpty {
                //=------------------------------=
                // Content <= Capacity
                //=------------------------------=
                if !virtuals.isEmpty {
                    throw Info([.mark(mismatches.first!), "is invalid"])
                //=------------------------------=
                // Content >  Capacity
                //=------------------------------=
                } else {
                    let capacity = Info.note(commit.value.count)
                    let elements = Info.mark(commit.snapshot.characters + mismatches)
                    throw Info(["\(elements) exceeded pattern capacity \(capacity)"])
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Inactive, Active, Interactive x Reduce
    //=------------------------------------------------------------------------=
    
    @inlinable @inline(never) func reduce<Content, Result>(
    with content: Content,into result: Result,
    some: (inout Result, Substring, Character) -> Void,
    none: (inout Result, Substring) -> Void,
    done: (inout Result, Substring, Content.SubSequence) throws -> Void)
    rethrows -> Result where Content: Collection<Character> {
        //=--------------------------------------=
        // State
        //=--------------------------------------=
        var result = result
        var cIndex = content.startIndex
        var pIndex = pattern.startIndex
        var qIndex = pIndex // position
        //=--------------------------------------=
        // Matches
        //=--------------------------------------=
        matches: while qIndex != pattern.endIndex {
            //=----------------------------------=
            // Position == Placeholder
            //=----------------------------------=
            if  let predicate = placeholders[pattern[qIndex]] {
                guard cIndex != content.endIndex else { break matches }
                let nonvirtual = content[cIndex]
                guard predicate(nonvirtual) /**/ else { break matches }
                //=------------------------------=
                // (!) Some
                //=------------------------------=
                some(&result, pattern[pIndex ..< qIndex], nonvirtual)
                content.formIndex(after: &cIndex)
                pattern.formIndex(after: &qIndex)
                pIndex = qIndex
            //=----------------------------------=
            // Position != Placeholder
            //=----------------------------------=
            } else {
                pattern.formIndex(after: &qIndex)
            }
        }
        //=--------------------------------------=
        // (!) None
        //=--------------------------------------=
        if  pIndex == pattern.startIndex {
            //=----------------------------------=
            // Placeholders == 0
            //=----------------------------------=
            if  qIndex == pattern.endIndex {
                none(&result, pattern[pIndex ..< pIndex])
            //=----------------------------------=
            // Placeholders >= 1
            //=----------------------------------=
            } else {
                none(&result, pattern[pIndex ..< qIndex])
                pIndex = qIndex
            }
        }
        //=--------------------------------------=
        // (!) Done
        //=--------------------------------------=
        try done(&result, pattern[pIndex...], content[cIndex...]); return result
    }
}

//*============================================================================*
// MARK: * Style x Init
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + String
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == PatternTextStyle<String> {
    
    /// Creates a `PatternTextStyle` without placeholders.
    ///
    /// ```
    /// DiffableTextField(value: $number) {
    ///     .pattern("+## (###) ###-##-##")
    ///     .placeholders("#") { $0.isASCII && $0.isNumber }
    /// }
    /// ```
    ///
    @inlinable public static func pattern(_ pattern: String) -> Self { Self(pattern) }
}

//=----------------------------------------------------------------------------=
// MARK: + Array<Character>
//=----------------------------------------------------------------------------=

extension DiffableTextStyle where Self == PatternTextStyle<[Character]> {
    
    /// Creates a `PatternTextStyle` without placeholders.
    ///
    /// ```
    /// DiffableTextField(value: $number) {
    ///     .pattern("+## (###) ###-##-##")
    ///     .placeholders("#") { $0.isASCII && $0.isNumber }
    /// }
    /// ```
    ///
    @inlinable public static func pattern(_ pattern: String) -> Self { Self(pattern) }
}
