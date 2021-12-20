// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerConfiguratorView: View {
    @ObservedObject var scenario: Scenario
    @ObservedObject var tumbler: Tumbler
    @ObservedObject var vertexor: Vertexor

    var scaleBinding: Binding<Double> {
        Binding(get: { scenario.tumblerScale }, set: { scenario.tumblerScale = $0 })
    }

    var body: some View {
        HStack {
            TumblerEditorView(tumbler: tumbler, vertexor: tumbler.vertexor)
                .frame(width: 150, height: 150)

            VStack {
                TumblerAttributeSlider(tumbler: tumbler, attribute: .radius, label: "Scale", range: (-2.0)...(2.0))

                Slider(
                    value: Binding(
                        get: { scenario.tumblerZRotation },
                        set: { scenario.tumblerZRotation = $0 }
                    ),
                    in: (Double.zero)...(2.0 * Double.tau),
                    label: {
                        Text("Rotation \(scenario.tumblerZRotation)").font(.body.monospaced())
                    })
                    .padding([.top, .leading, .trailing])

                Slider(
                    value: Binding(
                        get: { scenario.tumblerAnchorRadius },
                        set: { scenario.tumblerAnchorRadius = $0 }
                    ),
                    in: 0.0...1.0,
                    label: {
                        Text("Anchor Radius \(scenario.tumblerAnchorRadius)").font(.body.monospaced())
                    })
                    .padding([.top, .leading, .trailing])

                Slider(
                    value: Binding(
                        get: { scenario.tumblerAnchorTheta },
                        set: { scenario.tumblerAnchorTheta = $0 }
                    ),
                    in: (Double.zero)...(2.0 * Double.tau),
                    label: {
                        Text("Anchor Theta \(scenario.tumblerAnchorTheta)").font(.body.monospaced())
                    })
                    .padding([.top, .leading, .trailing])
            }
        }.foregroundColor(.gray)
    }
}
