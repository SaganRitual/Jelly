// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @ObservedObject var pixoniaScene: PixoniaScene
    @ObservedObject var scenario: Scenario

    var body: some View {
        ScenarioView(pixoniaScene: pixoniaScene, scenario: scenario)
    }
}

struct ContentView_Previews: PreviewProvider {
    @ObservedObject static var pixoniaScene = PixoniaScene(scenario: _scenario.wrappedValue)
    @ObservedObject static var scenario = Scenario()

    static var previews: some View {
        ContentView(pixoniaScene: pixoniaScene, scenario: scenario)
    }
}
