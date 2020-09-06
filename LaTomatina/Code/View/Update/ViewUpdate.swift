import Foundation
import QuartzCore
import SceneKit
import SpriteKit
extension ViewClass {
    func renderer(_ renderer: SCNSceneRenderer,
                  updateAtTime time: TimeInterval) {
        switch(state) {
        case .menu:
            updateMenu(time)
            break
        case .game:
            updateGame(time)
            break
        default:
            break
        }
    }
    func renderer(_ renderer: SCNSceneRenderer,
                  willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        switch(state) {
        case .menu:
            break
        case .game:
            preRenderUpdate()
            break
        default:
            break
        }
    }
}
