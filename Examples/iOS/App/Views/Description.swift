//
//  Description.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-01-31.
//

import SwiftUI

//*============================================================================*
// MARK: * Description
//*============================================================================*

struct Description<Value>: View {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    let value: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ value: Value) { self.value = value }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Text(description)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(border)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    var description: String {
        let text = String(describing: value); return !text.isEmpty ? text : " "
    }
    
    var border: some View {
        Rectangle().strokeBorder(Color(uiColor: .tertiarySystemBackground), lineWidth: 2)
    }
}

//*============================================================================*
// MARK: * Description x Previews
//*============================================================================*

struct DescriptionPreviews: PreviewProvider {
    static var previews: some View {
        Description(123)
            .preferredColorScheme(.dark)
    }
}
