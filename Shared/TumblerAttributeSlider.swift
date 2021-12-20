// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

protocol HasUnitCircleSpace: ObservableObject {
    var space: UCSpace { get set }
}

struct TumblerAttributeSlider<T: HasUnitCircleSpace>: View {
//    @ObservedObject var tumbler: T
    @ObservedObject var scenario: Scenario

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
        case .anchorPointR: return Binding(get: { scenario.editingRail.space.anchorPoint.r }, set: { scenario.editingRail.space.anchorPoint.r = $0 })
        case .anchorPointT: return Binding(get: { scenario.editingRail.space.anchorPoint.t }, set: { scenario.editingRail.space.anchorPoint.t = $0 })
        case .positionR:    return Binding(get: { scenario.editingRail.space.position.r }, set: { scenario.editingRail.space.position.r = $0 })
        case .positionT:    return Binding(get: { scenario.editingRail.space.position.t }, set: { scenario.editingRail.space.position.t = $0 })
        case .radius:       return Binding(get: { scenario.editingRail.space.radius }, set: { scenario.editingRail.space.radius = $0 })
        case .rotation:     return Binding(get: { scenario.editingRail.space.rotation }, set: { scenario.editingRail.space.rotation = $0 })
        }
    }

    var valueView: String {
        let s: Double
        switch attribute {
        case .anchorPointR: s = scenario.editingRail.space.anchorPoint.r
        case .anchorPointT: s = scenario.editingRail.space.anchorPoint.t
        case .positionR: s = scenario.editingRail.space.position.r
        case .positionT: s = scenario.editingRail.space.position.t
        case .radius: s = scenario.editingRail.space.radius
        case .rotation: s = scenario.editingRail.space.rotation
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
