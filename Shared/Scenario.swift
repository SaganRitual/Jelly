// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

class Scenario: ObservableObject {
    @Published var railSelection = "minus"
    @Published var shapeSelection = "minus"

    @Published var rails: [Rail] = [
        Rail(.line), Rail(.circle)
    ]

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

    var editingRail: Rail {
        rails[RailChooser.indexOf(railSelection)]
    }

    var editingTumbler: Tumbler {
        tumblers[ShapeChooser.indexOf(shapeSelection)]
    }

    init() {
        tumblers.forEach {
            $0.space.radius = 0.125
            $0.space.rotation = .pi / 2.0
        }
    }
}
