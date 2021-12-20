// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerEditorView: View {
    @ObservedObject var tumbler: Tumbler
    @ObservedObject var vertexor: Vertexor

    var allowYAxisDrag: Bool {
        switch vertexor.shapeClass {
        case ShapeChooser.ShapeClass.ellipse(0): return false
        case ShapeChooser.ShapeClass.ngon(0):    return false
        default: return true
        }
    }
    
    func getStrokeViewOrigin(_ gp: GeometryProxy) -> CGPoint {
        guard case .ellipse = vertexor.shapeClass else { return .zero }

        let localFrame = gp.frame(in: .local)
        let origin = localFrame.origin
        let r = vertexor.theVertices.isEmpty ? 1.0 : vertexor.theVertices[0].radius
        let translateX = (1 - r) * localFrame.size.width / 2
        return CGPoint(x: origin.x + translateX, y: origin.y)
    }

    func getStrokeViewRect(_ gp: GeometryProxy) -> CGSize {
        guard case .ellipse = vertexor.shapeClass else { return gp.frame(in: .local).size }

        let r = vertexor.theVertices.isEmpty ? 1.0 : vertexor.theVertices[0].radius
        return gp.frame(in: .local).size * CGSize(width: r, height: 1)
    }

    func getVertexBehavior(
        for shapeClass: ShapeChooser.ShapeClass
    ) -> DraggableVertex.VertexBehavior {
        switch shapeClass {
        case .ellipse(0): return .noVertex
        case .ellipse(1): return .staysOnCircumference
        case .ngon(0):    return .noVertex
        case .ngon:       return .staysInBounds
        default:          fatalError()
        }
    }

    var body: some View {
        GeometryReader { gr in
            ZStack {
                Circle()
                    .strokeBorder(Color.pixieborder, lineWidth: 2)
                    .background(Circle().fill(Color.pixiefill))

                TumblerStrokeView(
                    tumbler: tumbler, vertexor: vertexor,
                    rect: CGRect(
                        origin: getStrokeViewOrigin(gr),
                        size: getStrokeViewRect(gr)
                    )
                )

                ForEach(0..<tumbler.vertexor.count, id: \.self) { vertexIndex in
                    DraggableVertex(
                        tumbler: tumbler,
                        allowYAxisDrag: allowYAxisDrag,
                        frameSize: gr.size,
                        handleName: "circle.fill", trackingColor: Color.blue,
                        shadowColor: Color.green,
                        vertexBehavior: getVertexBehavior(for: tumbler.vertexor.shapeClass),
                        vertexIndex: vertexIndex
                    )
                }
            }
        }
    }
}
