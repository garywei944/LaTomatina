import Foundation
import SpriteKit
import SceneKit
extension CharacterClass{
    func loadNodes() {
        loadNode("D_FACE", true) // 0
        loadNode("D_HAIR", true) // 1
        loadNode("D_SUIT", false) // 2
        loadNode("D_SUIT_COMPLETE", true) // 3
        loadNode("D_HANDS", false) // 4
        loadNode("C_FACE", true) // 5
        loadNode("C_HAIR", true) // 6
        loadNode("C_TOP", true) // 7
        loadNode("C_BOTTOM", true) // 8
        hideAll()
    }
    func loadNode(_ i:String, _ addEmptyNode:Bool) {
        var array:[SCNNode] = []
        if(addEmptyNode == true) {
            array.append(SCNNode())
        }
        for node in model.childNodes {
            if(node.name == i) {
                array.append(node)
            }
        }
        nodes.append(array)
    }
    func prepareForMenu() {
        if(player.character.count == 0) {
            prepareMale()
        }else{
            realizeForMenu()
            if(player.character[0] == 0) {
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
    }
    func prepareMale(_ overwrite:Bool = true) {
        if(overwrite == true) {
            player.character = [0, 1, 0, 1, 0, 1]
            write()
        }
        hideAll()
        tomatoMale.isHidden = false
        tomatoFemale.isHidden = true
        neck.isHidden = false
        nodes[0][1].isHidden = false
        nodes[3][1].isHidden = false
        if let material = nodes[4][0].geometry?.firstMaterial {
            material.diffuse.contents = UIImage(named: "Game.scnassets/Characters/Textures/D01.png")
        }
        self.model.removeAnimation(forKey:"FemaleIdleUp")
        self.model.removeAnimation(forKey:"FemaleIdleDown")
        self.act("MaleIdleUp",
                 count:-1,
                 speed:1,
                 fadeIn:0,
                 fadeOut:0)
        self.act("MaleIdleDown",
                 count:-1,
                 speed:1,
                 fadeIn:0,
                 fadeOut:0)
        self.character = player.character
    }
    func prepareFemale(_ overwrite:Bool = true) {
        if(overwrite == true) {
            player.character = [1, 1, 1, 1, 1, 0]
            write()
        }
        hideAll()
        tomatoMale.isHidden = true
        tomatoFemale.isHidden = false
        neck.isHidden = true
        nodes[5][1].isHidden = false
        nodes[6][1].isHidden = false
        nodes[7][1].isHidden = false
        nodes[8][1].isHidden = false
        self.model.removeAnimation(forKey:"MaleIdleUp")
        self.model.removeAnimation(forKey:"MaleIdleDown")
        self.act("FemaleIdleUp",
                 count:-1,
                 speed:1,
                 fadeIn:0,
                 fadeOut:0)
        self.act("FemaleIdleDown",
                 count:-1,
                 speed:1,
                 fadeIn:0,
                 fadeOut:0)
        self.character = player.character
    }
    func hideAll() {
        for array in nodes {
            for node in array {
                node.isHidden = true
            }
        }
    }
    func realizeForMenu() {
        hideAll()
        if(player.character[0] == 0) {
            tomatoMale.isHidden = false
            tomatoFemale.isHidden = true
            neck.isHidden = false
            nodes[0][player.character[1]].isHidden = false
            nodes[1][player.character[2]].isHidden = false
            if(player.character[3] < nodes[3].count) {
                nodes[3][player.character[3]].isHidden = false
                nodes[4][0].isHidden = true
            }else{
                nodes[2][player.character[3]-nodes[3].count].isHidden = false
                nodes[4][0].isHidden = false
            }
            if let material = nodes[4][0].geometry?.firstMaterial {
                material.diffuse.contents = UIImage(named: "Game.scnassets/Characters/Textures/D0\(player.character[5]).png")
            }
        }else{
            tomatoMale.isHidden = true
            tomatoFemale.isHidden = false
            neck.isHidden = true
            nodes[5][player.character[1]].isHidden = false
            nodes[6][player.character[2]].isHidden = false
            nodes[7][player.character[3]].isHidden = false
            nodes[8][player.character[4]].isHidden = false
        }
        write()
        self.character = player.character
    }
}

