import SwiftUI

// $49 diag
// $99 for quick fix
// $80 beyond that
// parts extra
// 10:30 - 252 E Ave Ste B

struct DraggableVertex: View, DraggableVertexProtocol {
    enum VertexType {
        case rotationalCenter, vertex
    }

    enum VertexBehavior {
        case noVertex, staysInBounds, staysOnCircumference
    }

    @ObservedObject var tumbler: Tumbler

    let allowYAxisDrag: Bool
    let frameSize: CGSize
    let handleName: String
    let trackingColor: Color
    var shadowColor: Color
    let vertexBehavior: VertexBehavior
    let vertexIndex: Int

    @State internal var isDragging = false
    @State internal var translation = CGPoint.zero

    var anchor: CGPoint { tumbler.vertexor.theVertices[vertexIndex] }
    var trackingOffset: CGPoint { (anchor + translation) * frameSize.radius }
    var shadowOffset: CGPoint { anchor * frameSize.radius }

    var gesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let clipY = CGPoint(x: 1.0, y: allowYAxisDrag ? 1.0 : 0.0)
                self.translation = value.translation.asPoint() / frameSize.radius * clipY
                self.isDragging = true
            }
            .onEnded { value in
                // Retrieve vertices dragged beyond the unit-circle radius
                let a = self.anchor + self.translation
                let b: CGPoint

                switch vertexBehavior {
                case .noVertex:             b = CGPoint.zero
                case .staysInBounds:        b = (a.radius > 1.0) ? CGPoint(radius: 1, theta: -a.theta) : a
                case .staysOnCircumference: b = CGPoint(radius: 1, theta: -a.theta)
                }

                withAnimation {
                    tumbler.vertexor.theVertices[vertexIndex] = b
                    self.translation = .zero
                    self.isDragging = false
                }
            }
    }
    
    var body: some View {
        dragHandle.gesture(gesture)
    }
}
