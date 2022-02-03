//
//  Choices.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-01-31.
//

import SwiftUI

//*============================================================================*
// MARK: * Choices
//*============================================================================*

struct Choices<Options: RandomAccessCollection, Content: View>: View where Options.Element: Hashable {
    typealias Selection = Options.Element
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let options: Options
    let selection: Binding<Selection>
    let content: (Selection) -> Content
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ options: Options, selection: Binding<Selection>, content: @escaping (Selection) -> Content) {
        self.options = options
        self.selection = selection
        self.content = content
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Picker(title, selection: selection) {
            ForEach(options, id: \.self, content: content)
        }
        .pickerStyle(.segmented)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    var title: String {
        String(describing: Selection.self)
    }
}
