import Foundation
import SpriteKit
import SceneKit
var characterAnimationNames:[String] = []
var characterAnimations:[[CAAnimation]] = []
func loadAnimation(_ name:String){
    for i in 0..<characterAnimationNames.count {
        if(name == characterAnimationNames[i]) {
            return
        }
    }
    let file = Bundle.main.url(forResource: "Game.scnassets/Animations/\(name)",
        withExtension: "dae")
    let source = SCNSceneSource(url: file!, options: nil)
    let animationIDs = source?.identifiersOfEntries(withClass: CAAnimation.self)
    var animationArray:[CAAnimation] = []
    for id in animationIDs!{
        let animation = source!.entryWithIdentifier(id, withClass: CAAnimation.self)!
        if(animation.duration > 0){
            animation.isRemovedOnCompletion = false
            animationArray.append(animation)
        }
    }
    characterAnimationNames.append(name)
    characterAnimations.append(animationArray)
}
func getAnimation(_ name:String)->([CAAnimation]) {
    for i in 0..<characterAnimationNames.count {
        if(name == characterAnimationNames[i]) {
            return(characterAnimations[i])
        }
    }
    return([])
}
