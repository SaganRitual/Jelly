// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

protocol HasUnitCircleSpace: ObservableObject {
    var space: UCSpace { get set }
}

struct TumblerAttributeSlider<T: HasUnitCircleSpace>: View {
    @ObservedObject var tumbler: T

    enum Attribute: Int {
        case anchorPointR, anchorPointT, positionR, positionT, radius, rotation
    }

    let attribute: Attribute

    struct SliderDescriptor {
        let attribute: Attribute
        let label: String
        let range: ClosedRange<Double>
    }

    var descriptors: [SliderDescriptor] = [
        SliderDescriptor(attribute: .anchorPointR, label: "Anchor r", range: (-1.0)...(1.0)),
        SliderDescriptor(attribute: .anchorPointT, label: "Anchor θ", range: (-2.0 * .tau)...(2.0 * .tau)),
        SliderDescriptor(attribute: .positionR, label: "Position r", range: (-1.0)...(1.0)),
        SliderDescriptor(attribute: .positionT, label: "Position θ", range: (-2.0 * .tau)...(2.0 * .tau)),
        SliderDescriptor(attribute: .radius, label: "Scale", range: (-1.0)...(1.0)),
        SliderDescriptor(attribute: .rotation, label: "Rotation", range: (-2.0 * .tau)...(2.0 * .tau)),
    ]

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
                Text("\(descriptors[attribute.rawValue].label)")
                Spacer()
                Text("\(valueView)")
            }
            .padding(.leading)
            .frame(width: 200)

            Slider(
                value: bind(to: attribute),
                in: descriptors[attribute.rawValue].range,
                label: {}
            )
        }.font(.body.monospaced())
    }
}
