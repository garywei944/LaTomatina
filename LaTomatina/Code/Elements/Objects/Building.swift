import Foundation
import QuartzCore
import SceneKit
import SpriteKit
import UIKit
var buildings:[BuildingClass] = []
func setUpBuilding(_ building:SCNNode, _ i:Int) {
    let buildingObject = BuildingClass()
    buildingObject.initialize(building, i)
    buildings.append(buildingObject)
}
class BuildingClass {
    var isUsing:Bool = false
    var targetNode = SCNNode()
    var positions:[SCNVector3] = []
    var splashTexture = UIImage()
    var textureSize:CGFloat = 1500
    var originalYPosition:Float = 0
    var showing:Bool = false
    var type:Int = 0
    func initialize(_ node:SCNNode, _ i:Int) {
        type = i
        targetNode = node
        if let name = node.name {
            if(name == "Building5") {
                textureSize = 1000
            }
        }
        originalYPosition = targetNode.position.y
        for node in targetNode.childNodes {
            if let physicsBody = node.physicsBody {
                physicsBody.categoryBitMask = ElementBitMask.Object
                physicsBody.collisionBitMask = ElementBitMask.Player | ElementBitMask.Others | ElementBitMask.Tomato
                physicsBody.contactTestBitMask = ElementBitMask.Tomato
            }
        }
        self.disappear()
    }
    func appear(_ d:SCNVector3, _ r:Float) {
        showing = true
        targetNode.eulerAngles.y = r
        targetNode.position.y = originalYPosition
        let newPosition = SCNVector3(x: d.x, y:originalYPosition, z:d.z)
        targetNode.position = newPosition
        recreateSplashTexture()
        if let material = targetNode.geometry?.firstMaterial {
            material.multiply.contents = splashTexture
        }
        for node in targetNode.childNodes {
            if let physicsBody = node.physicsBody {
                physicsBody.resetTransform()
            }
        }
    }
    func disappear() {
        showing = false
        targetNode.position.y = -200
        for node in targetNode.childNodes {
            if let physicsBody = node.physicsBody {
                physicsBody.resetTransform()
            }
        }
    }
    func createSplashTexture()->(UIImage) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: textureSize/4,
                                                            height: textureSize/4))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            let rectangle = CGRect(x: 0, y: 0,
                                   width: textureSize/4, height: textureSize/4)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
        }
        return(img)
    }
    func recreateSplashTexture() {
        UIGraphicsBeginImageContext(CGSize(width: textureSize/4,
                                           height: textureSize/4))
        if let context = UIGraphicsGetCurrentContext() {
            splashTexture.draw(in: CGRect(x: 0, y: 0,
                                                    width: textureSize/4,
                                                    height: textureSize/4))
            context.setFillColor(UIColor.white.cgColor)
            let rectangle = CGRect(x: 0, y: 0,
                                   width: textureSize/4,
                                   height: textureSize/4)
            context.addRect(rectangle)
            context.drawPath(using: .fill)
            splashTexture = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            if let material = targetNode.geometry?.firstMaterial {
                material.multiply.contents = splashTexture
            }
        }
    }
    func dye(_ p:CGPoint) {
        let location = CGPoint(x: p.x*textureSize/4, y: p.y*textureSize/4)
        UIGraphicsBeginImageContext(CGSize(width: textureSize/4,
                                           height: textureSize/4))
        if let context = UIGraphicsGetCurrentContext() {
            splashTexture.draw(in: CGRect(x: 0, y: 0,
                                                    width: textureSize/4,
                                                    height: textureSize/4))
            let tomatoColor = UIColor(red:200.0/256.0,
                                      green:20.0/256.0,
                                      blue:40.0/256.0,
                                      alpha:1)
            context.setFillColor(tomatoColor.cgColor)
            let rectangle = CGRect(x: location.x, y: location.y,
                                   width: 3, height: 3)
            context.addRect(rectangle)
            for _ in 0...5 {
                let rectangle2 = CGRect(x: location.x + KECGFr()*KECGFloat(10)/3.0,
                                        y: location.y + KECGFr()*KECGFloat(10)/3.0,
                                        width: 1.5, height: 1.5)
                context.addRect(rectangle2)
            }
            context.drawPath(using: .fill)
            splashTexture = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            if let material = targetNode.geometry?.firstMaterial {
                material.multiply.contents = splashTexture
            }
        }
    }
}
