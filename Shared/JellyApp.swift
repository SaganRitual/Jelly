// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

@main
struct JellyApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.BoringSoftware.appBackgroundOrSomething
                ContentView()
            }
        }
    }
}
