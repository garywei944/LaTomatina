import Foundation
import QuartzCore
import SceneKit
import SpriteKit
var developerFastPass:Bool = false
extension ViewClass {
    func developerQuickPass() {
        developerFastPass = true
        state = .nothing
        loadingProgress = -3
        if let GUI = mainGUI {
            GUI.updateLoading(num:1, fadeIn:true, fadeOut:false)
        }
        delayAndRun(1,{
            self.loadGame()
        })
    }
    func startLoadingGame() {
        state = .nothing
        lockMenuButton = false
        lockAllInteraction = false
        loadingProgress = 1
        if let GUI = mainGUI {
            GUI.updateLoading(num:1, fadeIn:true, fadeOut:false)
        }
        delayAndRun(1,{
            self.loadGame()
        })
    }
    @objc func loadGame() {
        print(loadingProgress)
        switch(loadingProgress) {
        case -3:
            loadAnimation("MaleIdleUp")
            loadAnimation("MaleIdleDown")
            loadAnimation("FemaleIdleUp")
            loadAnimation("FemaleIdleDown")
            loadAnimation("MaleRunTomatoUp")
            loadAnimation("MaleRunTomatoDown")
            loadAnimation("FemaleRunTomatoUp")
            loadAnimation("FemaleRunTomatoDown")
            loadAnimation("MaleThrowUp")
            loadAnimation("FemaleThrowUp")
            break
        case -2:
            mainCharacter = CharacterClass()
            if let character = mainCharacter {
                character.initialize()
            }
            break
        case -1:
            if let character = mainCharacter {
                character.loadNodes()
            }
            initializeItems()
            initializeTomatos()
            break
        case 0:
            if let character = mainCharacter {
                character.prepareForMenu()
            }
            break
        case 1:
            self.scene = emptyScene
            if let character = mainCharacter {
                character.model.removeAllAnimations()
                character.removeFromParentNode()
            }
            break
        case 2:
            if let scene = menuScene {
                for node in scene.rootNode.childNodes {
                    node.destroy()
                }
            }
            menuScene = nil
            break
        case 3:
            gameScene = SCNScene(named: "Game.scnassets/GameScene/GameScene.scn")
            if let scene = gameScene {
                cameraNode = scene.rootNode.childNode(withName:"Camera",
                                                      recursively: true)!
                cameraLead = scene.rootNode.childNode(withName:"CameraLead",
                                                      recursively: true)!
                cameraControl = scene.rootNode.childNode(withName:"CameraControl",
                                                             recursively: false)!
                buildingTarget = scene.rootNode.childNode(withName:"BuildingTarget",
                                                          recursively: true)!
                if let control = cameraControl {
                    for node in control.childNodes {
                        if(node.name == "CameraDetection") {
                            cameraDetections.append(node)
                        }
                    }
                }
                if let camera = cameraNode {
                    self.pointOfView = camera
                }
                let splashTemplate = scene.rootNode.childNode(withName:"Splash",
                                                              recursively:false)!
                for _ in 0..<40 {
                    let splash = splashTemplate.clone()
                    splashs.append(splash)
                    let splashEffect = splashTemplate.particleSystems![0].copy() as! SCNParticleSystem
                    splash.addParticleSystem(splashEffect)
                    splashEffects.append(splashEffect)
                    scene.rootNode.addChildNode(splash)
                }
                let collectTemplate = scene.rootNode.childNode(withName:"Collect",
                                                               recursively:false)!
                for _ in 0..<10 {
                    let collect = collectTemplate.clone()
                    collects.append(collect)
                    let collectEffect = collectTemplate.particleSystems![0].copy() as! SCNParticleSystem
                    collect.addParticleSystem(collectEffect)
                    collectEffects.append(collectEffect)
                    scene.rootNode.addChildNode(collect)
                }
                if(player.lit == false) {
                    let lightCrew = scene.rootNode.childNode(withName:"Light",
                                                           recursively:false)!
                    lightCrew.isHidden = true
                }
            }
            break
        case 4:
            initializeBuildingData()
            if let scene = gameScene {
                for node in scene.rootNode.childNodes {
                    if(node.name == "Road") {
                        setUpRoad(node)
                    }
                }
                for i in 1...5 {
                    for node in scene.rootNode.childNodes {
                        if(node.name == "Building\(i)") {
                            setUpBuilding(node, i)
                        }
                    }
                    var array:[SCNNode] = []
                    for node in scene.rootNode.childNodes {
                        if(node.name == "BuildingRough\(i)") {
                            node.position.y = -200
                            array.append(node)
                        }
                    }
                    roughBuildingModels.append(array)
                }
            }
            realizeBuildingFromData()
            break
        case 5:
            if let scene = gameScene {
                self.scene = scene
                scene.physicsWorld.contactDelegate = self
            }
            break
        case 6:
            if let scene = gameScene {
                if let character = mainCharacter {
                    scene.rootNode.addChildNode(character)
                    character.eulerAngles = SCNVector3(x:0, y:0, z:0)
                    character.position = SCNVector3(x:0, y:0, z:0)
                    character.preparePlayerForGame()
                }
                if(manager.currentMatch != nil) {
                    for i in 0..<manager.playerAppData.count {
                        let character = CharacterClass()
                        character.initialize()
                        character.loadNodes()
                        scene.rootNode.addChildNode(character)
                        character.eulerAngles = SCNVector3(x:0, y:0, z:0)
                        character.position = SCNVector3(x:0, y:0, z:4*Float(i))
                        //character.prepareForGame(i)
                        character.prepareForGameAsPlayer(player: manager.playerAppData[i].player,
                                                         id: manager.playerAppData[i].id)
                        characters.append(character)
                    }
                }else{
                    for i in 1...10 {
                        let character = CharacterClass()
                        character.initialize()
                        character.loadNodes()
                        scene.rootNode.addChildNode(character)
                        character.eulerAngles = SCNVector3(x:0, y:0, z:0)
                        character.position = SCNVector3(x:0, y:0, z:4*Float(i))
                        character.prepareForGame(i)
                        characters.append(character)
                    }
                }
            }
            break
        case 7:
            if let character = mainCharacter {
                character.isMain = true
                character.startIdle()
            }
            loadItems()
            loadTomatos()
            mapItems()
            break
        default:
            lookGesture.isEnabled = true
            walkGesture.isEnabled = true
            fireGesture.isEnabled = true
            if let GUI = mainGUI {
                GUI.updateLoading(num:8, fadeIn:false, fadeOut:true)
            }
            delayAndRun(1,{
                self.state = .game
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
        if(developerFastPass == true) {
            _ = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(self.loadGame),
                                     userInfo: nil,
                                     repeats: false)
        }else{
            _ = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.loadGame),
                                     userInfo: nil,
                                     repeats: false)
        }
    }
}
