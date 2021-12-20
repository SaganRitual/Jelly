// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

class Scenario: ObservableObject {
    @Published var editingIndex = 3
    @Published var editingPathIndex = 1
    @Published var tumblerScale = 0.5
    @Published var tumblerZRotation = Double.tau / 4
    @Published var tumblerAnchorRadius = 0.0
    @Published var tumblerAnchorTheta = 0.0

    var editingTumbler: Tumbler { tumblers[editingIndex] }

    @Published var tumblers: [Tumbler] = [
        Tumbler(.ellipse(0)),
        Tumbler(.ellipse(1)),
        Tumbler(.ngon(0)),
        Tumbler(.ngon(3)),
        Tumbler(.ngon(4)),
        Tumbler(.ngon(5)),
        Tumbler(.ngon(6)),
        Tumbler(.ngon(8)),
        Tumbler(.ngon(10)),
        Tumbler(.ngon(12)),
        Tumbler(.ngon(20))
    ]
}
