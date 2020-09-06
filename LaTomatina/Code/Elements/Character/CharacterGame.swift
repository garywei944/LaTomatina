import Foundation
import SpriteKit
import SceneKit
import GameKit
extension CharacterClass{
    func prepareForGameAsPlayer(player: GKPlayer, id: [Int]) {
        
        self.targetPlayer = player
        self.character = id
        
        self.position.y = -100
        self.hp = 100
        let PBG = SCNCylinder(radius: 0.7, height: 5)
        self.physicsBody = SCNPhysicsBody(type: .dynamic,
                                          shape: SCNPhysicsShape(geometry: PBG,
                                                                 options: nil))
        self.physicsBody?.damping = 0.9999999
        self.physicsBody?.rollingFriction = 0
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 0
        self.physicsBody?.angularVelocityFactor = SCNVector3(x: 0, y:0, z:0)
        self.physicsBody?.velocityFactor = SCNVector3(x: 1, y:0, z:1)
        self.physicsBody?.categoryBitMask = ElementBitMask.Others
        self.physicsBody?.collisionBitMask = ElementBitMask.Player | ElementBitMask.Object | ElementBitMask.Tomato
        self.physicsBody?.contactTestBitMask = ElementBitMask.Tomato
        
        
        splashTexture = createSplashTexture()
        
        
        hideAll()
        if(id[0] == 0) {
            tomatoMale.isHidden = false
            tomatoFemale.isHidden = true
            neck.isHidden = false
            nodes[0][id[1]].isHidden = false
            nodes[1][id[2]].isHidden = false
            if(id[3] < nodes[3].count) {
                nodes[3][id[3]].isHidden = false
                nodes[4][0].isHidden = true
            }else{
                nodes[2][id[3]-nodes[3].count].isHidden = false
                nodes[4][0].isHidden = false
            }
            if let material = nodes[4][0].geometry?.firstMaterial {
                material.diffuse.contents = UIImage(named: "Game.scnassets/Characters/Textures/D0\(id[5]).png")
            }
        }else{
            tomatoMale.isHidden = true
            tomatoFemale.isHidden = false
            neck.isHidden = true
            nodes[5][id[1]].isHidden = false
            nodes[6][id[2]].isHidden = false
            nodes[7][id[3]].isHidden = false
            nodes[8][id[4]].isHidden = false
        }
        
        setUpSplashTextureLayer()
        animateAI()
        
        
        for i in 0..<manager.playerReady.count {
            if(manager.playerReady[i].player == player) {
                self.position.x = 0//Float(manager.playerLocations[i].x)
                self.position.y = 0
                self.position.z = 0//Float(manager.playerLocations[i].z)
            }
        }
        
        self.position.x = 0//Float(manager.playerLocations[i].x)
        self.position.y = 0
        self.position.z = 0//Float(manager.playerLocations[i].z)
        
        if let body = self.physicsBody {
            body.resetTransform()
        }
        self.AIPreparation = 10
    }
    func prepareForGame(_ textureIndex:Int) {
        self.position.y = -100
        self.hp = 100
        let PBG = SCNCylinder(radius: 0.7, height: 5)
        self.physicsBody = SCNPhysicsBody(type: .dynamic,
                                          shape: SCNPhysicsShape(geometry: PBG,
                                                                 options: nil))
        self.physicsBody?.damping = 0.9999999
        self.physicsBody?.rollingFriction = 0
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 0
        self.physicsBody?.angularVelocityFactor = SCNVector3(x: 0, y:0, z:0)
        self.physicsBody?.velocityFactor = SCNVector3(x: 1, y:0, z:1)
        self.physicsBody?.categoryBitMask = ElementBitMask.Others
        self.physicsBody?.collisionBitMask = ElementBitMask.Player | ElementBitMask.Object | ElementBitMask.Tomato
        self.physicsBody?.contactTestBitMask = ElementBitMask.Tomato
        var index:Int = textureIndex
        if(index > 5) {
            index = KEInt(5)+1
        }
        if(index >= 4) {
            index += 1
        }
        if let material = nodes[4][0].geometry?.firstMaterial {
            material.diffuse.contents = UIImage(named: "Game.scnassets/Characters/Textures/D0\(index).png")
        }
        splashTexture = createSplashTexture()
        trimModel()
        randomCharacter()
        setUpSplashTextureLayer()
        animateAI()
    }
    func update(_ isAI:Bool = false) {
        if(self.targetPlayer != nil) {
            walkAI()
        }else if(isAI == true) {
            if(AIPreparation == 0) {
                print("Escaped")
                self.hp = 100
                AIPreparation = 1
                randomCharacter()
                return
            }else if(AIPreparation == 1) {
                AIPreparation = 2
                setUpSplashTextureLayer()
                return
            }else if(AIPreparation == 2) {
                AIPreparation = 3
                damageCharacter()
                return
            }else if(AIPreparation == 3) {
                AIPreparation = 4
                showCharacter()
                return
            }
            walkAI()
            AIManager()
        }else{
            walk()
        }
        if(throwing == true)&&(cancelThrowing == false) {
            let delta = SCNVector3(x:throwingDestination.x-self.presentation.position.x, y:0,
                                   z:throwingDestination.z-self.presentation.position.z)
            let angle = Float.pi/2 - atan2(delta.z, delta.x)
            let action = SCNAction.rotateTo(x:0.0, y:CGFloat(angle), z:0.0,
                                            duration: 0.2,
                                            usesShortestUnitArc: true)
            model.runAction(action)
        }
    }
    func preparePlayerForGame() {
        tomatoMale.isHidden = true
        tomatoFemale.isHidden = true
        let PBG = SCNCylinder(radius: 0.7, height: 5)
        self.physicsBody = SCNPhysicsBody(type: .dynamic,
                                          shape: SCNPhysicsShape(geometry: PBG,
                                                                 options: nil))
        self.physicsBody?.damping = 0.9999999
        self.physicsBody?.rollingFriction = 0
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 0
        self.physicsBody?.angularVelocityFactor = SCNVector3(x: 0, y:0, z:0)
        self.physicsBody?.velocityFactor = SCNVector3(x: 1, y:0, z:1)
        self.physicsBody?.categoryBitMask = ElementBitMask.Player
        self.physicsBody?.collisionBitMask = ElementBitMask.Others | ElementBitMask.Object | ElementBitMask.Tomato
        self.physicsBody?.contactTestBitMask = ElementBitMask.Tomato
        setUpSplashTextureLayer()
    }
    func walk() {
        if let view = mainView {
            if let control = view.cameraControl {
                let translation = walkGesture.translation(in: view)
                if(translation.x == 0)&&(translation.y == 0) {
                    if(isRunning == true) {
                        isRunning = false
                        stopRunningAnimation()
                    }
                    return
                }
                let angle:Float = control.eulerAngles.y
                var impulse = SCNVector3(
                    x: Float(translation.x)*0.02, y: 0,
                    z: Float(-translation.y)*0.02
                )
                impulse = SCNVector3(
                    x: max(-1, min(1, impulse.x)), y: 0,
                    z: max(-1, min(1, impulse.z))
                )
                impulse = SCNVector3(
                    x: impulse.x * cos(angle) - impulse.z * sin(angle), y: 0,
                    z: impulse.x * -sin(angle) - impulse.z * cos(angle)
                )
                impulse = SCNVector3(x: -impulse.x*2, y: 0, z: -impulse.z*2)
                let length:Float = calculate(impulse, SCNVector3(x:0, y:0, z:0))
                if(throwing == false)||(cancelThrowing == true) {
                    if(length < 2) {
                        let factor:Float = 2/length
                        impulse = SCNVector3(
                            x: impulse.x * factor, y: 0,
                            z: impulse.z * factor
                        )
                    }
                    self.physicsBody?.applyForce(impulse, asImpulse: true)
                    let facingAngle:CGFloat = CGFloat(Float.pi/2 - atan2(impulse.z,
                                                                         impulse.x))
                    let action = SCNAction.rotateTo(x:0.0, y:facingAngle, z:0.0,
                                                    duration: 0.2,
                                                    usesShortestUnitArc: true)
                    model.runAction(action)
                }else{
                    if(length > 1.5) {
                        let factor:Float = 1.5/length
                        impulse = SCNVector3(
                            x: impulse.x * factor, y: 0,
                            z: impulse.z * factor
                        )
                    }
                    self.physicsBody?.applyForce(impulse, asImpulse: true)
                }
                if(isRunning == false) {
                    isRunning = true
                    startRunningAnimation()
                }
            }
        }
    }
    func throwTomato(_ destination: SCNVector3) {
        if(throwing == true)||(cancelThrowing == true) {
            return
        }
        if(self.character[0] == 0) {
            self.tomatoMale.isHidden = false
        }else{
            self.tomatoFemale.isHidden = false
        }
        throwingDestination = destination
        throwing = true
        self.throwAnimation()
        var time:TimeInterval = 0
        if(self.character[0] == 0) {
            time = 0.3
        }else{
            time = 0.27
        }
        delayAndRun(time, {
            if(self.cancelThrowing == false)&&(self.cancelThrowing == false) {
                self.fireTomato()
            }
        })
        delayAndRun(0.7, {
            self.throwing = false
        })
    }
    func setUpSplashTextureLayer() {
        displayingNodes.removeAll()
        recreateSplashTexture()
        for array in nodes {
            for node in array {
                if(node.isHidden == false) {
                    if let geometry = node.geometry {
                        if let material = geometry.firstMaterial {
                            material.multiply.contents = splashTexture
                        }
                    }
                    displayingNodes.append(node)
                }
            }
        }
    }
    func createSplashTexture()->(UIImage) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40,
                                                            height: 20))
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            let rectangle = CGRect(x: 0, y: 0,
                                   width: 40, height: 20)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
        }
        return(img)
    }
    func damaged() {
        self.hp -= 5
        dye()
        if(self.isMain == false) {
            battleStep()
        }
    }
    func recreateSplashTexture() {
        UIGraphicsBeginImageContext(CGSize(width: 40, height: 20))
        if let context = UIGraphicsGetCurrentContext() {
            splashTexture.draw(in: CGRect(x: 0, y: 0,
                                          width: 40,
                                          height: 20))
            context.setFillColor(UIColor.white.cgColor)
            let rectangle = CGRect(x: 0, y: 0,
                                   width: 40, height: 20)
            context.addRect(rectangle)
            context.drawPath(using: .fill)
            splashTexture = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            for node in displayingNodes {
                if let geometry = node.geometry {
                    if let material = geometry.firstMaterial {
                        material.multiply.contents = splashTexture
                    }
                }
            }
        }
    }
    func dye() {
        UIGraphicsBeginImageContext(CGSize(width: 40, height: 20))
        if let context = UIGraphicsGetCurrentContext() {
            splashTexture.draw(in: CGRect(x: 0, y: 0,
                                          width: 40,
                                          height: 20))
            let tomatoColor = UIColor(red:200.0/256.0,
                                      green:20.0/256.0,
                                      blue:40.0/256.0,
                                      alpha:1)
            context.setFillColor(tomatoColor.cgColor)
            for _ in 0...5 {
                let location = CGPoint(x: KECGFloat(40), y: KECGFloat(20))
                let rectangle = CGRect(x: location.x,
                                       y: location.y,
                                       width: 2, height: 2)
                context.addRect(rectangle)
            }
            context.drawPath(using: .fill)
            splashTexture = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            for node in displayingNodes {
                if let geometry = node.geometry {
                    if let material = geometry.firstMaterial {
                        material.multiply.contents = splashTexture
                    }
                }
            }
        }
    }
}



