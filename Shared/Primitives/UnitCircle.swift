// We are a way for the cosmos to know itself. -- C. Sagan

import CoreGraphics

struct UCPoint {
    var r = 0.0
    var t = 0.0

    // Totally feels like cheating; learn how to do all this without xy
    var x: Double { r * cos(t) }
    var y: Double { r * sin(t) }

    // Although this is necessary for talking to SpriteKit
    var cgPoint: CGPoint { CGPoint(x: x, y: y) }

    static let zero = UCPoint(r: 0.0, t: 0.0)

    init(r: Double, t: Double) { self.r = r; self.t = t }
}

func zeroish(_ v: Double, decimals: Int = 4, fixedWidth: Int? = nil) -> String {
    abs(v) < pow(10, -Double(decimals + 1)) ? "(0)" : "\(v.asString(decimals: decimals, fixedWidth: fixedWidth))"
}

extension UCPoint: CustomDebugStringConvertible {
    var debugDescription: String { "UCPoint(r: \(zeroish(r)), t: \(zeroish(t)))" }
}

extension UCPoint: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(r)
        hasher.combine(t)
    }
}

struct UCSpace {
    var anchorPoint = UCPoint.zero
    var position = UCPoint.zero
    var radius = 1.0
    var rotation = 0.0

    static let unit = UCSpace(radius: 1.0, rotation: 0.0)

    var diameter: Double { 2 * radius }
}

extension UCSpace: CustomDebugStringConvertible {
    var debugDescription: String {
        "UCSpace(r: \(zeroish(radius)), t: \(zeroish(rotation))) anchor \(anchorPoint)"
    }
}

extension UCSpace: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(radius)
        hasher.combine(rotation)
    }
}
