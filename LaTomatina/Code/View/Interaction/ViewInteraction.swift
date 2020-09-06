import Foundation
import QuartzCore
import SceneKit
import SpriteKit
var lockAllInteraction:Bool = false
var interactionSmoothFactor:CGFloat = 0
let menuCameraSommthFactor:Float = 0.004
var menuCameraEulerAngles = SCNVector3()
var lookGesture: UIPanGestureRecognizer!
var walkGesture: UIPanGestureRecognizer!
var fireGesture: FireGesture!
extension ViewClass {
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesBegan(touches, with: event!)
        interactionSmoothFactor = 0
        if(lockAllInteraction == true) {
            return
        }
        if(state == .menu) {
            touchesMoved = false
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        if(lockAllInteraction == true) {
            interactionSmoothFactor = 0
            return
        }
        if(interactionSmoothFactor < 1) {
            interactionSmoothFactor += 0.1
        }
        if(state == .menu) {
            var deltaX = touches.first!.location(in:self).x
            deltaX -= touches.first!.previousLocation(in:self).x
            deltaX = deltaX * interactionSmoothFactor
            var deltaY = touches.first!.location(in:self).y
            deltaY -= touches.first!.previousLocation(in:self).y
            deltaY = deltaY * interactionSmoothFactor
            if(deltaX == 0)&&(deltaY == 0) {
                touchesMoved = false
                return
            }
            touchesMoved = true
            menuCameraEulerAngles.y += Float(deltaX) * menuCameraSommthFactor
            menuCameraEulerAngles.x += Float(deltaY) * menuCameraSommthFactor
            if(menuCameraEulerAngles.y > 0.5) {
                menuCameraEulerAngles.y = 0.5
            }else if(menuCameraEulerAngles.y < -2.45) {
                menuCameraEulerAngles.y = -2.45
            }
            if(menuCameraEulerAngles.x > -0.1) {
                menuCameraEulerAngles.x = -0.1
            }else if(menuCameraEulerAngles.x < -0.7) {
                menuCameraEulerAngles.x = -0.7
            }
            if let scene = menuScene {
                let camera = scene.rootNode.childNode(withName:"Camera",
                                                      recursively:false)!
                SCNTransaction.animateWithDuration(0.06) {
                    camera.eulerAngles = menuCameraEulerAngles
                    camera.position.y = 2.5 - menuCameraEulerAngles.x
                    camera.position.z = menuCameraEulerAngles.y - 0.5
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        interactionSmoothFactor = 0
        if(lockAllInteraction == true) {
            return
        }
        if(state == .menu) {
            if(touchesMoved == false)&&(lockMenuButton == false)&&(menuMatchingState == "") {
                let position = touches.first!.location(in: self)
                var hitResults:[SCNHitTestResult] = []
                hitResults = self.hitTest(position,
                                          options:[SCNHitTestOption.categoryBitMask : 2])
                if(hitResults.count > 0) {
                    for result in hitResults {
                        let node = result.node
                        if let parent = node.parent {
                            if(parent.name == "Start") {
                                if(pressedMenuButtonName == "") {
                                    pressedMenuButtonName = "Start"
                                    if let scaleNode = parent.parent {
                                        menuButtonNode = scaleNode
                                    }
                                }
                            }else if(parent.name == "Edit Name") {
                                if(pressedMenuButtonName == "") {
                                    pressedMenuButtonName = "Edit Name"
                                    menuButtonNode = parent
                                    if let scaleNode = parent.parent {
                                        menuButtonNode = scaleNode
                                    }
                                }
                            }else if(parent.name == "Ant") {
                                if(pressedMenuButtonName == "") {
                                    pressedMenuButtonName = "Ant"
                                    menuButtonNode = parent
                                    if let scaleNode = parent.parent {
                                        menuButtonNode = scaleNode
                                    }
                                }
                            }else if(parent.name == "Lit") {
                                if(pressedMenuButtonName == "") {
                                    pressedMenuButtonName = "Lit"
                                    menuButtonNode = parent
                                    if let scaleNode = parent.parent {
                                        menuButtonNode = scaleNode
                                    }
                                }
                            }else if(parent.name == "Son") {
                                if(pressedMenuButtonName == "") {
                                    pressedMenuButtonName = "Son"
                                    menuButtonNode = parent
                                    if let scaleNode = parent.parent {
                                        menuButtonNode = scaleNode
                                    }
                                }
                            }else if(parent.name == "Spa") {
                                if(pressedMenuButtonName == "") {
                                    pressedMenuButtonName = "Spa"
                                    menuButtonNode = parent
                                    if let scaleNode = parent.parent {
                                        menuButtonNode = scaleNode
                                    }
                                }
                            }else if(parent.name == "Pre") {
                                if(preMenuName == "") {
                                    if let titleNode = parent.parent {
                                        if let title = titleNode.name {
                                            preMenuName = title
                                        }
                                    }
                                    menuButtonNode = parent
                                }
                            }else if(parent.name == "Next") {
                                if(nextMenuName == "") {
                                    if let titleNode = parent.parent {
                                        if let title = titleNode.name {
                                            nextMenuName = title
                                        }
                                    }
                                    menuButtonNode = parent
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch)->(Bool){
        //if(touch.location(in: self).y > self.frame.size.height*2/3) {
            //return(false)
        //}
        if(gestureRecognizer == lookGesture){
            return(touch.location(in: self).x > self.frame.size.width / 2)
        }else if(gestureRecognizer == walkGesture){
            return(touch.location(in: self).x < self.frame.size.width / 2)
        }
        return(true)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)->(Bool){
        return(true)
    }
    @objc func lookGestureRecognized(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        if let camera = cameraNode, let control = cameraControl {
            var factor:Float = abs(camera.presentation.position.z) * 0.002
            if(factor < 0.004) {
                factor = 0.004
            }
            SCNTransaction.animateWithDuration(0.05) {
                control.eulerAngles.y -= Float(translation.x) * factor
            }
        }
        gesture.setTranslation(CGPoint.zero, in: self)
    }
    @objc func walkGestureRecognized(_ gesture: UIPanGestureRecognizer) {
        if(gesture.state == .ended)||(gesture.state == .cancelled){
            gesture.setTranslation(CGPoint.zero, in: self)
        }
    }
    @objc func fireGestureRecognized(_ gesture: FireGesture) {
        if let character = mainCharacter {
            let position = gesture.touchPosition
            var hitResults:[SCNHitTestResult] = []
            hitResults = self.hitTest(position,
                                      options:[SCNHitTestOption.searchMode : 0,
                                               SCNHitTestOption.categoryBitMask : 2])
            var surfaceLocation:SCNVector3?
            for r in hitResults {
                surfaceLocation = r.worldCoordinates
            }
            if let destination = surfaceLocation {
                character.throwTomato(destination)
            }else if let camera = cameraNode {
                let startPoint = SCNVector3(x: camera.presentation.worldTransform.m41,
                                            y: camera.presentation.worldTransform.m42,
                                            z: camera.presentation.worldTransform.m43)
                var destination = character.presentation.position
                let delta = SCNVector3(x: destination.x - startPoint.x, y: 0,
                                       z: destination.z - startPoint.z)
                destination.x += delta.x*10
                destination.z += delta.z*10
                character.throwTomato(destination)
            }
        }
    }
}
