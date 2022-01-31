//
//  Storage.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-01-31.
//

import SwiftUI

//*============================================================================*
// MARK: * Storage
//*============================================================================*

final class Storage: ObservableObject {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    lazy var locales = Locale.availableIdentifiers.map(Locale.init)
}
