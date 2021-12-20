// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerAttributeSlider: View {
    @ObservedObject var tumbler: Tumbler
    let attribute: Attribute
    let label: String
    let range: ClosedRange<Double>

    enum Attribute {
        case anchorPointR, anchorPointT, positionR, positionT, radius, rotation
    }

    func bind(to attribute: Attribute) -> Binding<Double> {
        switch attribute {
        case .anchorPointR: return Binding(get: { tumbler.space.anchorPoint.r }, set: { tumbler.space.anchorPoint.r = $0 })
        case .anchorPointT: return Binding(get: { tumbler.space.anchorPoint.t }, set: { tumbler.space.anchorPoint.t = $0 })
        case .positionR:    return Binding(get: { tumbler.space.position.r }, set: { tumbler.space.position.r = $0 })
        case .positionT:    return Binding(get: { tumbler.space.position.t }, set: { tumbler.space.position.t = $0 })
        case .radius:       return Binding(get: { tumbler.space.radius }, set: { tumbler.space.radius = $0 })
        case .rotation:     return Binding(get: { tumbler.space.rotation }, set: { tumbler.space.rotation = $0 })
        }
    }

    var valueView: String {
        let s: Double
        switch attribute {
        case .anchorPointR: s = tumbler.space.anchorPoint.r
        case .anchorPointT: s = tumbler.space.anchorPoint.t
        case .positionR: s = tumbler.space.position.r
        case .positionT: s = tumbler.space.position.t
        case .radius: s = tumbler.space.radius
        case .rotation: s = tumbler.space.rotation
        }

        return s.asString(decimals: 6, fixedWidth: 10)
    }

    var body: some View {
        HStack(spacing: 150) {
            Text("\(label) \(valueView)")

            Slider(
                value: bind(to: attribute),
                in: range,
                label: {}
            )
        }.font(.body.monospaced())
    }
}
