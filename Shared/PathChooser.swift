// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct PathChooser: View {
    enum PathClass { case circle, line }

    static var symbolNames: [String] = [
        "minus", "circle"
    ]

    @Binding var pathSelection: String

    var body: some View {
        Picker("Path", selection: $pathSelection) {
            ForEach(Self.symbolNames, id: \.self) {
                Image(systemName: $0).tag($0)
            }
        }.pickerStyle(.segmented)
    }
}
