// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RailEditor: View {
    @ObservedObject var rail: Rail
    @ObservedObject var scenario: Scenario

    var sliders: [TumblerAttributeSlider<Rail>.Attribute] {
        switch rail.railType {
        case .circle: return [.radius, .rotation, .anchorPointR, .anchorPointT]
        case .line:   return [.radius, .rotation, .anchorPointR, .anchorPointT]
        }
    }

    var body: some View {
        VStack {
            ForEach(sliders, id: \.self) { attribute in
                TumblerAttributeSlider<Rail>(scenario: scenario, attribute: attribute)
            }
        }
    }
}
