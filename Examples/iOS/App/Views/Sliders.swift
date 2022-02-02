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
    typealias Beam = SlidersBeam
    typealias Handle = SlidersHandle
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    var limits: ClosedRange<CGFloat>
    var values: Binding<(CGFloat, CGFloat)>
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ values: Binding<(CGFloat, CGFloat)>, in limits: ClosedRange<CGFloat>) {
        self.limits = limits
        self.values = values
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var radius:    CGFloat { 27 }
    var thickness: CGFloat { 04 }
    var slideable: UInt8   { 00 }

    //=------------------------------------------------------------------------=
    // MARK: Accessors - Other
    //=------------------------------------------------------------------------=
    
    var animation: Animation {
        .linear(duration: 0.125)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        rail.overlay(content)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    var rail: some View {
        Capsule()
            .fill(.gray.opacity(0.2))
            .frame(maxWidth: .infinity, maxHeight: thickness)
            .frame(height: radius)
    }
    
    var content: some View {
        GeometryReader { geometry in
            let first  = position(values.wrappedValue.0, in: geometry.size)
            let second = position(values.wrappedValue.1, in: geometry.size)

            ZStack {
                Beam(start: first, end: second, thickness: thickness)
                slider(values.0, at: first,  in: geometry.size)
                slider(values.1, at: second, in: geometry.size)
            }
        }
        .coordinateSpace(name: slideable)
        .padding(.horizontal, 0.5 * radius)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Subcomponents
    //=------------------------------------------------------------------------=
    
    func slider(_ value: Binding<CGFloat>, at position: CGPoint, in bounds: CGSize) -> some View {
        Handle().highPriorityGesture(drag(value, in: bounds)).position(position)
    }
    
    func drag(_ value: Binding<CGFloat>, in bounds: CGSize) -> some Gesture {
        DragGesture(coordinateSpace: .named(slideable)).onChanged { gesture in
            withAnimation(animation) {
                value.wrappedValue = self.value(gesture.location.x, in: bounds)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Calculations
    //=------------------------------------------------------------------------=
        
    func value(_ position: CGFloat, in bounds: CGSize) -> CGFloat {
        let delta = limits.upperBound - limits.lowerBound
        let position = min(max(0,  position), bounds.width)
        return limits.lowerBound + position / bounds.width * delta
    }
    
    func position(_ value: CGFloat, in bounds: CGSize) -> CGPoint {
        let above = value - limits.lowerBound
        let delta = limits.upperBound - limits.lowerBound
        let x = min(max(0, above / delta * bounds.width), bounds.width)
        return CGPoint(x: x, y: 0.5 * bounds.height)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Sliders - Initializers
//=----------------------------------------------------------------------------=

extension Sliders {
    
    //=------------------------------------------------------------------------=
    // MARK: BinaryInteger
    //=------------------------------------------------------------------------=
    
    init<T>(_ values: Binding<(T, T)>, in limits: ClosedRange<T>) where T: BinaryInteger {
        self.limits = CGFloat(limits.lowerBound)...CGFloat(limits.upperBound)
        self.values = Binding {(
            CGFloat(values.wrappedValue.0), CGFloat(values.wrappedValue.1))
        } set: { xxxxxxxxxxxxxxx in values.wrappedValue = (
            T(xxxxxxxxxxxxxxx.0.rounded()), T(xxxxxxxxxxxxxxx.1.rounded()))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: BinaryFloatingPoint
    //=------------------------------------------------------------------------=
    
    init<T>(_ values: Binding<(T, T)>, in limits: ClosedRange<T>) where T: BinaryFloatingPoint {
        self.limits = CGFloat(limits.lowerBound)...CGFloat(limits.upperBound)
        self.values = Binding {(
            CGFloat(values.wrappedValue.0), CGFloat(values.wrappedValue.1))
        } set: { xxxxxxxxxxxxxxxxxxxxxxxxx in values.wrappedValue = (
            T(xxxxxxxxxxxxxxxxxxxxxxxxx.0), T(xxxxxxxxxxxxxxxxxxxxxxxxx.1))
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
    typealias Vector = AnimatablePair<CGFloat, CGFloat>
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    var start: CGPoint
    var end: CGPoint
    let thickness: CGFloat
    
    //=------------------------------------------------------------------------=
    // MARK: Animatable
    //=------------------------------------------------------------------------=
    
    var animatableData: AnimatablePair<Vector, Vector> {
        get { AnimatablePair(Vector(start.x, start.y), Vector(end.x, end.y)) }
        set {
            start = CGPoint(x: newValue.first.first, y: newValue.first.second)
            end = CGPoint(x: newValue.second.first, y: newValue.second.second)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(start: CGPoint, end: CGPoint, thickness: CGFloat) {
        self.start = start
        self.end = end
        self.thickness = thickness
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Path {
            $0.move(to:  start)
            $0.addLine(to: end)
        }
        .stroke(Color.accentColor, lineWidth: thickness)
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
