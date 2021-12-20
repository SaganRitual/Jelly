// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ScenarioView: View {
    @ObservedObject var pixoniaScene: PixoniaScene
    @ObservedObject var scenario: Scenario

    init(pixoniaScene: PixoniaScene, scenario: Scenario) {
        _pixoniaScene = ObservedObject(wrappedValue: pixoniaScene)
        _scenario = ObservedObject(wrappedValue: scenario)
    }

    var body: some View {
        VStack {
            HStack {
                TumblerEditor(tumbler: scenario.editingTumbler, vertexor: scenario.editingTumbler.vertexor)
                    .frame(width: 150, height: 150)

                ShapeChooser(shapeSelection: $scenario.shapeSelection)
            }.padding([.top, .bottom])

            PixoniaView(scene: pixoniaScene)

            VStack {
                RailChooser(railSelection: $scenario.railSelection)
                RailEditor(rail: scenario.editingRail, scenario: scenario)
            }.padding([.top, .bottom])
        }
    }
}

struct Previews_ScenarioView_Previews: PreviewProvider {
    @ObservedObject static var pixoniaScene = PixoniaScene(scenario: _scenario.wrappedValue)
    @ObservedObject static var scenario = Scenario()

    static var previews: some View {
        ScenarioView(pixoniaScene: pixoniaScene, scenario: scenario)
    }
}
