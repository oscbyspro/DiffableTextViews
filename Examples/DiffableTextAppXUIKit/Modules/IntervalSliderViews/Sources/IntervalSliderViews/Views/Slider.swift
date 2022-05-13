//=----------------------------------------------------------------------------=
// This source file is part of the DiffableTextViews open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import SwiftUI

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct Slider: View {
    
   //=------------------------------------------------------------------------=
   // MARK: State
   //=------------------------------------------------------------------------=
   
   let values: Values
   
   //=------------------------------------------------------------------------=
   // MARK: Initializers
   //=------------------------------------------------------------------------=
   
   init(_ remote: Binding<(CGFloat, CGFloat)>, in limits: ClosedRange<CGFloat>) {
       self.values = Values(remote, in: limits)
   }
   
   //=------------------------------------------------------------------------=
   // MARK: Body
   //=------------------------------------------------------------------------=

   var body: some View {
       GeometryReader { outer in
           ZStack {
               //=------------------------------=
               // Beam
               //=------------------------------=
               _Beam(outer.frame(in: .local))
               //=------------------------------=
               // Body
               //=------------------------------=
               GeometryReader { inner in
                   Controls(values, in: inner.frame(in: .local))
               }
               .padding(.horizontal, 0.5 * outer.size.height)
           }
       }
       .frame(maxWidth: .infinity, minHeight: 27, maxHeight: 27)
   }
    
    //*========================================================================*
    // MARK: Declaration
    //*========================================================================*

    struct Controls: View {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        let context: Context
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        init(_ values: Values, in bounds: CGRect) {
            self.context = Context(values, Layout(values, in: bounds))
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Body
        //=--------------------------------------------------------------------=
        
        var body: some View {
            ZStack {
                Beam(context:   context)
                Handle(context: context, item: \.0)
                Handle(context: context, item: \.1)
            }
            .coordinateSpace(name: context.coordinates)
        }
    }
}

//*============================================================================*
// MARK: Declaration
//*============================================================================*

struct Slider_Previews: View, PreviewProvider {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State var interval: (CGFloat, CGFloat) = (1.0, 5.0)
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Slider($interval, in: 0...6)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Previews
    //=------------------------------------------------------------------------=
    
    static var previews: some View {
        Self().preferredColorScheme(.dark)
    }
}
