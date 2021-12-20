// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct ShapeChooser: View {
    enum ShapeClass { case ellipse(Int), ngon(Int) }

    static var symbolNames: [String] = [
        "circle", "capsule", "minus", "triangle", "rectangle",
        "pentagon", "hexagon", "8.square", "10.square", "12.square",
        "20.square"
    ]

    static func indexOf(_ symbolName: String) -> Int {
        symbolNames.firstIndex(of: symbolName)!
    }

    @Binding var shapeSelection: String

    var body: some View {
        Picker("Shape", selection: $shapeSelection) {
            ForEach(Self.symbolNames, id: \.self) {
                Image(systemName: $0).tag($0)
            }
        }.pickerStyle(.segmented)
    }
}
