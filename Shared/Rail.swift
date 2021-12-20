// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

class Rail: HasUnitCircleSpace {
    enum RailType { case line, circle }
    let railType: RailType

    init(_ railType: RailType) {
        self.railType = railType
    }

    @Published var space = UCSpace.unit
}
