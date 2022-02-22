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
// MARK: * DiffableTextField x Environment
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
// MARK: * DiffableTextField x Environment x Values
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
// MARK: * DiffableTextField x Environment x View
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
