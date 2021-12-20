// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerSettingsView: View {
    @ObservedObject var tumbler: Tumbler
    @ObservedObject var scenario: Scenario

    var sliders: [TumblerAttributeSlider<Tumbler>.Attribute] {
        switch tumbler.vertexor.shapeClass {
        case .ngon(0):   return [.radius, .rotation]
        default: assert(false)
        }
    }

    var body: some View {
        VStack {
            ForEach(sliders, id: \.self) { attribute in
                TumblerAttributeSlider(tumbler: tumbler, scenario: scenario, attribute: attribute)
            }
        }
    }
}
