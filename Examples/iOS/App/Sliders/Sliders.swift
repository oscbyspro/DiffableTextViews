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

struct Sliders: View, SlidersStorageable {
 
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let storage: SlidersStorage
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        ZStack {
            SlidersTrack(storage)
            GeometryReader {
                rectangle in
                SlidersInterval(storage, proxy: rectangle)
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
    
    init(_ values: Binding<(CGFloat, CGFloat)>, in limits: ClosedRange<CGFloat>) {
        self.storage = SlidersStorage(values, in: limits)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Binary - Integer
    //=------------------------------------------------------------------------=
    
    init<T>(_ values: Binding<(T, T)>, in limits: ClosedRange<T>) where T: BinaryInteger {
        self.storage = SlidersStorage(Binding {(
            CGFloat(values.wrappedValue.0), CGFloat(values.wrappedValue.1)
        )} set: { xxxxxxxxxxxxxxx in values.wrappedValue = (
            T(xxxxxxxxxxxxxxx.0.rounded()), T(xxxxxxxxxxxxxxx.1.rounded())
        )}, in: CGFloat(limits.lowerBound) ... CGFloat(limits.upperBound))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Binary - Floating Point
    //=------------------------------------------------------------------------=
    
    init<T>(_ values: Binding<(T, T)>, in limits: ClosedRange<T>) where T: BinaryFloatingPoint {
        self.storage = SlidersStorage(Binding {(
            CGFloat(values.wrappedValue.0), CGFloat(values.wrappedValue.1)
        )} set: { xxxxxxxxxxxxxxxxxxxxxxxxx in values.wrappedValue = (
            T(xxxxxxxxxxxxxxxxxxxxxxxxx.0), T(xxxxxxxxxxxxxxxxxxxxxxxxx.1)
        )}, in: CGFloat(limits.lowerBound)...CGFloat(limits.upperBound))
    }
}


//*============================================================================*
// MARK: * Sliders x Storage
//*============================================================================*

final class SlidersStorage: SlidersStorageable {
    var storage: SlidersStorage { self }

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
    
    func positions(in bounds: CGSize) -> (CGFloat, CGFloat) {
        let multiple = ratio(bounds.width, limits.upperBound - limits.lowerBound)
        //=--------------------------------------=
        // MARK: Single
        //=--------------------------------------=
        func position(_ value: CGFloat) -> CGFloat {
            min(max(0, (value - limits.lowerBound) * multiple), bounds.width)
        }
        //=--------------------------------------=
        // MARK: Double
        //=--------------------------------------=
        return (position(values.wrappedValue.0), position(values.wrappedValue.1))
    }
}

//*============================================================================*
// MARK: * Sliders x Layout
//*============================================================================*

final class SlidersLayout: SlidersLayoutable {
    var layout: SlidersLayout { self }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let frame: CGRect
    let positions: (CGFloat, CGFloat)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ storage: SlidersStorage, proxy: GeometryProxy) {
        self.frame = proxy.frame(in: .local)
        self.positions = storage.positions(in: frame.size)
    }
}

//*============================================================================*
// MARK: * Sliders x Composite
//*============================================================================*

final class SlidersComposite: SlidersStorageable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let layout:  SlidersLayout
    let storage: SlidersStorage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ storage: SlidersStorage, _ layout: SlidersLayout) {
        self.layout  = layout
        self.storage = storage
    }
}

//*============================================================================*
// MARK: * Sliders x Interval
//*============================================================================*

struct SlidersInterval: View, SlidersCompositeable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let composite: SlidersComposite
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ storage: SlidersStorage, proxy: GeometryProxy) {
        let layout = SlidersLayout(storage, proxy: proxy)
        self.composite = SlidersComposite(storage, layout)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        ZStack {
            SlidersBeam(composite)
            SlidersHandle(composite, value: values.projectedValue.0, position: positions.0)
            SlidersHandle(composite, value: values.projectedValue.1, position: positions.1)
        }
        .coordinateSpace(name: coordinates)
    }
}

//*============================================================================*
// MARK: * Sliders x Handle
//*============================================================================*

struct SlidersHandle: View, SlidersCompositeable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let position: CGFloat
    let value: Binding<CGFloat>
    let composite: SlidersComposite

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ composite: SlidersComposite, value: Binding<CGFloat>, position: CGFloat) {
        self.value = value
        self.position = position
        self.composite = composite
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        shape
            .fill(.white)
            .overlay(shape.fill(Material.thin))
            .overlay(shape.strokeBorder(.gray.opacity(0.2), lineWidth: 0.5))
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
            .highPriorityGesture(dragGesture)
            .position(x: position, y: frame.midY)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    var shape: some InsettableShape {
        Circle()
    }

    var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .named(coordinates)).onChanged {
            let newValue = storage.value($0.location.x, in: frame.size)
            //=----------------------------------=
            // MARK: Set
            //=----------------------------------=
            if value.wrappedValue != newValue {
                withAnimation(animation) { value.wrappedValue = newValue }
            }
        }
    }
}

//*============================================================================*
// MARK: * Sliders x Beam
//*============================================================================*

struct SlidersBeam: View, SlidersCompositeable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let composite: SlidersComposite
    var animatableData: AnimatablePair<CGFloat, CGFloat>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    init(_ composite: SlidersComposite) {
        self.composite = composite
        self.animatableData = AnimatablePair(composite.layout.positions.0, composite.layout.positions.1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    var storage: SlidersStorage { composite.storage }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    var body: some View {
        Path {
            $0.move(to:    CGPoint(x: animatableData.first,  y: frame.midY))
            $0.addLine(to: CGPoint(x: animatableData.second, y: frame.midY))
        }
        .stroke(Color.accentColor, lineWidth: thickness)
    }
}

//*============================================================================*
// MARK: * Sliders x Track
//*============================================================================*

struct SlidersTrack: View, SlidersStorageable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let storage: SlidersStorage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(_ storage: SlidersStorage) {
        self.storage = storage
    }
    
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
