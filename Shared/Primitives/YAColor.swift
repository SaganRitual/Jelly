// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

#if os(macOS)
typealias YAColor = NSColor
#elseif os(iOS)
import UIKit
typealias YAColor = UIColor
#endif

// 🙏 https://stackoverflow.com/users/837499/johnny
// https://stackoverflow.com/a/65046791/1610473
extension Color {
    enum BoringSoftware {
         static let appBackgroundOrSomething = Color("appBackgroundOrSomething")
         static let pixieBorder = Color("pixieBorder")
         static let pixieFill = Color("pixieFill")
         static let royalPurple = Color("royalPurple")
         static let salmonzilla = Color("salmonzilla")
         static let tealjeans = Color("tealjeans")
         static let velvetPresley = Color("velvetPresley")
    }
}

extension YAColor {
    enum Scale: CaseIterable {
        case red, green, blue, rgbAlpha, hue, saturation, brightness, hsbAlpha
    }

    static func css(_ code: String) -> YAColor {
        precondition(code.first! == "#")
        let r = Double(Int(code.substr(1..<3), radix: 16)!) / 256.0
        let g = Double(Int(code.substr(3..<5), radix: 16)!) / 256.0
        let b = Double(Int(code.substr(5..<7), radix: 16)!) / 256.0
        return YAColor(red: r, green: g, blue: b, alpha: 1)
    }

    func rotateHue(byAngle radians: Double) -> YAColor {
        var h = CGFloat.zero, s = CGFloat.zero, b = CGFloat.zero, a = CGFloat.zero
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        h = (h + (radians / .tau)).truncatingRemainder(dividingBy: 1.0)

        #if os(macOS)
        return NSColor(calibratedHue: h, saturation: s, brightness: b, alpha: a)
        #elseif os(iOS)
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
        #endif
    }

    func scale(_ component: Scale, by scaleFactor: Double) -> YAColor {
        if [Scale.red, .green, .blue, .rgbAlpha].contains(component) {
            return scaleRGBA(component, by: scaleFactor)
        } else {
            return scaleHSBA(component, by: scaleFactor)
        }
    }

    private func scaleRGBA(_ component: Scale, by scaleFactor: Double) -> YAColor {
        var r = CGFloat.zero, g = CGFloat.zero, b = CGFloat.zero, a = CGFloat.zero
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        switch component {
        case .red:      r *= scaleFactor
        case .green:    g *= scaleFactor
        case .blue:     b *= scaleFactor
        case .rgbAlpha: a *= scaleFactor
        default: fatalError()
        }

        #if os(macOS)
        return NSColor(calibratedRed: r, green: g, blue: b, alpha: a)
        #elseif os(iOS)
        return UIColor(red: r, green: g, blue: b, alpha: a)
        #endif
    }

    func red(_ scaleFactor: Double) -> YAColor { scale(.red, by: scaleFactor) }
    func green(_ scaleFactor: Double) -> YAColor { scale(.green, by: scaleFactor) }
    func blue(_ scaleFactor: Double) -> YAColor { scale(.blue, by: scaleFactor) }
    func rgbAlpha(_ scaleFactor: Double) -> YAColor { scale(.rgbAlpha, by: scaleFactor) }

    private func scaleHSBA(_ component: Scale, by scaleFactor: Double) -> YAColor {
        var h = CGFloat.zero, s = CGFloat.zero, b = CGFloat.zero, a = CGFloat.zero
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        switch component {
        case .hue:        h *= scaleFactor
        case .saturation: s *= scaleFactor
        case .brightness: b *= scaleFactor
        case .hsbAlpha:   a *= scaleFactor
        default: fatalError()
        }

        #if os(macOS)
        return NSColor(calibratedHue: h, saturation: s, brightness: b, alpha: a)
        #elseif os(iOS)
        return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
        #endif
    }
}
