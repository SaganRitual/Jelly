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
                tumblerSelectionChanged = true
                railSettingsChanged = true
                sceneUpdateRequired = true
            }
        }
    }

    var railSettingsChanged = false {
        didSet {
            if railSettingsChanged {
                tumblerSettingsChanged = true
                sceneUpdateRequired = true
            }
        }
    }

    var tumblerSettingsObservers = [AnyCancellable]()
    var tumblerSelectionObserver: AnyCancellable!

    var tumblerSelectionChanged = false {
        didSet {
            if tumblerSelectionChanged {
                tumblerSettingsChanged = true
                sceneUpdateRequired = true
            }
        }
    }

    var tumblerSettingsChanged = false {
        didSet { if tumblerSettingsChanged { sceneUpdateRequired = true } }
    }

    var sceneUpdateRequired = false

    var railSprite: SKSpriteNode!
    var tumblerSprite: SKSpriteNode!

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

        tumblerSettingsObservers = scenario.tumblers.map { $0.$space.sink { _ in self.tumblerSettingsChanged = true } }
        tumblerSelectionObserver = scenario.$shapeSelection.sink { _ in self.tumblerSelectionChanged  = true }

        railSelectionChanged = true
        railSettingsChanged = true

        tumblerSelectionChanged = true
        tumblerSettingsChanged = true

        sceneUpdateRequired = true
    }

    func updateRailSpriteForSelection() {
        guard railSelectionChanged else { return }

        switch scenario.editingRail.railType {
        case .circle: installCircleSprite()
        case .line: installLineRailSprite()
        }

        railSelectionChanged = false
    }

    func updateRailSpriteForSettings() {
        guard railSettingsChanged else { return }

        switch scenario.editingRail.railType {
        case .circle:
            railSprite.setScale(scenario.editingRail.space.radius)
        case .line:
            railSprite.scale(to: CGSize(width: self.size.width, height: 2.5))
            railSprite.setScale(scenario.editingRail.space.radius)
        }

        railSprite.zRotation = scenario.editingRail.space.rotation

        railSettingsChanged = false
    }

    func updateTumblerSpriteForSelection() {
        guard tumblerSelectionChanged else { return }

        switch scenario.editingTumbler.vertexor.shapeClass {
        case .ngon(0): installLineTumblerSprite()
        default: assert(false)
        }

        tumblerSelectionChanged = false
    }

    func updateTumblerSpriteForSettings() {
        guard tumblerSettingsChanged else { return }

        switch scenario.editingTumbler.vertexor.shapeClass {
        case .ngon(0):
            tumblerSprite.scale(to: CGSize(width: self.size.width, height: 2.5))
            tumblerSprite.xScale = scenario.editingTumbler.space.radius
        default:
            assert(false)
        }

        tumblerSprite.zRotation = -scenario.editingTumbler.space.rotation
        tumblerSprite.anchorPoint.x = getAnchorX(angle: scenario.editingTumbler.space.rotation)

//        let scaled = railSprite.size.width * getPositionX(angle: scenario.editingTumbler.space.rotation)
//        tumblerSprite.position.x = scaled

        tumblerSettingsChanged = false
    }

    override func update(_ currentTime: TimeInterval) {
        updateRailSpriteForSelection()
        updateRailSpriteForSettings()

        updateTumblerSpriteForSelection()
        updateTumblerSpriteForSettings()

        sceneUpdateRequired = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Double {
    static let halfPi = Double.pi / 2
    static let twoPi = Double.pi * 2.0
}

private extension PixoniaScene {
    func getAnchorX(angle: Double) -> Double {
        let shifted = angle - .halfPi
        let truncated = shifted.remainder(dividingBy: .twoPi)
        let result = ((-.halfPi)..<(.halfPi)).contains(truncated) ? 1.0 : 0.0
        return result
    }

    func getPositionX(angle: Double) -> Double {
        let cWholeStepsPossible = (1.0 / scenario.editingTumbler.space.radius).rounded(.towardZero)
        let partialStepFraction = abs(1.0 / scenario.editingTumbler.space.radius) - abs(cWholeStepsPossible)
        let partialStepRotation = partialStepFraction * .pi

        let shifted_ = scenario.editingTumbler.space.rotation - .halfPi
        let shifted = shifted_ < 0 ? shifted_ - .halfPi : shifted_ + .halfPi
        let cWholeStepsTaken = (shifted / .pi).rounded(.towardZero)

        if abs(cWholeStepsTaken) < cWholeStepsPossible {
            return cWholeStepsTaken * scenario.editingTumbler.space.radius
        }

        return 0
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

    func installLineTumblerSprite() {
        let sprite = makeLineSprite()
        sprite.color = SKColor(Color.shizzabrick)
        tumblerSprite?.removeFromParent()
        tumblerSprite = sprite
        tumblerSprite.size = CGSize(width: self.size.width, height: 2.5)
        railSprite.addChild(sprite)
    }

    func installLineRailSprite() {
        let sprite = makeLineSprite()
        railSprite?.removeFromParent()
        railSprite = sprite
        railSprite.size = CGSize(width: self.size.width, height: 2.5)
        self.addChild(sprite)
    }

    func makeLineSprite() -> SKSpriteNode {
        let sprite = SpritePool.linesPool.makeSprite()
        sprite.color = SKColor(Color.pixieborder)
        return sprite
    }
}
