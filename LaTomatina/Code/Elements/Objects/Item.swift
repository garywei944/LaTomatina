import Foundation
import QuartzCore
import SceneKit
import SpriteKit
import UIKit
var itemUpdateIndex:Int = 0
var items:[ItemClass] = []
enum ItemType {
    case Tomato
    case PlusOne
    case Shield
    case Bottle
    case Boot
    case Ice
}
func initializeItems() {
    let itemResourceScene = SCNScene(named: "Game.scnassets/Items/Items.scn")!
    for _ in 1...10 {
        let item = ItemClass()
        item.initialize(itemResourceScene.rootNode, .Tomato)
        items.append(item)
    }
    for _ in 1...10 {
        let item = ItemClass()
        item.initialize(itemResourceScene.rootNode, .PlusOne)
        items.append(item)
    }
    for _ in 1...10 {
        let item = ItemClass()
        item.initialize(itemResourceScene.rootNode, .Shield)
        items.append(item)
    }
    for _ in 1...10 {
        let item = ItemClass()
        item.initialize(itemResourceScene.rootNode, .Bottle)
        items.append(item)
    }
    for _ in 1...10 {
        let item = ItemClass()
        item.initialize(itemResourceScene.rootNode, .Boot)
        items.append(item)
    }
    for _ in 1...10 {
        let item = ItemClass()
        item.initialize(itemResourceScene.rootNode, .Ice)
        items.append(item)
    }
}
func loadItems() {
    if let scene = gameScene {
        for i in items {
            scene.rootNode.addChildNode(i)
        }
    }
}
func freeItems() {
    
}
func mapItems() {
    var array:[MapNodeClass] = []
    for node in mapNodes {
        if(abs(node.position.x - buildingsCenterPosition.x) < 120)&&(abs(node.position.x - buildingsCenterPosition.x) < 120) {
            array.append(node)
        }
    }
    for item in items {
        let index = KEInt(array.count)
        if(array[index].itemPositions.count > 0) {
            let i = KEInt(array[index].itemPositions.count)
            item.show(array[index].itemPositions[i])
            array[index].itemPointers.append(item)
            array[index].itemPositions.remove(at: i)
        }
    }
}
func updateItemAtIndex() {
    if(itemUpdateIndex >= items.count) {
        itemUpdateIndex = 0
    }
    if(items[itemUpdateIndex].state > 0) {
        itemUpdateIndex += 1
        return
    }
    var array:[MapNodeClass] = []
    for node in mapNodes {
        if(abs(node.position.x - buildingsCenterPosition.x) < 120)&&(abs(node.position.z - buildingsCenterPosition.z) < 120) {
            array.append(node)
        }
    }
    let index = KEInt(array.count)
    if(array[index].itemPositions.count > 0) {
        let i = KEInt(array[index].itemPositions.count)
        items[itemUpdateIndex].showAnimated(array[index].itemPositions[i])
        array[index].itemPointers.append(items[itemUpdateIndex])
        array[index].itemPositions.remove(at: i)
        itemUpdateIndex += 1
    }
}
class ItemClass: SCNNode {
    var state:Int = 0
    var type:ItemType = .Tomato
    var model = SCNNode()
    var effect = SCNNode()
    func initialize(_ resource: SCNNode, _ t:ItemType) {
        type = t
        switch(type) {
        case .PlusOne:
            model = resource.childNode(withName:"PlusOne",
                                       recursively:false)!.clone()
            let rotate = SCNAction.rotateBy(x:0.0, y:CGFloat(Float.pi*2), z:0.0,
                                            duration: 1.5)
            model.runAction(SCNAction.repeatForever(rotate))
            break
        case .Shield:
            model = resource.childNode(withName:"Shield",
                                       recursively:false)!.clone()
            let scale1 = SCNAction.scale(to:1.1, duration:0.25)
            let scale2 = SCNAction.scale(to:1, duration:0.25)
            let scale = SCNAction.sequence([scale1, scale2])
            model.runAction(SCNAction.repeatForever(scale))
            break
        case .Bottle:
            model = resource.childNode(withName:"Bottle",
                                       recursively:false)!.clone()
            let rotate = SCNAction.rotateBy(x:0.0, y:CGFloat(Float.pi*2), z:0.0,
                                            duration: 1.5)
            model.runAction(SCNAction.repeatForever(rotate))
            break
        case .Boot:
            model = resource.childNode(withName:"Boot",
                                       recursively:false)!.clone()
            let rotate = SCNAction.rotateBy(x:0.0, y:CGFloat(Float.pi*2), z:0.0,
                                            duration: 1.5)
            model.runAction(SCNAction.repeatForever(rotate))
            break
        case .Ice:
            model = resource.childNode(withName:"Ice",
                                       recursively:false)!.clone()
            let rotate = SCNAction.rotateBy(x:0.0, y:CGFloat(Float.pi*2), z:0.0,
                                            duration: 1.5)
            model.runAction(SCNAction.repeatForever(rotate))
            break
        default:
            model = resource.childNode(withName:"Tomato",
                                       recursively:false)!.clone()
            let rotate = SCNAction.rotateBy(x:0.0, y:CGFloat(Float.pi*2), z:0.0,
                                            duration: 1.5)
            model.runAction(SCNAction.repeatForever(rotate))
            break
        }
        effect = resource.childNode(withName:"ItemCircle",
                                    recursively:false)!.clone()
        effect.position = SCNVector3(x:0, y:1.5, z:0)
        model.position = SCNVector3(x:0, y:1.5, z:0)
        self.addChildNode(effect)
        self.addChildNode(model)
        self.position = SCNVector3(x:0, y:-10.0, z:0)
    }
    func show(_ d:SCNVector3) {
        self.state = 1
        self.position = d
        self.opacity = 1
    }
    func showAnimated(_ d:SCNVector3) {
        self.state = 1
        self.position = d
        self.opacity = 0
        let fade = SCNAction.fadeIn(duration: 0.2)
        self.runAction(fade)
    }
    func hide() {
        self.state = 0
        self.position.y = -10
        effect.position = SCNVector3(x:0, y:1.5, z:0)
        model.position = SCNVector3(x:0, y:1.5, z:0)
        model.opacity = 1
    }
    func obtain(_ c:CharacterClass) {
        self.state = 2
        let move = SCNAction.moveBy(x:0, y:1.5, z:0, duration: 0.5)
        self.model.runAction(move)
        let fade = SCNAction.fadeOut(duration: 0.5)
        self.model.runAction(fade, completionHandler: {
            self.hide()
        })
        effect.position = SCNVector3(x:0, y:-10, z:0)
        collects[currentCollect].position = SCNVector3(x:self.position.x, y:1.5,
                                                       z:self.position.z)
        collectEffects[currentCollect].reset()
        collects[currentCollect].addParticleSystem(
            collectEffects[currentCollect]
        )
        currentCollect += 1
        if(currentCollect >= collects.count) {
            currentCollect = 0
        }
        switch(type) {
        case .PlusOne:
            break
        case .Shield:
            break
        case .Bottle:
            
            c.recreateSplashTexture()
            
            break
        case .Boot:
            break
        case .Ice:
            break
        default:
            
            c.fireTomatoCount += 1
            
            break
        }
    }
}
