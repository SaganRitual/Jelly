// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var scenario: Scenario

    init(scenario: Scenario) {
        _scenario = ObservedObject(wrappedValue: scenario)

        super.init(size: CGSize(width: 1024, height: 1024))
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .aspectFit
        self.backgroundColor = .systemBackground
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
