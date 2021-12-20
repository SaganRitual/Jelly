// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

protocol DraggableVertexProtocol {
    var anchor: CGPoint { get }
    var frameSize: CGSize { get }
    var handleName: String { get }
    var isDragging: Bool { get }
    var shadowColor: Color { get }
    var shadowOffset: CGPoint { get }
    var tumbler: Tumbler { get }
    var trackingColor: Color { get }
    var trackingOffset: CGPoint { get }
    var translation: CGPoint { get }
}

extension DraggableVertexProtocol {
    var dragHandle: some View {
        ZStack {
            Image(systemName: handleName)
                .font(.body)
                .foregroundColor(trackingColor)
                .zIndex(1)
                .offset(trackingOffset.asSize())

            Image(systemName: handleName)
                .font(.body)
                .foregroundColor(shadowColor)
                .offset(shadowOffset.asSize())
        }
    }
}
