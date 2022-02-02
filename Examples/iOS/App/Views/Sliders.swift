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
    
    let data: SlidersData
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ values: Binding<(CGFloat, CGFloat)>, in limits: ClosedRange<CGFloat>) {
        self.data = SlidersData(values, in: limits)
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
            .frame(maxWidth: .infinity, maxHeight: data.thickness)
            .frame(height: data.radius)
    }
    
    var content: some View {
        GeometryReader {
            SlidersContent(in: $0, with: data)
        }
        .padding(.horizontal, 0.5 * data.radius)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Sliders - Initializers
//=----------------------------------------------------------------------------=

extension Sliders {
    
    //=------------------------------------------------------------------------=
    // MARK: Numbers
    //=------------------------------------------------------------------------=
    
    init<T: BinaryInteger>(_ values: Binding<(T, T)>, in limits: ClosedRange<T>) {
        self.init(Binding {(
            CGFloat(values.wrappedValue.0), CGFloat(values.wrappedValue.1))
        } set: { xxxxxxxxxxxxxxx in values.wrappedValue = (
            T(xxxxxxxxxxxxxxx.0.rounded()), T(xxxxxxxxxxxxxxx.1.rounded()))
        }, in: CGFloat(limits.lowerBound)...CGFloat(limits.upperBound))
    }
    
    init<T: BinaryFloatingPoint>(_ values: Binding<(T, T)>, in limits: ClosedRange<T>) {
        self.init(Binding {(
            CGFloat(values.wrappedValue.0), CGFloat(values.wrappedValue.1))
        } set: { xxxxxxxxxxxxxxxxxxxxxxxxx in values.wrappedValue = (
            T(xxxxxxxxxxxxxxxxxxxxxxxxx.0), T(xxxxxxxxxxxxxxxxxxxxxxxxx.1))
        }, in: CGFloat(limits.lowerBound)...CGFloat(limits.upperBound))
    }
}

//*============================================================================*
// MARK: * Sliders x Data
//*============================================================================*

final class SlidersData: ObservableObject {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let limits: ClosedRange<CGFloat>
    let values: Binding<(CGFloat, CGFloat)>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ values: Binding<(CGFloat, CGFloat)>, in limits: ClosedRange<CGFloat>) {
        self.limits = limits
        self.values = values
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Components
    //=------------------------------------------------------------------------=
    
    var radius: CGFloat {
        27
    }
    
    var thickness: CGFloat {
        4
    }
    
    var coordinates: UInt8 {
        33
    }
    
    var animation: Animation {
        .linear(duration: 0.125)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Calculations
    //=------------------------------------------------------------------------=
    
    func value(_ position: CGFloat, in bounds: CGSize) -> CGFloat {
        let delta = limits.upperBound - limits.lowerBound
        let position = min(max(0,  position), bounds.width)
        return limits.lowerBound + position / bounds.width * delta
    }
    
    func positions(in bounds: CGSize) -> (CGPoint, CGPoint) {
        let y = 0.5 * bounds.height
        let multiple = bounds.width / (limits.upperBound - limits.lowerBound)
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

//*============================================================================*
// MARK: * Sliders x Content
//*============================================================================*

struct SlidersContent: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let data: SlidersData
    let bounds: CGSize
    let positions: (CGPoint, CGPoint)

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(in proxy: GeometryProxy, with data: SlidersData) {
        self.data = data
        self.bounds = proxy.size
        self.positions = data.positions(in: bounds)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        ZStack {
            SlidersBeam(positions, with: data)
            slider(data.values.0, at: positions.0)
            slider(data.values.1, at: positions.1)
        }
        .coordinateSpace(name: data.coordinates)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Subcomponents
    //=------------------------------------------------------------------------=
    
    func slider(_ value: Binding<CGFloat>, at position: CGPoint) -> some View {
        SlidersHandle().highPriorityGesture(drag(value)).position(position)
    }
    
    func drag(_ value: Binding<CGFloat>) -> some Gesture {
        DragGesture(coordinateSpace: .named(data.coordinates)).onChanged {
            gesture in withAnimation(data.animation) {
                value.wrappedValue = data.value(gesture.location.x, in: bounds)
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
    typealias Data = SlidersData
    
    //=------------------------------------------------------------------------=
    // MARK: Properties
    //=------------------------------------------------------------------------=
    
    let data: SlidersData
    var positions: (CGPoint, CGPoint)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ positions: (CGPoint, CGPoint), with data: Data) {
        self.data = data
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
        .stroke(Color.accentColor, lineWidth: data.thickness)
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
