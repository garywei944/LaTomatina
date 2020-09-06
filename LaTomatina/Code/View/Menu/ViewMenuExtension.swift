import Foundation
import QuartzCore
import SceneKit
import SpriteKit
extension ViewClass {
    func initializeAppearanceButtons() {
        if let scene = menuScene {
            let name = scene.rootNode.childNode(withName:"Name",
                                                recursively:false)!
            if let text = name.geometry as? SCNText {
                text.string = player.name
            }
            if(isMainCharacterMale() == false) {
                if(true) {
                    let name = scene.rootNode.childNode(withName:"Sex",
                                                        recursively:false)!
                    if let text2 = name.geometry as? SCNText {
                        text2.string = "Female"
                    }
                }
                if(true) {
                    let name = scene.rootNode.childNode(withName:"Face",
                                                        recursively:false)!
                    if let text2 = name.geometry as? SCNText {
                        text2.string = "Face1"
                    }
                }
                if(true) {
                    let name = scene.rootNode.childNode(withName:"Hair",
                                                        recursively:false)!
                    if let text2 = name.geometry as? SCNText {
                        text2.string = "Hair1"
                    }
                }
                if(true) {
                    let name = scene.rootNode.childNode(withName:"Top",
                                                        recursively:false)!
                    if let text2 = name.geometry as? SCNText {
                        text2.string = "Top1"
                    }
                }
                if(true) {
                    let name = scene.rootNode.childNode(withName:"Bottom",
                                                        recursively:false)!
                    if let text2 = name.geometry as? SCNText {
                        text2.string = "Bottom1"
                    }
                }
            }else{
                if(true) {
                    let name = scene.rootNode.childNode(withName:"Sex",
                                                        recursively:false)!
                    if let text2 = name.geometry as? SCNText {
                        text2.string = "Male"
                    }
                }
                if(true) {
                    let name = scene.rootNode.childNode(withName:"Face",
                                                        recursively:false)!
                    if let text2 = name.geometry as? SCNText {
                        text2.string = "Face1"
                    }
                }
                if(true) {
                    let name = scene.rootNode.childNode(withName:"Hair",
                                                        recursively:false)!
                    if let text2 = name.geometry as? SCNText {
                        text2.string = "Hair1"
                    }
                }
                if(true) {
                    let name = scene.rootNode.childNode(withName:"Top",
                                                        recursively:false)!
                    if let text2 = name.geometry as? SCNText {
                        text2.string = "Suit1"
                    }
                }
                if(true) {
                    let name = scene.rootNode.childNode(withName:"Bottom",
                                                        recursively:false)!
                    if let text2 = name.geometry as? SCNText {
                        text2.string = "Texture1"
                    }
                }
            }
        }
    }
    func animateMenuButtonNode() {
        if let button = menuButtonNode {
            let scale:SCNVector3 = button.scale
            button.scale = SCNVector3(x:scale.x*0.9,
                                      y:scale.y*0.9,
                                      z:scale.z*0.9)
            SCNTransaction.animateWithDuration(0.2) {
                button.scale = scale
            }
        }
        menuButtonNode = nil
        lockMenuButton = true
        delayAndRun(0.2,{
            self.lockMenuButton = false
        })
    }
    func isMainCharacterMale()->(Bool) {
        if(player.character.count == 0) {
            return(true)
        }
        if(player.character[0] == 0) {
            return(true)
        }
        return(false)
    }
    func switchCharacterSex() {
        if let scene = menuScene {
            let node = scene.rootNode.childNode(withName:"Sex",
                                                recursively:false)!
            if let text = node.geometry as? SCNText {
                if(isMainCharacterMale() == true) {
                    if let character = mainCharacter {
                        character.prepareFemale()
                    }
                    text.string = "Female"
                    if(true) {
                        let name = scene.rootNode.childNode(withName:"Face",
                                                            recursively:false)!
                        if let text2 = name.geometry as? SCNText {
                            text2.string = "Face1"
                        }
                    }
                    if(true) {
                        let name = scene.rootNode.childNode(withName:"Hair",
                                                            recursively:false)!
                        if let text2 = name.geometry as? SCNText {
                            text2.string = "Hair1"
                        }
                    }
                    if(true) {
                        let name = scene.rootNode.childNode(withName:"Top",
                                                            recursively:false)!
                        if let text2 = name.geometry as? SCNText {
                            text2.string = "Top1"
                        }
                    }
                    if(true) {
                        let name = scene.rootNode.childNode(withName:"Bottom",
                                                            recursively:false)!
                        if let text2 = name.geometry as? SCNText {
                            text2.string = "Bottom1"
                        }
                    }
                }else{
                    if let character = mainCharacter {
                        character.prepareMale()
                    }
                    text.string = "Male"
                    if(true) {
                        let name = scene.rootNode.childNode(withName:"Face",
                                                            recursively:false)!
                        if let text2 = name.geometry as? SCNText {
                            text2.string = "Face1"
                        }
                    }
                    if(true) {
                        let name = scene.rootNode.childNode(withName:"Hair",
                                                            recursively:false)!
                        if let text2 = name.geometry as? SCNText {
                            text2.string = "Hair1"
                        }
                    }
                    if(true) {
                        let name = scene.rootNode.childNode(withName:"Top",
                                                            recursively:false)!
                        if let text2 = name.geometry as? SCNText {
                            text2.string = "Suit1"
                        }
                    }
                    if(true) {
                        let name = scene.rootNode.childNode(withName:"Bottom",
                                                            recursively:false)!
                        if let text2 = name.geometry as? SCNText {
                            text2.string = "Texture1"
                        }
                    }
                }
            }
        }
    }
    func preFace() {
        if let scene = menuScene {
            let node = scene.rootNode.childNode(withName:"Face",
                                                recursively:false)!
            if let text = node.geometry as? SCNText {
                if(isMainCharacterMale() == true) {
                    player.character[1] -= 1
                    if let character = mainCharacter {
                        if(player.character[1] < 1) {
                            player.character[1] = character.nodes[0].count-1
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Face\(player.character[1])"
                }else{
                    player.character[1] -= 1
                    if let character = mainCharacter {
                        if(player.character[1] < 1) {
                            player.character[1] = character.nodes[5].count-1
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Face\(player.character[1])"
                }
            }
        }
    }
    func nextFace() {
        if let scene = menuScene {
            let node = scene.rootNode.childNode(withName:"Face",
                                                recursively:false)!
            if let text = node.geometry as? SCNText {
                if(isMainCharacterMale() == true) {
                    player.character[1] += 1
                    if let character = mainCharacter {
                        if(player.character[1] > character.nodes[0].count-1) {
                            player.character[1] = 1
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Face\(player.character[1])"
                }else{
                    player.character[1] += 1
                    if let character = mainCharacter {
                        if(player.character[1] > character.nodes[5].count-1) {
                            player.character[1] = 1
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Face\(player.character[1])"
                }
            }
        }
    }
    func preHair() {
        if let scene = menuScene {
            let node = scene.rootNode.childNode(withName:"Hair",
                                                recursively:false)!
            if let text = node.geometry as? SCNText {
                if(isMainCharacterMale() == true) {
                    player.character[2] -= 1
                    if let character = mainCharacter {
                        if(player.character[2] < 0) {
                            player.character[2] = character.nodes[1].count-1
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Hair\(player.character[2]+1)"
                }else{
                    player.character[2] -= 1
                    if let character = mainCharacter {
                        if(player.character[2] < 1) {
                            player.character[2] = character.nodes[6].count-1
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Hair\(player.character[2])"
                }
            }
        }
    }
    func nextHair() {
        if let scene = menuScene {
            let node = scene.rootNode.childNode(withName:"Hair",
                                                recursively:false)!
            if let text = node.geometry as? SCNText {
                if(isMainCharacterMale() == true) {
                    player.character[2] += 1
                    if let character = mainCharacter {
                        if(player.character[2] > character.nodes[1].count-1) {
                            player.character[2] = 0
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Hair\(player.character[2]+1)"
                }else{
                    player.character[2] += 1
                    if let character = mainCharacter {
                        if(player.character[2] > character.nodes[6].count-1) {
                            player.character[2] = 1
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Hair\(player.character[2])"
                }
            }
        }
    }
    func preTop() {
        if let scene = menuScene {
            let node = scene.rootNode.childNode(withName:"Top",
                                                recursively:false)!
            if let text = node.geometry as? SCNText {
                if(isMainCharacterMale() == true) {
                    player.character[3] -= 1
                    if let character = mainCharacter {
                        if(player.character[3] < 1) {
                            player.character[3] = character.nodes[3].count + character.nodes[3].count - 1
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Suit\(player.character[3])"
                }else{
                    player.character[3] -= 1
                    if let character = mainCharacter {
                        if(player.character[3] < 1) {
                            player.character[3] = character.nodes[7].count-1
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Top\(player.character[3])"
                }
            }
        }
    }
    func nextTop() {
        if let scene = menuScene {
            let node = scene.rootNode.childNode(withName:"Top",
                                                recursively:false)!
            if let text = node.geometry as? SCNText {
                if(isMainCharacterMale() == true) {
                    player.character[3] += 1
                    if let character = mainCharacter {
                        if(player.character[3] > character.nodes[3].count + character.nodes[3].count - 1) {
                            player.character[3] = 1
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Suit\(player.character[3])"
                }else{
                    player.character[3] += 1
                    if let character = mainCharacter {
                        if(player.character[3] > character.nodes[7].count-1) {
                            player.character[3] = 1
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Top\(player.character[3])"
                }
            }
        }
    }
    func preBottom() {
        if let scene = menuScene {
            let node = scene.rootNode.childNode(withName:"Bottom",
                                                recursively:false)!
            if let text = node.geometry as? SCNText {
                if(isMainCharacterMale() == true) {
                    player.character[5] -= 1
                    if(player.character[5] == 4) {
                        player.character[5] -= 1
                    }
                    if(player.character[5] < 1) {
                        player.character[5] = 6
                    }
                    if let character = mainCharacter {
                        character.realizeForMenu()
                    }
                    var number:Int = player.character[5]
                    if(number > 4) {
                        number -= 1
                    }
                    text.string = "Texture\(number)"
                }else{
                    player.character[4] -= 1
                    if let character = mainCharacter {
                        if(player.character[4] < 1) {
                            player.character[4] = character.nodes[8].count-1
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Bottom\(player.character[4])"
                }
            }
        }
    }
    func nextBottom() {
        if let scene = menuScene {
            let node = scene.rootNode.childNode(withName:"Bottom",
                                                recursively:false)!
            if let text = node.geometry as? SCNText {
                if(isMainCharacterMale() == true) {
                    player.character[5] += 1
                    if(player.character[5] == 4) {
                        player.character[5] += 1
                    }
                    if(player.character[5] > 6) {
                        player.character[5] = 1
                    }
                    if let character = mainCharacter {
                        character.realizeForMenu()
                    }
                    var number:Int = player.character[5]
                    if(number > 4) {
                        number -= 1
                    }
                    text.string = "Texture\(number)"
                }else{
                    player.character[4] += 1
                    if let character = mainCharacter {
                        if(player.character[4] > character.nodes[8].count-1) {
                            player.character[4] = 1
                        }
                        character.realizeForMenu()
                    }
                    text.string = "Bottom\(player.character[4])"
                }
            }
        }
    }
}


