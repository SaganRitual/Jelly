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

        railSelectionObserver = scenario.$railSelection.sink { _ in self.railSelectionChanged  = true }

        tumblerSettingsObservers = scenario.tumblers.enumerated().map { ix, tumbler in tumbler.$space.sink {
            [weak self] _ in
            self?.tumblerSettingsChanged = true
        } }

        tumblerSelectionObserver = scenario.$shapeSelection.sink { [weak self] _ in
            self?.tumblerSelectionChanged  = true
        }

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

        switch scenario.editingTumbler.vertexor.shapeClass {
        case .ellipse:
            tumblerSprite.setScale(scenario.editingTumbler.space.radius)
        case .ngon(0):
            tumblerSprite.setScale(scenario.editingTumbler.space.radius)
        default:
            assert(false)
        }

        tumblerSprite.zRotation = -scenario.editingTumbler.space.rotation

        let px = abs(scenario.editingTumbler.space.position.r)
        let sx_ = px / scenario.editingTumbler.space.position.r
        let sx = sx_.isFinite ? sx_ : 0.0

        let fraction = px - Double(Int(px))
        let fudger = Int(px + 1) % 2
        let normalX = sx * (Double(fudger) - 1 + fraction)

        print(
            "Position:"
            + " r = \(self.scenario.editingTumbler.space.position.r.as3())"
            + " fudger = \(fudger)"
            + " fraction = \(fraction.as3())"
            + " normalX = \(normalX.as3())"
        )

        tumblerSprite.position = CGPoint(
            x: normalX * self.size.width / 2.0,
            y: scenario.editingTumbler.space.radius * self.size.width / 2.0
        )

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
        sprite.anchorPoint = .anchorDueEast
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
