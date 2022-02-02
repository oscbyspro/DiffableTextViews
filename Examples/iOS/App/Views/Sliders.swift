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

struct Sliders: View {
 
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let limits: ClosedRange<CGFloat>
    let values: Binding<(CGFloat, CGFloat)>
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        ZStack {
            SlidersTrack(thickness: thickness)
            GeometryReader {
                SlidersInterval(self, proxy: $0)
            }
            .padding(.horizontal, 0.5 * radius)
        }
        .frame(maxWidth: .infinity, minHeight: radius, maxHeight: radius)
    }

    //=------------------------------------------------------------------------=
    // MARK: Values
    //=------------------------------------------------------------------------=
    
    var radius:    CGFloat { 27 }
    var thickness: CGFloat { 04 }
    var coordinates: UInt8 { 33 }
    
    var animation: Animation {
        .linear(duration: 0.125)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Calculations
    //=------------------------------------------------------------------------=
    
    func ratio(_ dividend: CGFloat, _ divisor: CGFloat) -> CGFloat {
        divisor == 0 ? 0 : dividend / divisor
    }
    
    func value(_ position: CGFloat, in bounds: CGSize) -> CGFloat {
        let position = min(max(0,  position), bounds.width)
        let multiple = ratio(limits.upperBound - limits.lowerBound, bounds.width)
        return limits.lowerBound + position * multiple
    }
    
    func positions(in bounds: CGSize) -> (CGPoint, CGPoint) {
        let y = 0.5 * bounds.height
        let multiple = ratio(bounds.width, limits.upperBound - limits.lowerBound)
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        func position(_ value: CGFloat) -> CGPoint {
            let extra = value - limits.lowerBound
            return CGPoint(x: min(max(0, extra * multiple), bounds.width), y: y)
        }
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        return (position(values.wrappedValue.0), position(values.wrappedValue.1))
    }
}

//=----------------------------------------------------------------------------=
// MARK: Sliders - Initializers
//=----------------------------------------------------------------------------=

extension Sliders {
    
    //=------------------------------------------------------------------------=
    // MARK: CGFloat
    //=------------------------------------------------------------------------=
    
    init(_ values: Binding<(CGFloat, CGFloat)>, in limits: ClosedRange<CGFloat>) {
        self.limits = limits
        self.values = values
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Binary - Integer
    //=------------------------------------------------------------------------=
    
    init<T>(_ values: Binding<(T, T)>, in limits: ClosedRange<T>) where T: BinaryInteger {
        self.limits = CGFloat(limits.lowerBound)...CGFloat(limits.upperBound)
        self.values = Binding {(
            CGFloat(values.wrappedValue.0), CGFloat(values.wrappedValue.1)
        )} set: { xxxxxxxxxxxxxxx in values.wrappedValue = (
            T(xxxxxxxxxxxxxxx.0.rounded()), T(xxxxxxxxxxxxxxx.1.rounded())
        )}
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Binary - Floating Point
    //=------------------------------------------------------------------------=
    
    init<T>(_ values: Binding<(T, T)>, in limits: ClosedRange<T>) where T: BinaryFloatingPoint {
        self.limits = CGFloat(limits.lowerBound)...CGFloat(limits.upperBound)
        self.values = Binding {(
            CGFloat(values.wrappedValue.0), CGFloat(values.wrappedValue.1)
        )} set: { xxxxxxxxxxxxxxxxxxxxxxxxx in values.wrappedValue = (
            T(xxxxxxxxxxxxxxxxxxxxxxxxx.0), T(xxxxxxxxxxxxxxxxxxxxxxxxx.1)
        )}
    }
}

//*============================================================================*
// MARK: * Sliders x Interval
//*============================================================================*

struct SlidersInterval: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let base: Sliders
    let bounds: CGSize
    let positions: (CGPoint, CGPoint)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ base: Sliders, proxy: GeometryProxy) {
        self.base = base
        self.bounds = proxy.size
        self.positions = base.positions(in: bounds)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        ZStack {
            beam
            handle(base.values.0, at: positions.0)
            handle(base.values.1, at: positions.1)
        }
        .coordinateSpace(name: base.coordinates)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    var beam: some View {
        SlidersBeam(positions, thickness: base.thickness)
    }
    
    func handle(_ value: Binding<CGFloat>, at position: CGPoint) -> some View {
        SlidersHandle().highPriorityGesture(drag(value)).position(position)
    }
    
    func drag(_ value: Binding<CGFloat>) -> some Gesture {
        DragGesture(coordinateSpace: .named(base.coordinates)).onChanged {
            let newValue = base.value($0.location.x, in: bounds)
            //=----------------------------------=
            // MARK: Set
            //=----------------------------------=
            if value.wrappedValue != newValue {
                withAnimation(base.animation) { value.wrappedValue = newValue }
            }
        }
    }
}

//*============================================================================*
// MARK: * Sliders x Handle
//*============================================================================*

struct SlidersHandle: View {
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        shape
            .fill(.white)
            .overlay(shape.fill(Material.thin))
            .overlay(shape.strokeBorder(.gray.opacity(0.2), lineWidth: 0.5))
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    var shape: some InsettableShape {
        Circle()
    }
}

//*============================================================================*
// MARK: * Sliders x Beam
//*============================================================================*

struct SlidersBeam: View, Animatable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let thickness: CGFloat
    var positions: (CGPoint, CGPoint)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    init(_ positions: (CGPoint, CGPoint), thickness: CGFloat) {
        self.thickness = thickness
        self.positions = positions
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Path {
            $0.move(to:    positions.0)
            $0.addLine(to: positions.1)
        }
        .stroke(Color.accentColor, lineWidth: thickness)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Animatable
    //=------------------------------------------------------------------------=
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            AnimatablePair(
            positions.0.x,
            positions.1.x)
        } set {
            positions.0.x = newValue.first
            positions.1.x = newValue.second
        }
    }
}

//*============================================================================*
// MARK: * Sliders x Track
//*============================================================================*

struct SlidersTrack: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let thickness: CGFloat
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Capsule().fill(.gray.opacity(0.2)).frame(height: thickness)
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
