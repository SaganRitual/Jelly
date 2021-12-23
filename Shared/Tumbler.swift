// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SwiftUI

class Tumbler: HasUnitCircleSpace {
    let id = UUID().uuidString.substr(0..<4)

    @Published var space = UCSpace.unit

    @Published var vertexor: Vertexor

    var rotationObserver: AnyCancellable!
    var previousRotation: Double?
    var runningDelta = 0.0

    init(_ shapeClass: ShapeChooser.ShapeClass) {
        vertexor = Vertexor(shapeClass: shapeClass)
    }

    func postInit() {
        rotationObserver = $space
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in self!.setPosition($0.rotation) })
    }

    func setPosition(_ newRotation: Double) {
        defer { previousRotation = newRotation }
        guard let previousRotation = previousRotation else { return }

        let delta = newRotation - previousRotation
        runningDelta += delta
        if delta == 0 { return }

        let arcLength = space.radius * delta
        space.position.r += arcLength
    }
}
