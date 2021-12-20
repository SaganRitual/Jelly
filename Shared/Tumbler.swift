// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

class Tumbler: HasUnitCircleSpace {
    @Published var space = UCSpace.unit

    @Published var vertexor: Vertexor

    init(_ shapeClass: ShapeChooser.ShapeClass) {
        vertexor = Vertexor(shapeClass: shapeClass)
    }
}
