//
//  Handle.swift
//  iOS
//
//  Created by Oscar Byström Ericsson on 2022-02-03.
//

import SwiftUI

//*============================================================================*
// MARK: * Handle
//*============================================================================*

@usableFromInline struct Handle: View, Algorithmsable, Constantsable, Layoutable, Storageable {
    
    //=------------------------------------------------------------------------=
    // MARK: Environment
    //=------------------------------------------------------------------------=
    
    @usableFromInline @EnvironmentObject var layout: Layout
    @usableFromInline @EnvironmentObject var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let position: CGFloat
    @usableFromInline let value: Binding<CGFloat>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ value: Binding<CGFloat>, at position: CGFloat) {
        self.value = value
        self.position = position
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body
    //=------------------------------------------------------------------------=
    
    @inlinable var body: some View {
        shape
            .fill(.white)
            .overlay(shape.fill(Material.thin))
            .overlay(shape.strokeBorder(.gray.opacity(0.2), lineWidth: 0.5))
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 2)
            .highPriorityGesture(drag)
            .position(x: position, y: frame.midY)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    @inlinable var shape: some InsettableShape {
        Circle()
    }

    @inlinable var drag: some Gesture {
        DragGesture(coordinateSpace: .named(coordinates)).onChanged { gesture in
            withAnimation(animation) {
                value.wrappedValue = Self.convert(gesture.location.x, from: positionsLimits, to: valuesLimits)
            }
        }
    }
}
