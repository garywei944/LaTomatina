import Foundation
import QuartzCore
import SceneKit
import SpriteKit
var mainView:ViewClass?
let emptyScene = SCNScene()
var menuScene:SCNScene?
var gameScene:SCNScene?
enum SceneState {
    case nothing
    case menu
    case game
}
var moveTranslation = CGPoint.zero
var splashs:[SCNNode] = []
var splashEffects:[SCNParticleSystem] = []
var currentSplash:Int = 0
var collects:[SCNNode] = []
var collectEffects:[SCNParticleSystem] = []
var currentCollect:Int = 0
var buildingDyeStart:[SCNVector3] = []
var buildingDyeEnd:[SCNVector3] = []
var roadDye:[SCNVector3] = []
class ViewClass: SCNView, SCNSceneRendererDelegate, UIGestureRecognizerDelegate, SCNPhysicsContactDelegate {
    var state:SceneState = .nothing
    var loadingProgress:Int = 1
    var touchesMoved:Bool = false
    var pressedMenuButtonName:String = ""
    var preMenuName:String = ""
    var nextMenuName:String = ""
    var menuButtonNode:SCNNode?
    var lockMenuButton:Bool = false
    var updateWaitingTime:TimeInterval = 0
    var movePadOrigion:CGPoint?
    var cameraNode:SCNNode?
    var cameraLead:SCNNode?
    var cameraControl:SCNNode?
    var buildingTarget:SCNNode?
    var cameraDetections:[SCNNode] = []
    func initialize() {
        self.scene = emptyScene
        if(player.ant == true) {
            self.antialiasingMode = .multisampling2X
        }else{
            self.antialiasingMode = .none
        }
        //self.debugOptions = [.showPhysicsShapes]
        self.showsStatistics = false//true//false
        self.backgroundColor = UIColor.black
        self.delegate = self
        mainGUI = GUIClass()
        if let GUI = mainGUI {
            self.overlaySKScene = GUI
        }
        delayAndRun(0.5,{
            //self.developerQuickPass()
            self.startLoadingMainMenu()
        })
        lookGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewClass.lookGestureRecognized(_:)))
        lookGesture.delegate = self
        lookGesture.isEnabled = false
        lookGesture.delaysTouchesBegan = false
        lookGesture.delaysTouchesEnded = false
        self.addGestureRecognizer(lookGesture)
        walkGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewClass.walkGestureRecognized(_:)))
        walkGesture.delegate = self
        walkGesture.isEnabled = false
        walkGesture.delaysTouchesBegan = false
        walkGesture.delaysTouchesEnded = false
        self.addGestureRecognizer(walkGesture)
        fireGesture = FireGesture(target: self, action: #selector(ViewClass.fireGestureRecognized(_:)))
        fireGesture.delegate = self
        fireGesture.isEnabled = false
        fireGesture.delaysTouchesBegan = false
        fireGesture.delaysTouchesEnded = false
        self.addGestureRecognizer(fireGesture)
    }
}
