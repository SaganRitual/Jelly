// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var scenario: Scenario

    var railObservers = [AnyCancellable]()
    var tumblerObservers = [AnyCancellable]()

    var sceneUpdateRequired = false

    var railSprite: SKSpriteNode?
    var tumblerSprite: SKSpriteNode?

    init(scenario: Scenario) {
        _scenario = ObservedObject(wrappedValue: scenario)

        super.init(size: CGSize(width: 1024, height: 1024))
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scaleMode = .aspectFit
        self.backgroundColor = .clear
    }

    override func didMove(to view: SKView) {
        railObservers = scenario.rails.map { $0.$space.sink { _ in self.sceneUpdateRequired = true } }
        tumblerObservers = scenario.tumblers.map { $0.$space.sink { _ in self.sceneUpdateRequired = true } }

        setRailSprite()
        setTumblerSprite()
        sceneUpdateRequired = true
    }

    func setRailSprite() {
        if let rs = railSprite, let name = rs.name, name == scenario.railSelection {
            return
        }

        sceneUpdateRequired = true
    }

    func setTumblerSprite() {
        if let ts = railSprite, let name = ts.name, name == scenario.shapeSelection {
            return
        }

        sceneUpdateRequired = true
    }

    override func update(_ currentTime: TimeInterval) {
        guard sceneUpdateRequired else { return }

        sceneUpdateRequired = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
