import Foundation
import QuartzCore
import SceneKit
import SpriteKit
import UIKit
var currentTomato:Int = 0
var tomatos:[TomatoClass] = []
func initializeTomatos() {
    let itemResourceScene = SCNScene(named: "Game.scnassets/Items/Items.scn")!
    let tomatoTemplate = itemResourceScene.rootNode.childNode(withName:"Ball",
                                                              recursively:false)!
    for _ in 1...100 {
        let newTomato = TomatoClass()
        newTomato.position = SCNVector3(x:0, y:-20, z:0)
        newTomato.geometry = tomatoTemplate.geometry!.copy() as? SCNGeometry
        let bodyShape = SCNBox(width: 0.2, height: 0.2, length: 0.2,
                               chamferRadius: 0)
        newTomato.physicsBody = SCNPhysicsBody(type: .dynamic,
                                               shape: SCNPhysicsShape(geometry: bodyShape,
                                                                      options: nil))
        if let physicsBody = newTomato.physicsBody {
            physicsBody.categoryBitMask = ElementBitMask.Tomato
            physicsBody.collisionBitMask = ElementBitMask.Others | ElementBitMask.Object | ElementBitMask.Player
            physicsBody.contactTestBitMask = ElementBitMask.Others | ElementBitMask.Object | ElementBitMask.Player
            physicsBody.friction = 1
            physicsBody.restitution = 0.05 + CGFloat(10)/200.0
            physicsBody.continuousCollisionDetectionThreshold = 1
            physicsBody.angularDamping = 1.0
            physicsBody.angularVelocityFactor = SCNVector3(x: 0, y:0, z:0)
            physicsBody.velocity = SCNVector3(x:0, y:0, z:0)
            physicsBody.isAffectedByGravity = false
        }
        newTomato.state = ""
        tomatos.append(newTomato)
    }
}
class TomatoClass: SCNNode {
    var state:String = ""
    var createTime:TimeInterval = 0
    var damaged:Bool = false
    var owner:CharacterClass?
    var isPlayerTomato:Bool = false
}
func loadTomatos() {
    if let scene = gameScene {
        for t in tomatos {
            scene.rootNode.addChildNode(t)
        }
    }
}
func freeTomatos() {
    
}
extension CharacterClass{
    func fireTomato() {
        let tomato = tomatos[currentTomato]
        currentTomato += 1
        if(currentTomato >= tomatos.count) {
            currentTomato = 0
        }
        tomato.state = "Tomato"
        tomato.createTime = currentTime
        tomato.damaged = false
        tomato.owner = self
        if(self.isMain == true) {
            tomato.isPlayerTomato = true
        }else{
            tomato.isPlayerTomato = false
        }
        var location = SCNVector3()
        if(self.character[0] == 0) {
            location = SCNVector3(x: self.tomatoMale.presentation.worldTransform.m41,
                                  y: self.tomatoMale.presentation.worldTransform.m42,
                                  z: self.tomatoMale.presentation.worldTransform.m43)
            self.tomatoMale.isHidden = true
        }else{
            location = SCNVector3(x: self.tomatoFemale.presentation.worldTransform.m41,
                                  y: self.tomatoFemale.presentation.worldTransform.m42,
                                  z: self.tomatoFemale.presentation.worldTransform.m43)
            self.tomatoFemale.isHidden = true
        }
        tomato.position = location
        if let physicsBody = tomato.physicsBody {
            physicsBody.resetTransform()
            physicsBody.velocity = SCNVector3(x:0, y:0, z:0)
            physicsBody.isAffectedByGravity = true
            let delta = SCNVector3(x:self.throwingDestination.x - location.x,
                                   y:self.throwingDestination.y - location.y,
                                   z:self.throwingDestination.z - location.z)
            let length:Float = calculate(delta, SCNVector3(x:0, y:0, z:0))
            var impulse = SCNVector3(x: delta.x*1.5,
                                     y: delta.y*0.8 + length*0.15,
                                     z: delta.z*1.5)
            if(length > 5) {
                let factor:Float = 5/length
                impulse.x = impulse.x * factor
                impulse.z = impulse.z * factor
            }
            if(impulse.y > 2.5) {
                impulse.y = 2.5
            }
            physicsBody.applyForce(impulse, asImpulse: true)
        }
        if(fireTomatoCount > 1) {
            for factor in 1..<fireTomatoCount {
                let tomato2 = tomatos[currentTomato]
                currentTomato += 1
                if(currentTomato >= tomatos.count) {
                    currentTomato = 0
                }
                tomato2.state = "Tomato"
                tomato2.createTime = currentTime
                tomato2.damaged = false
                tomato2.owner = self
                if(self.isMain == true) {
                    tomato2.isPlayerTomato = true
                }else{
                    tomato2.isPlayerTomato = false
                }
                tomato2.position = location
                if let physicsBody = tomato2.physicsBody {
                    physicsBody.resetTransform()
                    physicsBody.velocity = SCNVector3(x:0, y:0, z:0)
                    physicsBody.isAffectedByGravity = true
                    let delta = SCNVector3(x:self.throwingDestination.x - location.x,
                                           y:self.throwingDestination.y - location.y,
                                           z:self.throwingDestination.z - location.z)
                    let length:Float = calculate(delta, SCNVector3(x:0, y:0, z:0))
                    var impulse = SCNVector3(x: delta.x*1.5,
                                             y: delta.y*0.8 + length*0.15,
                                             z: delta.z*1.5)
                    if(length > 5) {
                        let factor:Float = 5/length
                        impulse.x = impulse.x * factor
                        impulse.z = impulse.z * factor
                    }
                    if(impulse.y > 2.5) {
                        impulse.y = 2.5
                    }
                    impulse.x += KEFr()*(Float(factor)*2+KEFloat(20))/60.0
                    impulse.y += KEFr()*(Float(factor)*2+KEFloat(20))/60.0
                    impulse.z += KEFr()*(Float(factor)*2+KEFloat(20))/60.0
                    physicsBody.applyForce(impulse, asImpulse: true)
                }
            }
        }
    }
}



