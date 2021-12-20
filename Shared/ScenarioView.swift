// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ScenarioView: View {
    @ObservedObject var pixoniaScene: PixoniaScene
    @ObservedObject var scenario: Scenario

    @State private var pathSelection = "minus"
    @State private var shapeSelection = "circle"

    var pathSelectionIndex: Int {
        PathChooser.symbolNames.firstIndex(of: pathSelection)!
    }

    var shapeSelectionIndex: Int {
        ShapeChooser.symbolNames.firstIndex(of: shapeSelection)!
    }

    init(pixoniaScene: PixoniaScene, scenario: Scenario) {
        _pixoniaScene = ObservedObject(wrappedValue: pixoniaScene)
        _scenario = ObservedObject(wrappedValue: scenario)
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
                PathChooser(pathSelection: $pathSelection)
                    .onChange(of: pathSelection) { _ in scenario.editingPathIndex = pathSelectionIndex }

                ShapeChooser(shapeSelection: $shapeSelection)
                    .onChange(of: shapeSelection) { _ in scenario.editingIndex = shapeSelectionIndex }

                TumblerConfiguratorView(
                    scenario: scenario,
                    tumbler: scenario.tumblers[shapeSelectionIndex],
                    vertexor: scenario.tumblers[shapeSelectionIndex].vertexor
                )

                PixoniaView(scene: pixoniaScene)
            }
        }
    }
}
