import Foundation
import QuartzCore
import SceneKit
import SpriteKit
extension ViewClass {
    func startLoadingMainMenu() {
        self.state = .nothing
        loadingProgress = 1
        if let GUI = mainGUI {
            GUI.updateLoading(num:1, fadeIn:true, fadeOut:false)
        }
        delayAndRun(1,{
            self.loadMainMenu()
        })
    }
    @objc func loadMainMenu() {
        switch(loadingProgress) {
        case 1:
            if let scene = gameScene {
                scene.physicsWorld.contactDelegate = nil
                // clear game scene #1
                lookGesture.isEnabled = false
                walkGesture.isEnabled = false
                fireGesture.isEnabled = false
                if let character = mainCharacter {
                    character.model.removeAllAnimations()
                }
            }else{
                loadAnimation("MaleIdleUp")
                loadAnimation("MaleIdleDown")
                loadAnimation("FemaleIdleUp")
                loadAnimation("FemaleIdleDown")
            }
            break
        case 2:
            if let _ = gameScene {
                freeItems()
                freeTomatos()
                // clear game scene #2
            }else{
                loadAnimation("MaleRunTomatoUp")
                loadAnimation("MaleRunTomatoDown")
                loadAnimation("FemaleRunTomatoUp")
                loadAnimation("FemaleRunTomatoDown")
                loadAnimation("MaleThrowUp")
                loadAnimation("FemaleThrowUp")
            }
            break
        case 3:
            if let _ = gameScene {
                // clear game scene #3
            }else{
                initializeItems()
                initializeTomatos()
            }
            break
        case 4:
            menuScene = SCNScene(named: "Game.scnassets/MenuScene/MenuScene.scn")
            if let scene = menuScene {
                let camera = scene.rootNode.childNode(withName:"Camera",
                                                      recursively:false)!
                menuCameraEulerAngles = camera.eulerAngles
                camera.position.z = menuCameraEulerAngles.y - 0.5
                camera.position.y = 3 - menuCameraEulerAngles.x
                camera.eulerAngles.x -= 1
                self.pointOfView = camera
                if(player.lit == false) {
                    let lightCrew = scene.rootNode.childNode(withName:"Light",
                                                           recursively:false)!
                    lightCrew.isHidden = true
                    let name = scene.rootNode.childNode(withName:"Lit",
                                                        recursively:true)!
                    if let text = name.geometry as? SCNText {
                        text.string = "Lighting Mode : Cartoon"
                    }
                }
                if(player.ant == false) {
                    let name = scene.rootNode.childNode(withName:"Ant",
                                                        recursively:true)!
                    if let text = name.geometry as? SCNText {
                        text.string = "Anti-аliasing : off"
                    }
                }
                if(player.son == false) {
                    let name = scene.rootNode.childNode(withName:"Son",
                                                        recursively:true)!
                    if let text = name.geometry as? SCNText {
                        text.string = "3D Sound Effect : off"
                    }
                }
                if(player.spa == false) {
                    let name = scene.rootNode.childNode(withName:"Spa",
                                                        recursively:true)!
                    if let text = name.geometry as? SCNText {
                        text.string = "Low Space Mode : on"
                    }
                }
            }
            break
        case 5:
            mainCharacter = CharacterClass()
            if let character = mainCharacter, let scene = menuScene {
                character.initialize()
                scene.rootNode.addChildNode(character)
                let characterPosition = scene.rootNode.childNode(withName:"CharacterPosition",
                                                                 recursively:false)!
                character.position = characterPosition.position
                character.eulerAngles = characterPosition.eulerAngles
                character.loadNodes()
                character.prepareMale(false)
            }
            break
        case 6:
            if let scene = menuScene {
                self.scene = scene
            }
            break
        case 7:
            if let character = mainCharacter {
                character.prepareFemale(false)
            }
            if let scene = menuScene {
                let camera = scene.rootNode.childNode(withName:"Camera",
                                                      recursively:false)!
                SCNTransaction.animateWithDuration(0.5) {
                    camera.position.y = 2.5 - menuCameraEulerAngles.x
                    camera.eulerAngles.x += 1
                }
            }
            initializeAppearanceButtons()
            break
        default:
            if let character = mainCharacter {
                character.prepareForMenu()
            }
            if let GUI = mainGUI {
                GUI.updateLoading(num:8, fadeIn:false, fadeOut:true)
            }
            delayAndRun(1,{
                self.state = .menu
                if let GUI = mainGUI {
                    GUI.removeBlackness()
                }
            })
            return
        }
        loadingProgress += 1
        if let GUI = mainGUI {
            GUI.updateLoading(num:loadingProgress,
                              fadeIn:true, fadeOut:false)
        }
        _ = Timer.scheduledTimer(timeInterval: 1,
                                 target: self,
                                 selector: #selector(self.loadMainMenu),
                                 userInfo: nil,
                                 repeats: false)
    }
}
