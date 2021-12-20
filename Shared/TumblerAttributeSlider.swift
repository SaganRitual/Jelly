// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

protocol HasUnitCircleSpace: ObservableObject {
    var space: UCSpace { get set }
}

struct TumblerAttributeSlider<T: HasUnitCircleSpace>: View {
    @ObservedObject var tumbler: T

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

        return s.asString(decimals: 4)
    }

    var body: some View {
        HStack() {
            HStack {
                Text("\(label)")
                Spacer()
                Text("\(valueView)")
            }
            .padding(.leading)
            .frame(width: 200)

            Slider(
                value: bind(to: attribute),
                in: range,
                label: {}
            )
        }.font(.body.monospaced())
    }
}

struct Previews_TumblerAttributeSlider_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TumblerAttributeSlider(
                tumbler: Tumbler(.ellipse(0)),
                attribute: .radius, label: "Scale",
                range: (-.tau)...(.tau)
            )
            TumblerAttributeSlider(
                tumbler: Tumbler(.ellipse(0)),
                attribute: .rotation, label: "Rotation",
                range: (-.tau)...(.tau)
            )
        }
    }
}
