import Foundation
import SpriteKit
import SceneKit
import GameKit
var mainCharacter:CharacterClass?
var characters:[CharacterClass] = []
class CharacterClass: SCNNode {
    var isMain:Bool = false
    var model = SCNNode()
    var aimNode = SCNNode()
    var nodes:[[SCNNode]] = []
    var tomatoMale = SCNNode()
    var tomatoFemale = SCNNode()
    var neck = SCNNode()
    var isRunning:Bool = false
    var needUpdateRunningAnimation:Bool = false
    var character:[Int] = []
    var fireTomatoCount:Int = 1
    var throwing:Bool = false
    var cancelThrowing:Bool = false
    var throwingDestination = SCNVector3()
    var displayingNodes:[SCNNode] = []
    var hp:Int = 100
    var splashTexture = UIImage()
    var AIDestination:SCNVector3?
    var stepDestination:SCNVector3?
    var lastAIPosition = SCNVector3()
    var currentMapNodes:[MapNodeClass] = []
    var canCancelRunning:Bool = false
    var canBeSeen:Bool = true
    var AIPreparation:Int = 2
    var targetItem:ItemClass?
    var stepTimer:TimeInterval = 0
    var fireTimer:TimeInterval = 0
    var targetPlayer:GKPlayer!
    func initialize() {
        let file = Bundle.main.url(forResource: "Game.scnassets/Characters/Characters",
                                   withExtension: "scn")!
        let source = SCNSceneSource(url: file, options: nil)
        for n in try! (source?.scene(options: nil).rootNode.childNodes)! as [SCNNode] {
            model.addChildNode(n)
        }
        tomatoMale = model.childNode(withName:"TomatoMale",
                                     recursively:true)!
        tomatoFemale = model.childNode(withName:"TomatoFemale",
                                       recursively:true)!
        neck = model.childNode(withName:"D_NECK",
                               recursively:true)!
        aimNode.position = SCNVector3(x:0, y:0, z:20)
        model.addChildNode(aimNode)
        model.scale = SCNVector3(x:0.016, y:0.016, z:0.016)
        self.addChildNode(model)
    }
}

