// We are a way for the cosmos to know itself. -- C. Sagan

import SpriteKit
import SwiftUI

struct PixoniaView: View {
    let scene: PixoniaScene

    var body: some View {
        SpriteView(
            scene: scene,
            debugOptions: [.showsFPS, .showsNodeCount, .showsDrawCount, .showsQuadCount]
        )
        .aspectRatio(1.0, contentMode: .fit).padding(.trailing)
    }
}
