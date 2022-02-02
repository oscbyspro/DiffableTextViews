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
            ZStack {
                slider(values.0, in: geometry.size)
                slider(values.1, in: geometry.size)
            }
            .modifier(Beam(in: geometry, thickness: thickness))
        }
        .coordinateSpace(name: slideable)
        .padding(.horizontal, 0.5 * radius)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Subcomponents
    //=------------------------------------------------------------------------=
    
    func slider(_ value: Binding<CGFloat>, in bounds: CGSize) -> some View {
        Handle()
            .highPriorityGesture(drag(value, in: bounds.width))
            .modifier(Beam.Point())
            .position(x: position(value.wrappedValue, in: bounds.width), y: 0.5 * bounds.height)
    }
    
    func drag(_ value: Binding<CGFloat>, in bounds: CGFloat) -> some Gesture {
        DragGesture(coordinateSpace: .named(slideable)).onChanged { gesture in
            withAnimation(animation) {
                value.wrappedValue = self.value(gesture.location.x, in: bounds)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Calculations
    //=------------------------------------------------------------------------=
        
    func value(_ position: CGFloat, in bounds: CGFloat) -> CGFloat {
        let delta = limits.upperBound - limits.lowerBound
        let position = min(max(0,  position), bounds)
        return limits.lowerBound + position / bounds * delta
    }
    
    func position(_ value: CGFloat, in bounds: CGFloat) -> CGFloat {
        let above = value - limits.lowerBound
        let delta = limits.upperBound - limits.lowerBound
        return min(max(0, above / delta * bounds), bounds)
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

struct SlidersBeam: ViewModifier {
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    let geometry: GeometryProxy
    let thickness: CGFloat
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(in geometry: GeometryProxy, thickness: CGFloat) {
        self.geometry = geometry
        self.thickness = thickness
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    func body(content: Content) -> some View {
        content.backgroundPreferenceValue(Point.self) { points in
            Path { path in
                path.move(to: geometry[points.first!])
                path.addLine(to: geometry[points.last!])
            }
            .stroke(Color.accentColor, lineWidth: thickness)
        }
    }
    
    //*========================================================================*
    // MARK: * Point
    //*========================================================================*
    
    struct Point: ViewModifier, PreferenceKey {
        
        //=--------------------------------------------------------------------=
        // MARK: Body
        //=--------------------------------------------------------------------=
        
        func body(content: Content) -> some View {
            content.anchorPreference(key: Self.self, value: .center) { [$0] }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Preferences
        //=--------------------------------------------------------------------=
        
        static var defaultValue: [Anchor<CGPoint>] = []
        
        static func reduce(value: inout [Anchor<CGPoint>], nextValue: () -> [Anchor<CGPoint>]) {
            value += nextValue()
        }
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
