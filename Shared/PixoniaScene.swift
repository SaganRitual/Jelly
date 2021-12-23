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

    var v1: SKSpriteNode!
    var v2: SKSpriteNode!

    var rotationStop: Double!
    var nextRotationStop: Double { rotationStop! + .pi}

    init(scenario: Scenario) {
        _scenario = ObservedObject(wrappedValue: scenario)

        super.init(size: CGSize(width: 1024, height: 1024))
        self.anchorPoint = .anchorAtCenter
        self.scaleMode = .aspectFit
        self.backgroundColor = .clear
    }

    override func didMove(to view: SKView) {
        railSettingsObservers = scenario.rails.map { $0.$space.sink { [weak self] _ in
            self?.railSettingsChanged = true
        } }

        railSelectionObserver = scenario.$railSelection.sink { [weak self] _ in
            self?.railSelectionChanged  = true
        }

        tumblerSettingsObservers = scenario.tumblers.enumerated().map { ix, tumbler in
            tumbler.$space
                .collect(2)
                .sink { [weak self] _ in self?.tumblerSettingsChanged = true }
        }

        tumblerSelectionObserver = scenario.$shapeSelection.sink { [weak self] _ in
            self?.tumblerSelectionChanged  = true
        }

        railSelectionChanged = true
        railSettingsChanged = true

        tumblerSelectionChanged = true
        tumblerSettingsChanged = true

        sceneUpdateRequired = true
    }

    func getNormalX() -> Double {
        switch scenario.editingTumbler.vertexor.shapeClass {
        case .ellipse(0):
            return getNormalXWheel(for: scenario.editingTumbler.space.position.r)
        case .ngon(0):
            return getNormalXStick(for: scenario.editingTumbler.space.position.r)

        default: fatalError()
        }
    }

    func getNormalXStick(for rotation: Double) -> Double {
        let truncated = Int(scenario.editingTumbler.space.rotation / .pi)
        let translated = scenario.editingTumbler.space.rotation >= 0 ? truncated : truncated - 1
        let quantizedRotation = Double(translated) * .pi

        return getNormalXWheel(for: quantizedRotation)
    }

    func getNormalXWheel(for rotation: Double) -> Double {
        let px = abs(rotation)
        let sx_ = px / rotation
        let sx = sx_.isFinite ? sx_ : 1.0

        let fraction = px - Double(Int(px))
        let quantizer = Int(px + 1) % 2

        return sx * (Double(quantizer) - 1 + fraction)
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
            railSprite.setScale(scenario.editingRail.space.radius)
        }

        railSprite.zRotation = scenario.editingRail.space.rotation

        railSettingsChanged = false
    }

    func updateTumblerSpriteForSelection() {
        guard tumblerSelectionChanged else { return }

        switch scenario.editingTumbler.vertexor.shapeClass {
        case .ellipse:
            installCircleTumblerSprite()

        case .ngon(0):
            rotationStop = 0
            installLineTumblerSprite()

        default: assert(false)
        }

        tumblerSelectionChanged = false
    }

    func updateTumblerSpriteForSettings() {
        guard tumblerSettingsChanged else { return }

        tumblerSprite.setScale(scenario.editingTumbler.space.radius)
        tumblerSprite.zRotation = -scenario.editingTumbler.space.rotation

        switch scenario.editingTumbler.vertexor.shapeClass {
        case .ellipse:
            let positionX = scenario.editingTumbler.space.position.r
            let shifted = positionX + 1.0
            let t1 = Int(shifted / 2)
            let t2 = Int(Double(t1) * 2)
            let fraction = shifted - Double(t2)

            let normalX = positionX < -1 ? fraction + 1.0 : fraction - 1.0

            tumblerSprite.position = CGPoint(
                x: normalX * self.size.width / 2.0,
                y: scenario.editingTumbler.space.radius * self.size.width / 2.0
            )

        case .ngon(0):
            let truncated = Int(scenario.editingTumbler.space.rotation / .pi)
            let translated = scenario.editingTumbler.space.rotation >= 0 ? truncated : truncated - 1
            let quantizedRotation = Double(translated) * .pi

            let normalX_ = getNormalXWheel(for: quantizedRotation)
            let translatedAgain: Double
            if translated % 2 == 0 {
                translatedAgain = 0.0
            } else {
                if translated >= 0 { translatedAgain = 4.0 }
                else               { translatedAgain = -4.0 }
            }

            let normalX = normalX_ + translatedAgain * scenario.editingTumbler.space.radius

            tumblerSprite.anchorPoint = translated % 2 == 0 ? .anchorDueEast : .anchorDueWest
            tumblerSprite.position = CGPoint(x: normalX * self.size.width / 2.0, y: 0)

        default:
            fatalError()
        }

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

private extension PixoniaScene {
    func installCircleSprite() {
        let sprite = SpritePool.spokeRings.makeSprite()
        sprite.size = self.size
        sprite.color = SKColor(Color.pixieborder)

        railSprite?.removeFromParent()
        railSprite = sprite
        self.addChild(sprite)
    }

    func installCircleTumblerSprite() {
        let sprite = SpritePool.spokeRings.makeSprite()
        sprite.size = self.size
        sprite.color = SKColor(Color.shizzabrick)

        tumblerSprite?.removeFromParent()
        tumblerSprite = sprite
        railSprite.addChild(sprite)
    }

    func installLineTumblerSprite() {
        let sprite = SpritePool.lines.makeSprite()
        sprite.color = SKColor(Color.shizzabrick)
        sprite.size.width = self.size.width

        tumblerSprite?.removeFromParent()
        tumblerSprite = sprite
        railSprite.addChild(sprite)
    }

    func installLineRailSprite() {
        let sprite = SpritePool.lines.makeSprite()
        sprite.color = SKColor(Color.pixieborder)
        railSprite?.removeFromParent()
        railSprite = sprite
        self.addChild(sprite)
    }
}
