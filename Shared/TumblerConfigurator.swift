// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerConfigurator: View {
    @ObservedObject var scenario: Scenario
    @ObservedObject var tumbler: Tumbler
    @ObservedObject var vertexor: Vertexor

    var body: some View {
        HStack {
            TumblerEditor(tumbler: tumbler, vertexor: tumbler.vertexor)
                .frame(width: 150, height: 150)

            VStack {
                TumblerAttributeSlider(tumbler: tumbler, attribute: .radius, label: "Scale", range: (-2.0)...(2.0))
                TumblerAttributeSlider(tumbler: tumbler, attribute: .rotation, label: "Rotation", range: (-2.0 * .tau)...(2.0 * .tau))
                TumblerAttributeSlider(tumbler: tumbler, attribute: .anchorPointR, label: "Anchor r", range: (-1.0)...(1.0))
                TumblerAttributeSlider(tumbler: tumbler, attribute: .anchorPointT, label: "Anchor θ", range: (-2.0 * .tau)...(2.0 * .tau))
            }
        }.padding(.top)
    }
}
