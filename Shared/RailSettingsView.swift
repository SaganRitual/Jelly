// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RailSettingsView: View {
    @ObservedObject var rail: Rail
    @ObservedObject var scenario: Scenario

    var sliders: [TumblerAttributeSlider<Rail>.Attribute] {
        switch rail.railType {
        case .circle: return [.radius, .rotation]
        case .line:   return [.radius, .rotation]
        }
    }

    var body: some View {
        VStack {
            ForEach(sliders, id: \.self) { attribute in
                TumblerAttributeSlider(tumbler: scenario.editingRail, scenario: scenario, attribute: attribute)
            }
        }
    }
}
