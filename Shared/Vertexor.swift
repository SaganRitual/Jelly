// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

class Vertexor: ObservableObject {
    enum PointType { case position, shapeVertex }

    @Published var theVertices: [CGPoint]

    let shapeClass: ShapeChooser.ShapeClass

    var count: Int { theVertices.count }

    init(shapeClass: ShapeChooser.ShapeClass) {
        self.shapeClass = shapeClass

        switch shapeClass {
        case .ellipse(0):            theVertices = []; break
        case .ellipse(1):            theVertices = Self.makeEllipseVertex()
        case .ngon(0):               theVertices = []; break
        case let .ngon(vertices: c): theVertices = Self.makeNgonVertices(c)
        default:                     fatalError()
        }
    }

    static func makeEllipseVertex() -> [CGPoint] {
        [CGPoint(radius: 1.0, theta: 0)]
    }

    static func makeNgonVertices(_ cVertices: Int) -> [CGPoint] {
        (0..<cVertices).map {
            let theta = Double($0) * .tau / Double(cVertices)
            return CGPoint(radius: 1.0, theta: theta)
        }
    }
}
