// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct RailEditor: View {
    @ObservedObject var rail: Rail

    var sliders: [TumblerAttributeSlider<Rail>.Attribute] {
        switch rail.railType {
        case .circle: return [.radius, .rotation, .anchorPointR, .anchorPointT]
        case .line:   return [.rotation]
        }
    }

    var body: some View {
        VStack {
            ForEach(sliders, id: \.self) { attribute in
                TumblerAttributeSlider(tumbler: rail, attribute: attribute)
            }
        }
    }
}

struct RailEditor_Previews: PreviewProvider {
    static var previews: some View {
        RailEditor(rail: Rail(.line))
    }
}
