// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import SpriteKit
import SwiftUI

class PixoniaScene: SKScene, SKSceneDelegate, ObservableObject {
    @ObservedObject var scenario: Scenario

    var railSettingsObservers = [AnyCancellable]()
    var railSelectionObserver: AnyCancellable!

    var railSelectionChanged = false {
        didSet {
            if railSelectionChanged {
                railSettingsChanged = true
                sceneUpdateRequired = true
            }
        }
    }

    var railSettingsChanged = false {
        didSet { if railSettingsChanged { sceneUpdateRequired = true } }
    }

    var tumblerSpriteUpdateRequired = false {
        didSet { if tumblerSpriteUpdateRequired { sceneUpdateRequired = true } }
    }

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
        railSettingsObservers = scenario.rails.map { $0.$space.sink { _ in self.railSettingsChanged = true } }

        railSelectionObserver = scenario.$railSelection.sink { _ in self.railSelectionChanged  = true }
        railSelectionChanged = true
        sceneUpdateRequired = true
    }

    func updateRailSpriteForSettings() {
        guard railSettingsChanged else { return }

        switch scenario.editingRail.railType {
        case .circle:
            railSprite!.setScale(scenario.editingRail.space.radius)
        case .line:
            railSprite!.xScale = scenario.editingRail.space.radius
            railSprite!.yScale = 1.0
        }

        railSprite!.zRotation = scenario.editingRail.space.rotation

        railSettingsChanged = false
    }

    func updateRailSpriteForSelection() {
        guard railSelectionChanged else { return }

        switch scenario.editingRail.railType {
        case .circle: installCircleSprite()
        case .line: installLineSprite()
        }

        railSelectionChanged = false
    }

    func setTumblerSprite() {
        tumblerSpriteUpdateRequired = false
    }

    override func update(_ currentTime: TimeInterval) {
        guard sceneUpdateRequired else { return }

        updateRailSpriteForSelection()
        updateRailSpriteForSettings()

        sceneUpdateRequired = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PixoniaScene {
    func installCircleSprite() {
        let sprite = SpritePool.spokeRings.makeSprite()
        sprite.size = self.size
        sprite.color = SKColor(Color.pixieborder)

        railSprite?.removeFromParent()
        railSprite = sprite
        self.addChild(sprite)
    }

    func installLineSprite() {
        let sprite = SpritePool.linesPool.makeSprite()
        sprite.size = CGSize(width: self.size.width, height: 2.5)
        sprite.color = SKColor(Color.pixieborder)

        railSprite?.removeFromParent()
        railSprite = sprite
        self.addChild(sprite)
    }
}
