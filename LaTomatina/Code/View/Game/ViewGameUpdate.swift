import Foundation
import QuartzCore
import SceneKit
import SpriteKit
import GameKit
var currentTime:TimeInterval = 0
var uploadTime:TimeInterval = 0
extension ViewClass {
    func updateGame(_ time:TimeInterval) {
        currentTime = time
        if let character = mainCharacter {
            character.update()
        }
        for character in characters {
            character.update(true)
            character.currentMapNodes.removeAll()
        }
        if(manager.currentMatch != nil) {
            
            if(uploadTime > currentTime) {
                
            }else{
                uploadTime = currentTime + 0.1
                
                manager.send(message: "\(GKLocalPlayer.local.playerID) \(mainCharacter!.presentation.position.x) \(mainCharacter!.presentation.position.z)")
                
                
                
                for m in manager.getMessages() {
                    
                    let array = m.message.components(separatedBy: " ")
                    
                    if(array.count == 3) {
                        for c in characters {
                            if(c.targetPlayer.playerID == array[0]) {
                                let x = Float(array[1])
                                let z = Float(array[2])
                                
                                c.stepDestination = SCNVector3(x: x!, y: 0, z: z!)
                                
                            }
                        }
                    }
                }
            }
        }
        for tomato in tomatos {
            if(isPositionEqual(tomato.presentation.position,
                               SCNVector3(x:0, y:0, z:0)) == true) {
                continue
            }
            if(tomato.createTime+0.1 > currentTime) {
                continue
            }
            if(tomato.state == "") {
                continue
            }
            if(tomato.state == "CollidedWithGround") {
                if(tomato.presentation.position.y < -10) {
                    if let body = tomato.physicsBody {
                        body.velocity = SCNVector3(x:0, y:0, z:0)
                        body.isAffectedByGravity = false
                        tomato.state = ""
                    }
                }
                continue
            }
            if(tomato.presentation.position.y < 0.2) {
                tomato.state = "CollidedWithGround"
                let location = SCNVector3(x:tomato.presentation.position.x,
                                          y:0, z:tomato.presentation.position.z)
                if(tomato.isPlayerTomato == true) {
                    roadDye.insert(location, at: 0)
                }else{
                    roadDye.append(location)
                }
                addSplash(location)
            }
        }
        if let character = mainCharacter {
            let characterPosition = character.presentation.position
            var requireUpdate:Bool = false
            var forceRemove:Bool = true
            for r in roads {
                requireUpdate = false
                var currentRoadPosition = r.targetNode.presentation.position
                if(currentRoadPosition.x - characterPosition.x > 60) {
                    currentRoadPosition.x -= 120
                    requireUpdate = true
                }else if(characterPosition.x - currentRoadPosition.x > 60) {
                    currentRoadPosition.x += 120
                    requireUpdate = true
                }
                if(currentRoadPosition.z - characterPosition.z > 60) {
                    currentRoadPosition.z -= 120
                    requireUpdate = true
                }else if(characterPosition.z - currentRoadPosition.z > 60) {
                    currentRoadPosition.z += 120
                    requireUpdate = true
                }
                if(requireUpdate == true) {
                    r.updateToLocation(currentRoadPosition)
                }
                if(roadDye.count > 0) {
                    if(abs(r.targetNode.position.x - roadDye[0].x) < 20.5)&&(abs(r.targetNode.position.z - roadDye[0].z) < 20.5) {
                        r.dye(roadDye[0])
                        roadDye.remove(at: 0)
                        forceRemove = false
                    }
                }
            }
            if(forceRemove == true)&&(roadDye.count > 0) {
                roadDye.remove(at: 0)
            }
        }
        updateAndCheckBuildingDataRenderer()
        if(buildingDyeStart.count > 0) {
            if let scene = gameScene {
                var startPoint = buildingDyeStart[0]
                let destination = buildingDyeEnd[0]
                let delta = SCNVector3(x: (destination.x - startPoint.x)*0.5,
                                       y: (destination.y - startPoint.y)*0.5,
                                       z: (destination.z - startPoint.z)*0.5)
                startPoint.x -= delta.x
                startPoint.y -= delta.y
                startPoint.z -= delta.z
                let options:[String:Any] = [SCNHitTestOption.categoryBitMask.rawValue:2,
                                            SCNHitTestOption.searchMode.rawValue:1]
                let results = scene.rootNode.hitTestWithSegment(from: startPoint,
                                                                to: destination,
                                                                options: options)
                for r in results {
                    for b in buildings {
                        if(r.node == b.targetNode) {
                            b.dye(r.textureCoordinates(withMappingChannel: 0))
                        }
                    }
                }
                buildingDyeStart.remove(at: 0)
                buildingDyeEnd.remove(at: 0)
            }
        }
    }
    func preRenderUpdate() {
        updateCamera()
        if let character = mainCharacter {
            for r in roads {
                var value:Float = calculate(character.presentation.position,
                                            r.targetNode.presentation.position)
                if(value > 60) {
                    value = 60
                }else if(value < 30) {
                    value = 30
                }
                value -= 30
                value = value/30.0
                r.targetNode.opacity = 1.0 - CGFloat(value)
            }
        }
    }
}
extension ViewClass {
    @objc(physicsWorld:didBeginContact:) func physicsWorld(_ world: SCNPhysicsWorld,
                                                           didBegin contact: SCNPhysicsContact) {
        if let tomato = contact.nodeA as? TomatoClass {
            if(tomato.state == "Tomato") {
                tomato.state = "CollidedWithWall"
                addSplash(tomato.presentation.position)
                if(contact.nodeB.name == "BuildingBody") {
                    let buildingPosition = SCNVector3(x: contact.nodeB.presentation.worldTransform.m41, y: contact.nodeB.presentation.worldTransform.m42, z: contact.nodeB.presentation.worldTransform.m43)
                    if(tomato.isPlayerTomato == true) {
                        buildingDyeStart.insert(tomato.presentation.position, at:0)
                        buildingDyeEnd.insert(buildingPosition, at:0)
                    }else{
                        buildingDyeStart.append(tomato.presentation.position)
                        buildingDyeEnd.append(buildingPosition)
                    }
                    return
                }
            }
            if(tomato.damaged == false) {
                if let character = contact.nodeB as? CharacterClass {
                    if(tomato.owner == character) {
                        return
                    }
                    tomato.damaged = true
                    character.damaged()
                }
            }
        }
        if let tomato = contact.nodeB as? TomatoClass {
            if(tomato.state == "Tomato") {
                tomato.state = "CollidedWithWall"
                addSplash(tomato.presentation.position)
                if(contact.nodeA.name == "BuildingBody") {
                    let buildingPosition = SCNVector3(x: contact.nodeA.presentation.worldTransform.m41, y: contact.nodeA.presentation.worldTransform.m42, z: contact.nodeA.presentation.worldTransform.m43)
                    if(tomato.isPlayerTomato == true) {
                        buildingDyeStart.insert(tomato.presentation.position, at:0)
                        buildingDyeEnd.insert(buildingPosition, at:0)
                    }else{
                        buildingDyeStart.append(tomato.presentation.position)
                        buildingDyeEnd.append(buildingPosition)
                    }
                    return
                }
            }
            if(tomato.damaged == false) {
                if let character = contact.nodeA as? CharacterClass {
                    if(tomato.owner == character) {
                        return
                    }
                    tomato.damaged = true
                    character.damaged()
                }
            }
        }
    }
}

