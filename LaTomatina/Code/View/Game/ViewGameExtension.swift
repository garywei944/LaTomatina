import Foundation
import QuartzCore
import SceneKit
import SpriteKit
extension ViewClass {
    func updateCamera() {
        if let control = cameraControl, let character = mainCharacter {
            control.position = character.presentation.position
        }
        if let scene = gameScene {
            var cameraXOffset:Float = 0
            if let control = cameraControl {
                let lead = cameraDetections[0]
                let startPoint = SCNVector3(x: control.position.x, y: 2,
                                            z: control.position.z)
                let destination = SCNVector3(x: lead.presentation.worldTransform.m41,
                                             y: lead.presentation.worldTransform.m42,
                                             z: lead.presentation.worldTransform.m43)
                let length = calculate(startPoint, destination)
                let options:[String:Any] = [SCNHitTestOption.backFaceCulling.rawValue:false,
                                            SCNHitTestOption.categoryBitMask.rawValue:2,
                                            SCNHitTestOption.searchMode.rawValue:1]
                let results = scene.rootNode.hitTestWithSegment(from: startPoint,
                                                                to: destination,
                                                                options: options)
                var minDistance:Float = 10
                for r in results {
                    let location = r.worldCoordinates
                    let distance = calculate(startPoint, location)
                    if(distance < minDistance) {
                        minDistance = distance
                    }
                }
                if(length > minDistance) {
                    cameraXOffset -= (length-minDistance)*0.2
                }
            }
            if let control = cameraControl {
                let lead = cameraDetections[1]
                let startPoint = SCNVector3(x: control.position.x, y: 2,
                                            z: control.position.z)
                let destination = SCNVector3(x: lead.presentation.worldTransform.m41,
                                             y: lead.presentation.worldTransform.m42,
                                             z: lead.presentation.worldTransform.m43)
                let length = calculate(startPoint, destination)
                let options:[String:Any] = [SCNHitTestOption.backFaceCulling.rawValue:false,
                                            SCNHitTestOption.categoryBitMask.rawValue:2,
                                            SCNHitTestOption.searchMode.rawValue:1]
                let results = scene.rootNode.hitTestWithSegment(from: startPoint,
                                                                to: destination,
                                                                options: options)
                var minDistance:Float = 10
                for r in results {
                    let location = r.worldCoordinates
                    let distance = calculate(startPoint, location)
                    if(distance < minDistance) {
                        minDistance = distance
                    }
                }
                if(length > minDistance) {
                    cameraXOffset += (length-minDistance)*0.2
                }
            }
            if let camera = cameraNode, let control = cameraControl, let lead = cameraLead {
                let startPoint = SCNVector3(x: control.position.x, y: 2,
                                            z: control.position.z)
                let destination = SCNVector3(x: lead.presentation.worldTransform.m41,
                                             y: lead.presentation.worldTransform.m42,
                                             z: lead.presentation.worldTransform.m43)
                let length = calculate(startPoint, destination)
                let options:[String:Any] = [SCNHitTestOption.backFaceCulling.rawValue:false,
                                            SCNHitTestOption.categoryBitMask.rawValue:2,
                                            SCNHitTestOption.searchMode.rawValue:1]
                let results = scene.rootNode.hitTestWithSegment(from: startPoint,
                                                                to: destination,
                                                                options: options)
                var minDistance:Float = 6
                for r in results {
                    let location = r.worldCoordinates
                    let distance = calculate(startPoint, location)
                    if(distance < minDistance) {
                        minDistance = distance
                    }
                }
                if(length > minDistance) {
                    SCNTransaction.animateWithDuration(0.05) {
                        camera.position.z = 1-minDistance
                    }
                }
                SCNTransaction.animateWithDuration(0.1) {
                    camera.position.x = cameraXOffset
                }
            }
        }
    }
    func addSplash(_ p:SCNVector3) {
        splashs[currentSplash].position = p
        splashEffects[currentSplash].reset()
        splashs[currentSplash].addParticleSystem(
            splashEffects[currentSplash]
        )
        currentSplash += 1
        if(currentSplash >= splashs.count) {
            currentSplash = 0
        }
    }
    func dyeBuilding(_ p:SCNVector3, _ s:SCNVector3) {
        if let scene = gameScene {
            var startPoint = SCNVector3(x: p.x, y: p.y, z: p.z)
            var destination = SCNVector3(x: s.x, y: p.y, z: s.z)
            startPoint.x -= (destination.x - startPoint.x)*0.2
            startPoint.z -= (destination.z - startPoint.z)*0.2
            destination.x += (destination.x - startPoint.x)*0.2
            destination.z += (destination.z - startPoint.z)*0.2
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
        }
    }
}


