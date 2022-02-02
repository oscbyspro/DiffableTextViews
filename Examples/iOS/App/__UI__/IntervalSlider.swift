//
//  IntervalSlider.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-02.
//

import SwiftUI

//*============================================================================*
// MARK: * IntervalSlider
//*============================================================================*

struct IntervalSlider: View {
    
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
    
    init(_ interval: Binding<Interval<CGFloat>>, in bounds: ClosedRange<CGFloat>) {
        self.init(interval.values, in: bounds)
    }
    
    init<T>(_ interval: Binding<Interval<T>>, in bounds: Interval<T>) where T: BinaryInteger {
        self.init(interval.ui, in: bounds.ui.closed)
    }
    
    init<T>(_ interval: Binding<Interval<T>>, in bounds: Interval<T>) where T: BinaryFloatingPoint {
        self.init(interval.ui, in: bounds.ui.closed)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Measurements
    //=------------------------------------------------------------------------=
    
    var radius: CGFloat { 27 }
    var thickness: CGFloat { 4 }

    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        line.frame(maxWidth: .infinity, maxHeight: radius).overlay(overlay)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    var line: some View {
        Capsule().fill(.gray.opacity(0.2)).frame(maxWidth: .infinity, maxHeight: thickness)
    }
    
    var overlay: some View {
        GeometryReader { slideable in
            circle(values.0, in: slideable.size)
            circle(values.1, in: slideable.size)
        }
        .coordinateSpace(name: "slideable")
        .padding(.horizontal, 0.5 * radius)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Subcomponents
    //=------------------------------------------------------------------------=
    
    func circle(_ value: Binding<CGFloat>, in slideable: CGSize) -> some View {
        Circle().fill(.white)
            .overlay(Circle().strokeBorder(.gray.opacity(0.2), lineWidth: 0.5))
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
            .highPriorityGesture(drag(value.animation(.linear(duration: 0.15)), in: slideable))
            .position(x: position(value.wrappedValue, in: slideable.width), y: slideable.height/2)
    }
    
    func drag(_ value: Binding<CGFloat>, in slideable: CGSize) -> some Gesture {
        DragGesture(coordinateSpace: .named("slideable")).onChanged { gesture in
            value.wrappedValue = self.value(gesture.location.x, in: slideable)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Calculations
    //=------------------------------------------------------------------------=
    
    func position(_ value: CGFloat, in length: CGFloat) -> CGFloat {
        min(max(0, value / (bounds.upperBound - bounds.lowerBound) * length), length)
    }
    
    func value(_ position: CGFloat, in slideable: CGSize) -> CGFloat {
        let position = min(max(0,  position), slideable.width)
        let proposal = bounds.lowerBound + position / slideable.width * (bounds.upperBound - bounds.lowerBound)
        return proposal.rounded()
    }
}

//*============================================================================*
// MARK: * IntervalSlider x Previews
//*============================================================================*

struct IntervalSliderPreviews: View, PreviewProvider {
    
    //=------------------------------------------------------------------------=
    // MARK: Previews
    //=------------------------------------------------------------------------=
    
    static var previews: some View {
        Self().preferredColorScheme(.dark)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @State var values = Interval((0, 3))
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        IntervalSlider($values, in: Interval((0, 6)))
    }
}
