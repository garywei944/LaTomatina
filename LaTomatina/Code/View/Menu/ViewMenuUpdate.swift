import Foundation
import QuartzCore
import SceneKit
import GameKit
import SpriteKit
var menuMatchingState:String = ""
extension ViewClass {
    func updateMenu(_ time:TimeInterval) {
        if(menuMatchingState != "") {
            if(updateWaitingTime + 0.5 < time) {
                updateWaitingTime = time
                if let scene = menuScene {
                    let name = scene.rootNode.childNode(withName:"Start",
                                                        recursively:true)!
                    if let text = name.geometry as? SCNText {
                        if let textString = text.string as? String {
                            if(textString == " Wait") {
                                text.string = " Wait."
                            }else if(textString == " Wait.") {
                                text.string = " Wait.."
                            }else if(textString == " Wait..") {
                                text.string = " Wait..."
                            }else if(textString == " Wait...") {
                                text.string = " Wait"
                            }
                        }
                    }
                }
            }
        }
        if(menuMatchingState == "RealConnecting") {
            menuMatchingState = "ConnectingWaiting"
            if let scene = menuScene {
                let name = scene.rootNode.childNode(withName:"Title",
                                                    recursively:true)!
                if let text = name.geometry as? SCNText {
                    text.string = "Connecting"
                }
            }
            if let scene = menuScene {
                let name = scene.rootNode.childNode(withName:"Start",
                                                    recursively:true)!
                if let text = name.geometry as? SCNText {
                    text.string = " Wait"
                }
            }
            manager.search(completionHandler: {
                delayAndRun(2+TimeInterval(KEInt(3)),{
                    menuMatchingState = "AskingForID"
                })
            },errorHandler: {
                delayAndRun(2+TimeInterval(KEInt(3)),{
                    menuMatchingState = "GameCenterOff"
                })
            })
            delayAndRun(30, {
                if(menuMatchingState == "ConnectingWaiting") {
                    manager.cancelRequest()
                }
            })
        }
        if(menuMatchingState == "AskingForID") {
            menuMatchingState = "AskingForIDLoop"
            if let scene = menuScene {
                let name = scene.rootNode.childNode(withName:"Title",
                                                    recursively:true)!
                if let text = name.geometry as? SCNText {
                    text.string = "Found Match"
                }
            }
            manager.mapGeneratorData = 10//KEInt(1000000)
            if(UIDevice.current.userInterfaceIdiom == .pad) {
                manager.mapGeneratorData += 1000000
            }
        }
        if(menuMatchingState == "AskingForIDLoop") {
            manager.send(message: "\(manager.mapGeneratorData)", reliable: false)
            
            let array = manager.getMessages()
            
            if(manager.currentMatch!.players.count > 0)&&(manager.playerMapData.count == 0) {
                for p in manager.currentMatch!.players {
                    manager.playerMapData.append((player: p, num: -1))
                }
            }
            if(manager.playerMapData.count > 0) {
                
                for data in array {
                    for i in 0..<manager.playerMapData.count {
                        if(manager.playerMapData[i].player == data.player) {
                            if let j = Int(data.message) {
                                manager.playerMapData[i].num = j
                            }
                        }
                    }
                }
                
                var done:Bool = true
                var great:Int = -1
                for d in manager.playerMapData {
                    if(d.num == -1) {
                        done = false
                    }
                    if(d.num > great) {
                        great = d.num
                    }
                }
                if(great == manager.mapGeneratorData) {
                    manager.mapGeneratorData = KEInt(1000000)
                    if(UIDevice.current.userInterfaceIdiom == .pad) {
                        manager.mapGeneratorData += 1000000
                    }
                }else if(done == true) {
                    if(great < manager.mapGeneratorData) {
                        manager.needGenerateMap = true
                    }else{
                        manager.needGenerateMap = false
                    }
                    print(manager.mapGeneratorData, manager.playerMapData)
                    menuMatchingState = "ExchangeData"
                }
            }
        }
        
        
        
        
        
        if(menuMatchingState == "ExchangeData") {
            let msg:String = "\(player.character[0]) \(player.character[1]) \(player.character[2]) \(player.character[3]) \(player.character[4]) \(player.character[5])"
            manager.send(message: msg, reliable: false)
            
            let array = manager.getMessages()
            
            if(manager.currentMatch!.players.count > 0)&&(manager.playerAppData.count == 0) {
                for p in manager.currentMatch!.players {
                    manager.playerAppData.append((player: p, id: []))
                }
            }
            if(manager.playerMapData.count > 0) {
                
                for data in array {
                    for i in 0..<manager.playerAppData.count {
                        if(manager.playerAppData[i].player == data.player) {
                            
                            let array2 = data.message.components(separatedBy: " ")
                            
                            if(array2.count != 6) {
                                continue
                            }
                            
                            var r:[Int] = []
                            for a in array2 {
                                if let j = Int(a) {
                                    r.append(j)
                                }
                            }
                            manager.playerAppData[i].id = r
                        }
                    }
                }
                
                var done:Bool = true
                for d in manager.playerAppData {
                    if(d.id.count == 0) {
                        done = false
                    }
                }
                if(done == true) {
                    print(player.character, manager.playerAppData)
                    menuMatchingState = "SendData"
                }
            }
        }
        
        
        
        if(menuMatchingState == "SendData") {
            
            
            let array = manager.getMessages()
            
            if(manager.needGenerateMap == true) {
                
                if(manager.playerLocations.count == 0) {
                    
                    var array:[(x: Int, z: Int)] = []
                    array.append((x: 0, z: 20))
                    array.append((x: 0, z: -20))
                    array.append((x: -20, z: 0))
                    array.append((x: 20, z: 0))
                    array.append((x: 0, z: 30))
                    array.append((x: 0, z: -30))
                    array.append((x: 30, z: 0))
                    array.append((x: -30, z: 0))
                    array.append((x: 0, z: 40))
                    array.append((x: 0, z: -40))
                    array.append((x: 40, z: 0))
                    array.append((x: -40, z: 0))
                    manager.myLocation = (x: 0, z: 0)
                    
                    for p in manager.currentMatch!.players {
                        manager.playerLocations.append(array.remove(at: KEInt(array.count)))
                        manager.playerReady.append((player: p, rd: false))
                    }
                    
                }else{
                    for i in 0..<manager.playerReady.count {
                        manager.send(message: "\(manager.playerReady[i].player.playerID) \(manager.playerLocations[i].x) \(manager.playerLocations[i].z)", reliable: true)
                    }
                }
                
                for a in array {
                    for i in 0..<manager.playerReady.count {
                        if(manager.playerReady[i].player == a.player) {
                            if(a.message == "Done") {
                                manager.playerReady[i].rd = true
                            }
                        }
                    }
                }
                
                
                var done:Bool = true
                for d in manager.playerReady {
                    if(d.rd == false) {
                        done = false
                    }
                }
                if(done == true) {
                    print(manager.myLocation, manager.playerLocations)
                    menuMatchingState = "ReadyToEnterGame"
                }
                
            }else{
                
                if(manager.myLocation.x == 0)&&(manager.myLocation.z == 0) {
                    for a in array {
                        let array3 = a.message.components(separatedBy: " ")
                        
                        if(array3.count != 3) {
                            continue
                        }
                        
                        if(array3[0] == GKLocalPlayer.local.playerID) {
                            if let x = Int(array3[1]) {
                                manager.myLocation.x = x
                            }
                            
                            if let z = Int(array3[2]) {
                                manager.myLocation.z = z
                            }
                        }
                        
                    }
                }else{
                    manager.send(message: "Done", reliable: true)
                    print(manager.myLocation, manager.playerLocations)
                    menuMatchingState = "ReadyToEnterGame"
                }
                
                
            }
        }
        
        
        
        
        
        if(menuMatchingState == "ReadyToEnterGame") {
            menuMatchingState = "GameCenterOnWaiting"
            if let scene = menuScene {
                let name = scene.rootNode.childNode(withName:"Title",
                                                    recursively:true)!
                if let text = name.geometry as? SCNText {
                    text.string = "Online Mode"
                }
            }
            delayAndRun(2+TimeInterval(KEInt(3)),{
                menuMatchingState = "Prepare"
            })
        }
        
        
        
        
        
        
        
        
        if(menuMatchingState == "GameCenterOff") {
            menuMatchingState = "GameCenterOffWaiting"
            if let scene = menuScene {
                let name = scene.rootNode.childNode(withName:"Title",
                                                    recursively:true)!
                if let text = name.geometry as? SCNText {
                    text.string = "Offline Mode"
                }
            }
            delayAndRun(2+TimeInterval(KEInt(3)),{
                menuMatchingState = "Prepare"
            })
        }
        if(menuMatchingState == "Prepare") {
            menuMatchingState = "PrepareWaiting"
            if let scene = menuScene {
                let name = scene.rootNode.childNode(withName:"Title",
                                                    recursively:true)!
                if let text = name.geometry as? SCNText {
                    text.string = "Entering"
                }
            }
            delayAndRun(2,{
                if let GUI = mainGUI {
                    GUI.addBlackness()
                }
            })
            delayAndRun(3,{
                self.startLoadingGame()
            })
        }
        if(pressedMenuButtonName != "") {
            animateMenuButtonNode()
            if(pressedMenuButtonName == "Edit Name") {
                delayAndRun(0.2,{
                    presentTextInput()
                })
            }else if(pressedMenuButtonName == "Start") {
                if(player.name == "--") {
                    delayAndRun(0.2,{
                        presentMessage("You probably want to give yourself a name for the game. Please swipe to move the camera to the right and tap \"Edit Name \" to name your character. Also, you can change your character's appearance in the rightmost menu.", "OK.")
                    })
                }else{
                    manager.authorize(completionHandler: {
                        menuMatchingState = "RealConnecting"
                    }, errorHandler: {
                    }, recoverHandler: {
                        menuMatchingState = "RealConnecting"
                    })
                    menuMatchingState = "Connecting"
                    /*
                    lockAllInteraction = true
                    lockMenuButton = true
                    if let GUI = mainGUI {
                        GUI.addBlackness()
                    }
                    delayAndRun(1,{
                        self.startLoadingGame()
                    })*/
                }
            }else if(pressedMenuButtonName == "Ant") {
                lockAllInteraction = true
                if let GUI = mainGUI {
                    GUI.flashBlack()
                }
                if let scene = menuScene {
                    let name = scene.rootNode.childNode(withName:"Ant",
                                                        recursively:true)!
                    if let text = name.geometry as? SCNText {
                        if(player.ant == true) {
                            player.ant = false
                            write()
                            text.string = "Anti-аliasing : off"
                            delayAndRun(1.2,{
                                lockAllInteraction = false
                                self.antialiasingMode = .none
                            })
                        }else{
                            player.ant = true
                            write()
                            text.string = "Anti-аliasing : on"
                            delayAndRun(1.2,{
                                lockAllInteraction = false
                                self.antialiasingMode = .multisampling2X
                            })
                        }
                    }
                }
            }else if(pressedMenuButtonName == "Lit") {
                lockAllInteraction = true
                if let GUI = mainGUI {
                    GUI.flashBlack()
                }
                if let scene = menuScene {
                    let name = scene.rootNode.childNode(withName:"Lit",
                                                        recursively:true)!
                    if let text = name.geometry as? SCNText {
                        if(player.lit == true) {
                            player.lit = false
                            write()
                            text.string = "Lighting Mode : Cartoon"
                            delayAndRun(1.2,{
                                lockAllInteraction = false
                                let lightCrew = scene.rootNode.childNode(withName:"Light",
                                                                         recursively:false)!
                                lightCrew.isHidden = true
                            })
                        }else{
                            player.lit = true
                            write()
                            text.string = "Lighting Mode : Realistic"
                            delayAndRun(1.2,{
                                lockAllInteraction = false
                                let lightCrew = scene.rootNode.childNode(withName:"Light",
                                                                         recursively:false)!
                                lightCrew.isHidden = false
                            })
                        }
                    }
                }
            }else if(pressedMenuButtonName == "Son") {
                if(player.son == true) {
                    player.son = false
                    write()
                    if let scene = menuScene {
                        let name = scene.rootNode.childNode(withName:"Son",
                                                            recursively:true)!
                        if let text = name.geometry as? SCNText {
                            text.string = "3D Sound Effect : off"
                        }
                    }
                }else{
                    player.son = true
                    write()
                    if let scene = menuScene {
                        let name = scene.rootNode.childNode(withName:"Son",
                                                            recursively:true)!
                        if let text = name.geometry as? SCNText {
                            text.string = "3D Sound Effect : on"
                        }
                    }
                }
            }else if(pressedMenuButtonName == "Spa") {
                if(player.spa == true) {
                    player.spa = false
                    write()
                    if let scene = menuScene {
                        let name = scene.rootNode.childNode(withName:"Spa",
                                                            recursively:true)!
                        if let text = name.geometry as? SCNText {
                            text.string = "Low Space Mode : on"
                        }
                    }
                }else{
                    player.spa = true
                    write()
                    if let scene = menuScene {
                        let name = scene.rootNode.childNode(withName:"Spa",
                                                            recursively:true)!
                        if let text = name.geometry as? SCNText {
                            text.string = "Low Space Mode : off"
                        }
                    }
                }
            }
            pressedMenuButtonName = ""
        }
        if(player.needUpdateName == true) {
            if let scene = menuScene {
                let name = scene.rootNode.childNode(withName:"Name",
                                                    recursively:false)!
                if let text = name.geometry as? SCNText {
                    text.string = player.name
                }
            }
            player.needUpdateName = false
        }
        if(preMenuName != "") {
            animateMenuButtonNode()
            if(preMenuName == "Sex") {
                switchCharacterSex()
            }else if(preMenuName == "Face") {
                preFace()
            }else if(preMenuName == "Hair") {
                preHair()
            }else if(preMenuName == "Top") {
                preTop()
            }else if(preMenuName == "Bottom") {
                preBottom()
            }
            preMenuName = ""
        }
        if(nextMenuName != "") {
            animateMenuButtonNode()
            if(nextMenuName == "Sex") {
                switchCharacterSex()
            }else if(nextMenuName == "Face") {
                nextFace()
            }else if(nextMenuName == "Hair") {
                nextHair()
            }else if(nextMenuName == "Top") {
                nextTop()
            }else if(nextMenuName == "Bottom") {
                nextBottom()
            }
            nextMenuName = ""
        }
    }
}

