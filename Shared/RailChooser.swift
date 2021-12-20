// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RailChooser: View {
    enum RailClass { case circle, line }

    static var symbolNames: [String] = [
        "minus", "circle"
    ]

    static func indexOf(_ symbolName: String) -> Int {
        symbolNames.firstIndex(of: symbolName)!
    }

    @Binding var railSelection: String

    var body: some View {
        Picker("Rail", selection: $railSelection) {
            ForEach(Self.symbolNames, id: \.self) {
                Image(systemName: $0).tag($0)
            }
        }.pickerStyle(.segmented)
    }
}
