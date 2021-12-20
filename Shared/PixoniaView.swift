// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct PixoniaView: View {
    let scene: PixoniaScene

    var body: some View {
        SpriteView(
            scene: scene,
            options: .allowsTransparency,
            debugOptions: [.showsFPS, .showsNodeCount, .showsDrawCount, .showsQuadCount]
        )
        .background(Color.clear)
        .aspectRatio(1.0, contentMode: .fit)
    }
}

struct Previews_PixoniaView_Previews: PreviewProvider {
    @ObservedObject static var pixoniaScene = PixoniaScene(scenario: _scenario.wrappedValue)
    @ObservedObject static var scenario = Scenario()

    static var previews: some View {
        PixoniaView(scene: pixoniaScene)
            .preferredColorScheme(.dark)
    }
}
