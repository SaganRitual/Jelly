// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ScenarioView: View {
    @ObservedObject var pixoniaScene: PixoniaScene
    @ObservedObject var scenario: Scenario

//    @Binding var pathSelection: String
//    @Binding var shapeSelection: String

    init(pixoniaScene: PixoniaScene, scenario: Scenario) {
        _pixoniaScene = ObservedObject(wrappedValue: pixoniaScene)
        _scenario = ObservedObject(wrappedValue: scenario)

//        _pathSelection = Binding(projectedValue: scenario.$pathSelection)
//        _shapeSelection = Binding(projectedValue: scenario.$shapeSelection)
    }

//    func getIsRectangle(_ vertexor: Vertexor) -> Bool {
//        if case let ShapeChooser.ShapeClass.ngon(c) = vertexor.shapeClass, c == 4 {
//            return true
//        }
//
//        return false
//    }

    var body: some View {
        VStack {
            VStack {
                ShapeChooser(shapeSelection: $scenario.shapeSelection)

                RailChooser(railSelection: $scenario.railSelection)

                TumblerConfigurator(
                    scenario: scenario,
                    tumbler: scenario.editingTumbler,
                    vertexor: scenario.editingTumbler.vertexor
                )

                PixoniaView(scene: pixoniaScene)
            }
        }
    }
}
