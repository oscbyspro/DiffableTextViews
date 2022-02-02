//
//  IntervalSliders.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-02.
//

import SwiftUI

//*============================================================================*
// MARK: * IntervalSliders
//*============================================================================*

struct IntervalSliders: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    var bounds: ClosedRange<CGFloat>
    var values: Binding<(CGFloat, CGFloat)>
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ values: Binding<(CGFloat, CGFloat)>, in bounds: ClosedRange<CGFloat>) {
        self.bounds = bounds
        self.values = values
    }
    
    init<T>(_ values: Binding<(T, T)>, in bounds: ClosedRange<T>) where T: BinaryInteger {
        self.bounds = CGFloat(bounds.lowerBound)...CGFloat(bounds.upperBound)
        self.values = Binding {(
            CGFloat(values.wrappedValue.0), CGFloat(values.wrappedValue.1))
        } set: { xxxxxxxxxxxxxxx in values.wrappedValue = (
            T(xxxxxxxxxxxxxxx.0.rounded()), T(xxxxxxxxxxxxxxx.1.rounded()))
        }
    }
    
    init<T>(_ values: Binding<(T, T)>, in bounds: ClosedRange<T>) where T: BinaryFloatingPoint {
        self.bounds = CGFloat(bounds.lowerBound)...CGFloat(bounds.upperBound)
        self.values = Binding {(
            CGFloat(values.wrappedValue.0), CGFloat(values.wrappedValue.1))
        } set: { xxxxxxxxxxxxxxxxxxxxxxxxx in values.wrappedValue = (
            T(xxxxxxxxxxxxxxxxxxxxxxxxx.0), T(xxxxxxxxxxxxxxxxxxxxxxxxx.1))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Measurements
    //=------------------------------------------------------------------------=
    
    var radius:    CGFloat { 27 }
    var thickness: CGFloat {  4 }
    
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
        GeometryReader { slideable in
            ZStack {
                slider(values.0, in: slideable.size)
                slider(values.1, in: slideable.size)
            }
            .backgroundPreferenceValue(Locations.self) { locations in
                lazer(start: slideable[locations[0]], end: slideable[locations[1]])
            }
        }
        .coordinateSpace(name: Coordinates.slideable)
        .padding(.horizontal, 0.5 * radius)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Subcomponents
    //=------------------------------------------------------------------------=
    
    func slider(_ value: Binding<CGFloat>, in slideable: CGSize) -> some View {
        Circle()
            .fill(.white)
            .overlay(Circle().strokeBorder(.gray.opacity(0.2), lineWidth: 0.5))
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
            .highPriorityGesture(drag(value, in: slideable.width))
            .anchorPreference(key: Locations.self, value: .center, transform: { [$0] })
            .position(x: position(value.wrappedValue, in: slideable.width), y: 0.5 * slideable.height)
    }
    
    func drag(_ value: Binding<CGFloat>, in slideable: CGFloat) -> some Gesture {
        DragGesture(coordinateSpace: .named(Coordinates.slideable)).onChanged { gesture in
            withAnimation {
                value.wrappedValue = self.value(gesture.location.x, in: slideable)
            }
        }
    }
    
    func lazer(start: CGPoint, end: CGPoint) -> some View {
        Path {
            $0.move(to:  start)
            $0.addLine(to: end)
        }
        .stroke(Color.accentColor, lineWidth: thickness)
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Calculations
    //=------------------------------------------------------------------------=
        
    func value(_ position: CGFloat, in slideable: CGFloat) -> CGFloat {
        let delta = bounds.upperBound - bounds.lowerBound
        let position = min(max(0,  position), slideable)
        return bounds.lowerBound + position / slideable * delta
    }
    
    func position(_ value: CGFloat, in slideable: CGFloat) -> CGFloat {
        let above = value - bounds.lowerBound
        let delta = bounds.upperBound - bounds.lowerBound
        return min(max(0, above / delta * slideable), slideable)
    }
    
    //*========================================================================*
    // MARK: * Coordinates
    //*========================================================================*
    
    enum Coordinates { case slideable }
    
    //*========================================================================*
    // MARK: * HorizontalLine
    //*========================================================================*
    
    enum Locations: PreferenceKey {
        
        //=--------------------------------------------------------------------=
        // MARK: Value
        //=--------------------------------------------------------------------=
        
        static var defaultValue: [Anchor<CGPoint>] = []
        
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value += nextValue()
        }
    }
}

//*============================================================================*
// MARK: * IntervalSliders x Previews
//*============================================================================*

struct IntervalSlidersPreviews: View, PreviewProvider {
    
    //=------------------------------------------------------------------------=
    // MARK: Previews
    //=------------------------------------------------------------------------=
    
    static var previews: some View {
        Self().preferredColorScheme(.dark)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State var interval = Interval((1, 5))
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        IntervalSliders($interval.values, in: 0...6)
    }
}
