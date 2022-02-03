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

@usableFromInline struct Handle: View {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let position: CGFloat
    @usableFromInline let value: Binding<CGFloat>
    @usableFromInline let composite: Composite

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ composite: Composite, value: Binding<CGFloat>, position: CGFloat) {
        self.value = value
        self.position = position
        self.composite = composite
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var animation: Animation {
        Constants.animation
    }
    
    @inlinable var coordinates: UInt8 {
        Constants.coordinates
    }
    
    @inlinable var center: CGFloat {
        composite.layout.center
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
            .highPriorityGesture(dragGesture)
            .position(x: position, y: center)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Body - Components
    //=------------------------------------------------------------------------=
    
    @inlinable var shape: some InsettableShape {
        Circle()
    }

    @inlinable var dragGesture: some Gesture {
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
