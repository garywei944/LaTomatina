import Foundation
import QuartzCore
import SceneKit
import SpriteKit
import UIKit
var roads:[RoadClass] = []
func setUpRoad(_ road:SCNNode) {
    let roadObject = RoadClass()
    roadObject.initialize(road)
    roads.append(roadObject)
}
class RoadClass {
    var targetNode = SCNNode()
    var positions:[SCNVector3] = []
    var splashTextures:[UIImage] = []
    var current:Int = 0
    var textureSize:CGFloat = 128
    var originalYPosition:Float = 0
    func initialize(_ node:SCNNode) {
        targetNode = node
        if(player.spa == true) {
            for _ in 1...3 {
                splashTextures.append(createSplashTexture())
                positions.append(targetNode.position)
            }
        }else{
            splashTextures.append(createSplashTexture())
            positions.append(targetNode.position)
        }
        if let geometry = targetNode.geometry{
            let cloneGeometry = geometry.copy() as! SCNGeometry
            targetNode.geometry = cloneGeometry
            if let material = cloneGeometry.firstMaterial {
                let cloneMaterial = material.copy() as! SCNMaterial
                cloneMaterial.diffuse.contents = splashTextures[current]
                targetNode.geometry?.materials = [cloneMaterial]
            }
        }
        originalYPosition = targetNode.position.y
    }
    func createSplashTexture()->(UIImage) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: textureSize,
                                                            height: textureSize))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.clear.cgColor)
            let rectangle = CGRect(x: 0, y: 0,
                                   width: textureSize, height: textureSize)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
        }
        return(img)
    }
    func recreateSplashTexture() {
        UIGraphicsBeginImageContext(CGSize(width: textureSize,
                                           height: textureSize))
        if let context = UIGraphicsGetCurrentContext() {
            splashTextures[current].draw(in: CGRect(x: 0, y: 0,
                                                    width: textureSize,
                                                    height: textureSize))
            context.setFillColor(UIColor.clear.cgColor)
            let rectangle = CGRect(x: 0, y: 0,
                                   width: textureSize,
                                   height: textureSize)
            context.addRect(rectangle)
            context.drawPath(using: .fill)
            splashTextures[current] = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            if let material = targetNode.geometry?.firstMaterial {
                material.diffuse.contents = splashTextures[current]
            }
        }
    }
    func dye(_ p:SCNVector3) {
        let worldLocation = CGPoint(x: CGFloat(p.x-positions[current].x)+20.5,
                                    y: CGFloat(p.z-positions[current].z)+20.5)
        let location = CGPoint(x: worldLocation.x*textureSize/41.0,
                               y: worldLocation.y*textureSize/41.0)
        UIGraphicsBeginImageContext(CGSize(width: textureSize,
                                           height: textureSize))
        if let context = UIGraphicsGetCurrentContext() {
            splashTextures[current].draw(in: CGRect(x: 0, y: 0,
                                                    width: textureSize,
                                                    height: textureSize))
            let tomatoColor = UIColor(red:100.0/256.0,
                                      green:0.0/256.0,
                                      blue:10.0/256.0,
                                      alpha:1)
            context.setFillColor(tomatoColor.cgColor)
            let rectangle = CGRect(x: location.x, y: location.y,
                                   width: 2, height: 2)
            context.addRect(rectangle)
            for _ in 0...5 {
                let rectangle2 = CGRect(x: location.x + KECGFr()*KECGFloat(10)/5.0,
                                        y: location.y + KECGFr()*KECGFloat(10)/5.0,
                                        width: 1, height: 1)
                context.addRect(rectangle2)
            }
            context.drawPath(using: .fill)
            splashTextures[current] = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            if let material = targetNode.geometry?.firstMaterial {
                material.diffuse.contents = splashTextures[current]
            }
        }
    }
    func updateToLocation(_ location:SCNVector3) {
        for i in 0..<positions.count {
            if(isPositionEqual(positions[i], location) == true) {
                current = i
                targetNode.position = positions[i]
                if let material = targetNode.geometry?.firstMaterial {
                    material.diffuse.contents = splashTextures[current]
                }
                return
            }
        }
        current += 1
        if(current >= positions.count) {
            current = 0
        }
        let newPosition = SCNVector3(x: location.x, y:originalYPosition, z:location.z)
        positions[current] = newPosition
        targetNode.position = positions[current]
        recreateSplashTexture()
        if let material = targetNode.geometry?.firstMaterial {
            material.diffuse.contents = splashTextures[current]
        }
    }
}

