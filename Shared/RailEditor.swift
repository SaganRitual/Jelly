// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RailEditor: View {
    @ObservedObject var rail: Rail

    var body: some View {
        VStack {
            if case Rail.RailType.line = rail.railType {
                TumblerAttributeSlider(tumbler: rail, attribute: .rotation, label: "Rotation", range: (-.tau)...(.tau))
            }
        }
    }
}

struct RailEditor_Previews: PreviewProvider {
    static var previews: some View {
        RailEditor(rail: Rail(.line))
    }
}
