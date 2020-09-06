import Foundation
import SpriteKit
import SceneKit
extension CharacterClass{
    func trimModel() {
        for i in 0..<nodes.count {
            if(i == 4){
                continue
            }
            let count = nodes[i].count/2
            for _ in 1...count {
                let n = nodes[i].remove(at: KEInt(nodes[i].count))
                n.removeFromParentNode()
            }
        }
    }
    func hideCharacter() {
        hideAll()
        self.position.y = -100
        if let body = self.physicsBody {
            body.resetTransform()
        }
        self.AIPreparation = 0
    }
    func showCharacter() {
        var array:[SCNVector3] = []
        var xi:Float = 0
        var zi:Float = 0
        if let player = mainCharacter {
            xi = convertToCenter(player.presentation.position).x
            zi = convertToCenter(player.presentation.position).z
        }
        array.append(SCNVector3(x:xi+40, y:0, z:zi+40))
        array.append(SCNVector3(x:xi-40, y:0, z:zi+40))
        array.append(SCNVector3(x:xi+40, y:0, z:zi-40))
        array.append(SCNVector3(x:xi-40, y:0, z:zi-40))
        array.append(SCNVector3(x:xi+80, y:0, z:zi))
        array.append(SCNVector3(x:xi-80, y:0, z:zi))
        array.append(SCNVector3(x:xi, y:0, z:zi-80))
        array.append(SCNVector3(x:xi, y:0, z:zi-80))
        self.position = array[KEInt(array.count)]
        if let body = self.physicsBody {
            body.resetTransform()
        }
        self.AIPreparation = 10
    }
    func damageCharacter() {
        for _ in 0...KEInt(10) {
            damaged()
        }
    }
    func randomCharacter() {
        self.character = [0,0,0,0,0,0]
        self.character[0] = KEInt(2)
        if(self.character[0] == 0) {
            neck.isHidden = false
            self.character[1] = KEInt(nodes[0].count-1)+1
            nodes[0][self.character[1]].isHidden = false
            self.character[2] = KEInt(nodes[1].count)
            nodes[1][self.character[2]].isHidden = false
            self.character[3] = KEInt(self.nodes[3].count + self.nodes[3].count - 1) + 1
            if(self.character[3] < nodes[3].count) {
                nodes[3][self.character[3]].isHidden = false
                nodes[4][0].isHidden = true
            }else{
                nodes[2][self.character[3]-nodes[3].count].isHidden = false
                nodes[4][0].isHidden = false
            }
        }else{
            neck.isHidden = true
            self.character[1] = KEInt(nodes[5].count-1)+1
            nodes[5][self.character[1]].isHidden = false
            self.character[2] = KEInt(nodes[6].count-1)+1
            nodes[6][self.character[2]].isHidden = false
            self.character[3] = KEInt(nodes[7].count-1)+1
            nodes[7][self.character[3]].isHidden = false
            self.character[4] = KEInt(nodes[8].count-1)+1
            nodes[8][self.character[4]].isHidden = false
        }
    }
    func animateAI() {
        if(self.character[0] == 0) {
            self.act("MaleIdleDown",
                     count:-1,
                     speed:1,
                     fadeIn:0,
                     fadeOut:0)
            self.act("MaleIdleUp",
                     count:-1,
                     speed:1,
                     fadeIn:0,
                     fadeOut:0)
        }else{
            self.act("FemaleIdleDown",
                     count:-1,
                     speed:1,
                     fadeIn:0,
                     fadeOut:0)
            self.act("FemaleIdleUp",
                     count:-1,
                     speed:1,
                     fadeIn:0,
                     fadeOut:0)
        }
    }
    func walkAI() {
        if let destination = stepDestination {
            var impulse = SCNVector3(
                x: destination.x - self.presentation.position.x, y: 0,
                z: destination.z - self.presentation.position.z
            )
            let length:Float = calculate(impulse, SCNVector3(x:0, y:0, z:0))
            if(throwing == false)||(cancelThrowing == true) {
                let factor:Float = 2/length
                impulse = SCNVector3(
                    x: impulse.x * factor, y: 0,
                    z: impulse.z * factor
                )
                self.physicsBody?.applyForce(impulse, asImpulse: true)
                let facingAngle:CGFloat = CGFloat(Float.pi/2 - atan2(impulse.z,
                                                                     impulse.x))
                let action = SCNAction.rotateTo(x:0.0, y:facingAngle, z:0.0,
                                                duration: 0.4,
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
        }else if let destination = AIDestination {
            var impulse = SCNVector3(
                x: destination.x - self.presentation.position.x, y: 0,
                z: destination.z - self.presentation.position.z
            )
            let length:Float = calculate(impulse, SCNVector3(x:0, y:0, z:0))
            if(throwing == false)||(cancelThrowing == true) {
                let factor:Float = 2.2/length
                impulse = SCNVector3(
                    x: impulse.x * factor, y: 0,
                    z: impulse.z * factor
                )
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
    func AIManager() {
        let myPosition = self.presentation.position
        if let player = mainCharacter {
            if(calculateII(myPosition,
                           player.presentation.position) > 110) {
                hideCharacter()
            }
        }
        if(fireTimer < currentTime)&&(throwing == false)&&(cancelThrowing == false) {
            fireTimer = currentTime + TimeInterval(KEInt(30))/10.0
            var targetCharacters:[CharacterClass] = []
            if let player = mainCharacter {
                if(calculateII(player.presentation.position,
                               myPosition) < 30) {
                    if(isRouteClear(player.presentation.position) == true) {
                        targetCharacters.append(player)
                    }
                }
            }
            for player in characters {
                if(player == self) {
                    continue
                }
                if(calculateII(player.presentation.position,
                               myPosition) < 30) {
                    if(isRouteClear(player.presentation.position) == true) {
                        targetCharacters.append(player)
                    }
                }
            }
            if(targetCharacters.count > 0) {
                targetCharacters = targetCharacters.sorted() {
                    return($0.hp < $1.hp)
                }
                var i:Int = KEInt(targetCharacters.count)
                if let player = mainCharacter {
                    if(player.hp < 40)&&(KEInt(3) == 0) {
                        i = 0
                    }
                }
                var location = targetCharacters[i].presentation.position
                location.x += KEFr()*Float(5+KEInt(55))/20.0
                location.z += KEFr()*Float(5+KEInt(55))/20.0
                throwTomato(location)
                battleStep()
            }else{
                if(KEInt(2) == 0) {
                    var location = self.presentation.position
                    location.x += KEFr()*Float(10+KEInt(100))/5.0
                    location.z += KEFr()*Float(10+KEInt(100))/5.0
                    throwTomato(location)
                }else{
                    fireTimer = currentTime + 1
                }
            }
        }
        stepManager()
        if let _ = stepDestination {
        }else if let destination = AIDestination {
            if(calculate(destination, myPosition) < 4) {
                self.AIDestination = nil
            }
            if(isRouteClear(destination) == false) {
                self.AIDestination = nil
            }
        }else{
            explore()
        }
    }
    func explore() {
        var array:[SCNVector3] = []
        var xi:Float = 0
        var zi:Float = 0
        xi = convertToCenter(self.presentation.position).x
        zi = convertToCenter(self.presentation.position).z
        if(isRouteClear(SCNVector3(x:xi+40, y:2, z:zi)) == true)&&(calculate(lastAIPosition, SCNVector3(x:xi+40, y:2, z:zi)) > 20) {
            array.append(SCNVector3(x:xi+40, y:2, z:zi))
        }
        if(isRouteClear(SCNVector3(x:xi-40, y:2, z:zi)) == true)&&(calculateII(lastAIPosition, SCNVector3(x:xi+40, y:2, z:zi)) > 20) {
            array.append(SCNVector3(x:xi-40, y:2, z:zi))
        }
        if(isRouteClear(SCNVector3(x:xi, y:2, z:zi-40)) == true)&&(calculateII(lastAIPosition, SCNVector3(x:xi+40, y:2, z:zi)) > 20) {
            array.append(SCNVector3(x:xi, y:2, z:zi-40))
        }
        if(isRouteClear(SCNVector3(x:xi, y:2, z:zi+40)) == true)&&(calculateII(lastAIPosition, SCNVector3(x:xi+40, y:2, z:zi)) > 20) {
            array.append(SCNVector3(x:xi, y:2, z:zi+40))
        }
        if(array.count == 0) {
            xi += KEFr()*Float(5+KEInt(45))/10.0
            zi += KEFr()*Float(5+KEInt(45))/10.0
            self.AIDestination = SCNVector3(x:xi, y:0, z:zi)
            lastAIPosition = SCNVector3(x:xi, y:0, z:zi)
            return
        }
        if let player = mainCharacter {
            array = array.sorted() {
                let distance0 = calculate($0, player.presentation.position)
                let distance1 = calculate($1, player.presentation.position)
                return(distance0 < distance1)
            }
            if(self.hp < 10+KEInt(20)) {
                let index = array.count-1
                var x:Float = array[index].x
                var z:Float = array[index].z
                x += KEFr()*Float(5+KEInt(45))/10.0
                z += KEFr()*Float(5+KEInt(45))/10.0
                self.AIDestination = SCNVector3(x:x, y:0, z:z)
                lastAIPosition = SCNVector3(x:x, y:0, z:z)
            }else{
                let index = KEInt(array.count/2)
                var x:Float = array[index].x
                var z:Float = array[index].z
                x += KEFr()*Float(5+KEInt(45))/10.0
                z += KEFr()*Float(5+KEInt(45))/10.0
                self.AIDestination = SCNVector3(x:x, y:0, z:z)
                lastAIPosition = SCNVector3(x:x, y:0, z:z)
            }
        }
    }
    func battleStep() {
        if let _ = targetItem {
            return
        }
        if(KEInt(2) == 0) {
            return
        }
        for _ in 1...5 {
            var location = self.presentation.position
            location.x += KEFr()*Float(5+KEInt(35))/10.0
            location.z += KEFr()*Float(5+KEInt(35))/10.0
            if(isRouteClear(location) == true) {
                stepTimer = currentTime + TimeInterval(KEInt(45)+5)/10.0
                stepDestination = location
                return
            }
        }
    }
    func stepManager() {
        if let destination = self.stepDestination {
            if(calculateII(destination, self.presentation.position) < 1) {
                self.stepDestination = nil
                return
            }
            if(isRouteClear(destination) == false) {
                self.stepDestination = nil
                return
            }
        }
        if let item = targetItem {
            if(item.state != 1)&&(stepTimer < currentTime) {
                self.targetItem = nil
                stepDestination = nil
            }
        }else if let destination = self.AIDestination {
            var minDistance:Float = 30
            for currentMapNode in currentMapNodes {
                if(currentMapNode.itemPointers.count > 0) {
                    for item in currentMapNode.itemPointers {
                        if(item.state != 1) {
                            continue
                        }
                        let distance = calculateII(item.presentation.position,
                                                   self.presentation.position)
                        if(distance < minDistance) {
                            if(isRouteClear(item.presentation.position) == true) {
                                minDistance = distance
                                targetItem = item
                            }
                        }
                    }
                }
            }
            if let item = targetItem {
                stepDestination = item.presentation.position
                stepTimer = currentTime + TimeInterval(KEInt(45)+5)/5.0
                return
            }
            if(stepTimer < currentTime) {
                var location = getMidPoint(self.presentation.position, destination)
                location.x += KEFr()*Float(5+KEInt(35))/10.0
                location.z += KEFr()*Float(5+KEInt(35))/10.0
                if(isRouteClear(location) == true) {
                    stepTimer = currentTime + TimeInterval(KEInt(45)+5)/5.0
                    stepDestination = location
                }else{
                    stepTimer = currentTime + 0.5
                }
            }
        }
    }
    func isRouteClear(_ d:SCNVector3)->(Bool) {
        if let scene = gameScene {
            var startPoint = self.presentation.position
            startPoint.y = 2
            var destination = d
            destination.y = 2
            let options:[String:Any] = [SCNHitTestOption.categoryBitMask.rawValue:2]
            let results = scene.rootNode.hitTestWithSegment(from: startPoint,
                                                            to: destination,
                                                            options: options)
            for r in results {
                if(r.node.name != "Ground") {
                    return(false)
                }
            }
            return(true)
        }
        return(false)
    }
}




