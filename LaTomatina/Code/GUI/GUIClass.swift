import QuartzCore
import SceneKit
import SpriteKit
import AVFoundation
var mainGUI:GUIClass?
class GUIClass: SKScene {
    var midPoint = CGPoint()
    var blackness = SKSpriteNode(imageNamed: "Blackness")
    var loadingPot = SKSpriteNode()
    var intendedLoadingPotTextureNumber:Int = 0
    override func didMove(to view: SKView) {
        self.size = self.view!.bounds.size
        self.scaleMode = SKSceneScaleMode.aspectFill
        self.backgroundColor = SKColor.clear
        midPoint = CGPoint(x:self.frame.midX,
                           y:self.frame.midY)
        blackness.size = self.size
        blackness.zPosition = 100
        blackness.position = midPoint
        self.addChild(blackness)
        loadingPot.size = CGSize(width: self.size.height*0.24,
                                 height: self.size.height*0.24)
        loadingPot.zPosition = 120
        loadingPot.position = midPoint
        loadingPot.position.y += self.size.height*0.08
        loadingPot.alpha = 0
        self.addChild(loadingPot)
    }
    func updateLoading(num:Int, fadeIn:Bool, fadeOut:Bool) {
        var textureNumber:Int = num
        if(textureNumber <= 0) {
            textureNumber = 1
        }
        if(fadeIn == true) {
            let action = SKAction.fadeAlpha(to:1, duration:1)
            action.timingMode = .easeOut
            self.loadingPot.run(action)
        }else if(fadeOut == true) {
            let action = SKAction.fadeAlpha(to:0, duration:1)
            action.timingMode = .easeIn
            self.loadingPot.run(action)
        }
        intendedLoadingPotTextureNumber = textureNumber
    }
    func removeBlackness() {
        self.blackness.removeAllActions()
        let action = SKAction.fadeAlpha(to:0, duration:1)
        action.timingMode = .easeIn
        self.blackness.run(action)
    }
    func addBlackness() {
        self.blackness.removeAllActions()
        let action = SKAction.fadeAlpha(to:1, duration:1)
        action.timingMode = .easeOut
        self.blackness.run(action)
    }
    func flashBlack() {
        addBlackness()
        delayAndRun(2,{
            self.removeBlackness()
        })
    }
    override func update(_ currentTime:TimeInterval){
        if(intendedLoadingPotTextureNumber != 0) {
            loadingPot.texture = SKTexture(imageNamed: "LoadingPot\(numToChar(intendedLoadingPotTextureNumber))")
            intendedLoadingPotTextureNumber = 0
        }
    }
}




