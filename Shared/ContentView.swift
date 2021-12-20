// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ContentView: View {
    @State private var pathSelection = "minus"

    var body: some View {
        PathChooser(pathSelection: $pathSelection)
//            .onChange(of: pathSelection) { _ in scenario.editingPathIndex = pathSelectionIndex }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
