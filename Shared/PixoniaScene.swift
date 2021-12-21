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
            railSprite.setScale(scenario.editingRail.space.radius)
        }

        railSprite.zRotation = scenario.editingRail.space.rotation

        railSettingsChanged = false
    }

    func updateTumblerSpriteForSelection() {
        guard tumblerSelectionChanged else { return }

        switch scenario.editingTumbler.vertexor.shapeClass {
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
        case .ngon(0):
            tumblerSprite.setScale(scenario.editingTumbler.space.radius)
        default:
            assert(false)
        }

        tumblerSprite.zRotation = -scenario.editingTumbler.space.rotation

        setPositionX()

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
    func setAnchorX() -> Bool {
        var anchorDidChange = false

        // We're between stops; anchor doesn't change
        if(rotationStop..<nextRotationStop)
            .contains(scenario.editingTumbler.space.rotation) { return anchorDidChange }

        anchorDidChange = true

        if abs(scenario.editingTumbler.space.rotation - rotationStop) <
            abs(scenario.editingTumbler.space.rotation - nextRotationStop) {
            rotationStop -= .pi
            scenario.editingTumbler.space.position.r -= scenario.editingTumbler.space.radius
        } else {
            rotationStop = nextRotationStop
            scenario.editingTumbler.space.position.r += scenario.editingTumbler.space.radius
        }

        tumblerSprite.position.x = scenario.editingTumbler.space.position.r * self.size.width

        scenario.editingTumbler.space.anchorPoint = UCPoint(
            r: scenario.editingTumbler.space.anchorPoint.r * -1,
            t: scenario.editingTumbler.space.anchorPoint.t
        )

        tumblerSprite.anchorPoint.x = (tumblerSprite.anchorPoint.x == 0.0) ? 1.0 : 0.0
        return anchorDidChange
    }

    func setPositionX() {
        var X = 0.0
        defer {
            v1.position.x = railSprite.convert(CGPoint(x: X, y: 0), to: self).x
            v2.position.x = railSprite.position.x + railSprite.size.width / 2
            v1.zRotation = .pi / 2
            v2.zRotation = .pi / 2
        }

        let anchorDidChange = setAnchorX()

        // If we didn't change the anchor, we need to check for rotating
        // beyond the ends of the rail.
        let B = .pi - scenario.editingTumbler.space.rotation
        let L = scenario.editingTumbler.space.radius * 2 * cos(B)

        if tumblerSprite.anchorPoint.x == 1 {
            X = tumblerSprite.position.x + L * self.size.width / 2
        } else {
            X = tumblerSprite.position.x - L * self.size.width / 2
        }

        // If we changed the anchor, we changed the position along with it.
        if anchorDidChange { return }

//        if X > scenario.editingRail.space.radius {
//            scenario.editingTumbler.space.position.r = -scenario.editingRail.space.radius - L
//        }
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
        let sprite = SpritePool.lines.makeSprite()
        sprite.color = SKColor(Color.shizzabrick)
        sprite.anchorPoint = .anchorDueEast
        tumblerSprite?.removeFromParent()
        tumblerSprite = sprite
        railSprite.addChild(sprite)

        v1 = SpritePool.lines.makeSprite()
        v1.color = SKColor(Color.salmonzilla)
        self.addChild(v1)

        v2 = SpritePool.lines.makeSprite()
        v2.color = SKColor(Color.velvetpresley)
        self.addChild(v2)
    }

    func installLineRailSprite() {
        let sprite = SpritePool.lines.makeSprite()
        sprite.color = SKColor(Color.pixieborder)
        railSprite?.removeFromParent()
        railSprite = sprite
        self.addChild(sprite)
    }
}
