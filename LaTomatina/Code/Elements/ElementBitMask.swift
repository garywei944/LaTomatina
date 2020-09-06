import Foundation
import QuartzCore
import SceneKit
import SpriteKit
struct ElementBitMask {
    static let None:        Int = 0b00000000
    static let All:         Int = 0b11111111
    static let Player:      Int = 0b00000001
    static let Others:      Int = 0b00000010
    static let Object:      Int = 0b00000100
    static let Tomato:      Int = 0b00001000
}
