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
    
    init<T>(_ interval: Binding<Interval<T>>, in bounds: Interval<T>) where T: BinaryInteger {
        self.init(interval.ui.values, in: bounds.ui.closed)
    }
    
    init<T>(_ interval: Binding<Interval<T>>, in bounds: Interval<T>) where T: BinaryFloatingPoint {
        self.init(interval.ui.values, in: bounds.ui.closed)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var delta: CGFloat {
        bounds.upperBound - bounds.lowerBound
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
        DragGesture(coordinateSpace: .named(Coordinates.slideable)).onChanged {
            value.animation(.linear(duration: 0.15)).wrappedValue = self.value($0.location.x, in: slideable)
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
        let position = min(max(0,  position), slideable)
        return bounds.lowerBound + position / slideable * delta
    }
    
    func position(_ value: CGFloat, in slideable: CGFloat) -> CGFloat {
        min(max(0, value / delta * slideable), slideable)
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
    
    @State var values = Interval((1, 5))
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        IntervalSliders($values, in: Interval((0, 6)))
    }
}
