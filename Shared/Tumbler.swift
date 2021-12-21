// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SwiftUI

class Tumbler: HasUnitCircleSpace {
    let id = UUID().uuidString.substr(0..<4)

    @Published var space = UCSpace.unit

    @Published var vertexor: Vertexor

    var rotationObserver: AnyCancellable!

    init(_ shapeClass: ShapeChooser.ShapeClass) {
        vertexor = Vertexor(shapeClass: shapeClass)
    }

    func postInit() {
        rotationObserver = $space
            // Ignore notifications that we changed the position...in a
            // function called setPosition(). We know already.
            .removeDuplicates(by: { $0.rotation == $1.rotation })
            .sink(receiveValue: { [weak self] _ in self!.setPosition() })
    }

    func setPosition() {
        let arcLength = space.radius * (space.rotation - .pi / 2.0)
        space.position.r = arcLength
    }
}
