//
//  Sliders.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-02.
//

import SwiftUI

//*============================================================================*
// MARK: * Sliders
//*============================================================================*

public struct Sliders: View, Storageable {
 
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let storage: Storage

    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable public var body: some View {
        ZStack {
            Track(storage)
            GeometryReader {
                rectangle in
                Interval(storage, proxy: rectangle)
            }
            .padding(.horizontal, 0.5 * radius)
        }
        .frame(maxWidth: .infinity, minHeight: radius, maxHeight: radius)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Sliders - Initializers
//=----------------------------------------------------------------------------=

extension Sliders {
    
    //=------------------------------------------------------------------------=
    // MARK: CGFloat
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ values: Binding<(CGFloat, CGFloat)>, in limits: ClosedRange<CGFloat>) {
        self.storage = Storage(values, in: limits)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Binary - Integer
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(_ values: Binding<(T, T)>, in limits: ClosedRange<T>) where T: BinaryInteger {
        self.storage = Storage(Binding {(
            CGFloat(values.wrappedValue.0),
            CGFloat(values.wrappedValue.1)
        )} set: { xxxxxxxxxxxxxxx in values.wrappedValue = (
            T(xxxxxxxxxxxxxxx.0.rounded()),
            T(xxxxxxxxxxxxxxx.1.rounded())
        )}, in: CGFloat(limits.lowerBound) ... CGFloat(limits.upperBound))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Binary - Floating Point
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(_ values: Binding<(T, T)>, in limits: ClosedRange<T>) where T: BinaryFloatingPoint {
        self.storage = Storage(Binding {(
            CGFloat(values.wrappedValue.0),
            CGFloat(values.wrappedValue.1)
        )} set: { xxxxxxxxxxxxxxxxxxxxxxxxx in values.wrappedValue = (
            T(xxxxxxxxxxxxxxxxxxxxxxxxx.0),
            T(xxxxxxxxxxxxxxxxxxxxxxxxx.1)
        )}, in: CGFloat(limits.lowerBound)...CGFloat(limits.upperBound))
    }
}

//*============================================================================*
// MARK: * Sliders x Previews
//*============================================================================*

struct SlidersPreviews: View, PreviewProvider {

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State var interval = (1, 5)
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Sliders($interval, in: 0...6)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Previews
    //=------------------------------------------------------------------------=
    
    static var previews: some View {
        Self().preferredColorScheme(.dark)
    }
}
