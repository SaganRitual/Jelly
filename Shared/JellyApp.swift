// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct JellyApp: App {
    @ObservedObject var pixoniaScene: PixoniaScene
    @ObservedObject var scenario = Scenario()

    init() {
        _pixoniaScene = ObservedObject(initialValue: PixoniaScene(scenario: _scenario.wrappedValue))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(pixoniaScene: pixoniaScene, scenario: scenario)
        }
    }
}
