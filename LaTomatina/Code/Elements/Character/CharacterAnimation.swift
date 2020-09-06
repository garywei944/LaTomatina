import Foundation
import SpriteKit
import SceneKit
extension CharacterClass{
    func act(_ name:String,
             count:Float,
             speed:Float,
             fadeIn:CGFloat,
             fadeOut:CGFloat,
             remove:Bool = false,
             animationName:String = "") {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = getAnimation(name)
        animationGroup.repeatCount = count
        animationGroup.duration = animationGroup.animations![0].duration
        animationGroup.speed = speed
        animationGroup.fadeInDuration = fadeIn
        animationGroup.fadeOutDuration = fadeOut
        animationGroup.isRemovedOnCompletion = remove
        if(animationName == "") {
            model.addAnimation(animationGroup, forKey: name)
        }else{
            model.addAnimation(animationGroup, forKey: animationName)
        }
    }
    func startRunningAnimation() {
        self.canCancelRunning = false
        self.model.removeAnimation(forKey:"\(C())RunStartUp")
        self.model.removeAnimation(forKey:"\(C())RunStartDown")
        cancelThrowing = true
        self.act("\(C())RunTomatoUp",
            count:2,
            speed:1,
            fadeIn:0.2,
            fadeOut:0,
            remove: true,
            animationName: "\(C())RunStartUp")
        self.act("\(C())RunTomatoDown",
            count:2,
            speed:1,
            fadeIn:0.2,
            fadeOut:0,
            remove: true,
            animationName: "\(C())RunStartDown")
        delayAndRun(0.6, {
            self.cancelThrowing = false
            if(self.isRunning == true) {
                self.canCancelRunning = true
                if(self.isMain == true) {
                    if let view = mainView {
                        let translation = walkGesture.translation(in: view)
                        if(translation.x == 0)&&(translation.y == 0) {
                            return
                        }
                    }
                }
                self.act("\(self.C())RunTomatoUp",
                    count:-1,
                    speed:1,
                    fadeIn:0,
                    fadeOut:0,
                    animationName: "\(self.C())RunUp")
                self.act("\(self.C())RunTomatoDown",
                    count:-1,
                    speed:1,
                    fadeIn:0,
                    fadeOut:0,
                    animationName: "\(self.C())RunDown")
                self.model.removeAnimation(forKey:"\(self.C())RunStartUp")
                self.model.removeAnimation(forKey:"\(self.C())RunStartDown")
            }
        })
    }
    func stopRunningAnimation() {
        self.canCancelRunning = false
        self.model.removeAnimation(forKey:"\(C())IdleStartUp")
        self.model.removeAnimation(forKey:"\(C())IdleStartDown")
        if(throwing == true) {
            self.model.removeAnimation(forKey:"\(C())RunStartUp")
            self.model.removeAnimation(forKey:"\(C())RunUp")
        }else{
            self.act("\(C())IdleUp",
                count:1,
                speed:1,
                fadeIn:0.3,
                fadeOut:0.3,
                remove: true,
                animationName: "\(C())IdleStartUp")
            delayAndRun(0.2, {
                self.model.removeAnimation(forKey:"\(self.C())RunUp")
            })
        }
        self.act("\(C())IdleDown",
            count:1,
            speed:1,
            fadeIn:0.3,
            fadeOut:0.3,
            remove: true,
            animationName: "\(C())IdleStartDown")
        delayAndRun(0.2, {
            self.model.removeAnimation(forKey:"\(self.C())RunDown")
        })
    }
    func throwAnimation() {
        self.act("\(C())ThrowUp",
            count:1,
            speed:1,
            fadeIn:0.2,
            fadeOut:0.4,
            remove: true)
    }
    func startIdle() {
        self.act("\(C())IdleUp",
            count:-1,
            speed:1,
            fadeIn:0,
            fadeOut:0)
        self.act("\(C())IdleDown",
            count:-1,
            speed:1,
            fadeIn:0,
            fadeOut:0)
    }
    func C()->(String) {
        if(self.character[0] == 0) {
            return("Male")
        }
        return("Female")
    }
}


