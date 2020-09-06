import Foundation
import SpriteKit
import SceneKit
func KEInt(_ i:Int)->(Int) {
    if(i <= 0){
        return(0)
    }
    return(Int(arc4random()%UInt32(i)))
}
func KEFloat(_ i:Int)->(Float) {
    if(i <= 0){
        return(0)
    }
    return(Float(arc4random()%UInt32(i)))
}
func KEFr()->(Float) {
    if(KEInt(2) == 0) {
        return(1)
    }
    return(-1)
}
func KECGFr()->(CGFloat) {
    if(KEInt(2) == 0) {
        return(1)
    }
    return(-1)
}
func KECGFloat(_ i:Int)->(CGFloat) {
    if(i <= 0){
        return(0)
    }
    return(CGFloat(arc4random()%UInt32(i)))
}
func isPositionEqual(_ a:SCNVector3,_ b:SCNVector3)->(Bool){
    if(a.x==b.x)&&(a.y==b.y)&&(a.z==b.z){
        return(true)
    }
    return(false)
}
func isPositionEqualII(_ a:SCNVector3,_ b:SCNVector3)->(Bool){
    if(a.x==b.x)&&(a.z==b.z){
        return(true)
    }
    return(false)
}
func calculate(_ s:SCNVector3,_ e:SCNVector3)->(Float){
    let a = (s.x-e.x)*(s.x-e.x)
    let b = (s.y-e.y)*(s.y-e.y)
    let c = (s.z-e.z)*(s.z-e.z)
    let r = sqrt(a+b+c)
    return(r)
}
func calculateII(_ s:SCNVector3,_ e:SCNVector3)->(Float){
    let a = (s.x-e.x)*(s.x-e.x)
    let c = (s.z-e.z)*(s.z-e.z)
    let r = sqrt(a+c)
    return(r)
}
func getMidPoint(_ a:SCNVector3,_ b:SCNVector3)->(SCNVector3){
    let x = (a.x+b.x)/2
    let y = (a.y+b.y)/2
    let z = (a.z+b.z)/2
    return(SCNVector3(x,y,z))
}
extension SCNTransaction {
    class func animateWithDuration(_ duration: CFTimeInterval = 0.25,
                                   timingFunction: CAMediaTimingFunction? = nil,
                                   completionBlock: (() -> Void)? = nil,
                                   animations: () -> Void) {
        begin()
        self.animationDuration = duration
        self.completionBlock = completionBlock
        self.animationTimingFunction = timingFunction
        animations()
        commit()
    }
}
func numToChar(_ num:Int)->(String) {
    var numstr:String="\(num)"
    for _ in numstr.count..<4 {
        numstr="0\(numstr)"
    }
    return(numstr)
}
func delayAndRun(_ i:TimeInterval, _ action:@escaping (() -> Void)) {
    let when = DispatchTime.now() + i
    DispatchQueue.main.asyncAfter(deadline: when) {
        action()
    }
}
extension SCNNode {
    func destroy() {
        self.removeFromParentNode()
        for node in self.childNodes {
            node.destroy()
        }
    }
}
func convertToCenter(_ i:SCNVector3)->(SCNVector3) {
    var result:SCNVector3 = i
    if(i.x > 0) {
        result.x = Float(Int(result.x)/40)
        result.x -= 40.0
        while(abs(i.x - result.x) > 20.0) {
            result.x += 40.0
        }
    }else{
        result.x = -result.x
        result.x = Float(Int(result.x)/40)
        result.x -= 40.0
        while(abs(abs(i.x) - result.x) > 20.0) {
            result.x += 40.0
        }
        result.x = -result.x
    }
    if(i.z > 0) {
        result.z = Float(Int(result.z)/40)
        result.z -= 40.0
        while(abs(i.z - result.z) > 20.0) {
            result.z += 40.0
        }
    }else{
        result.z = -result.z
        result.z = Float(Int(result.z)/40)
        result.z -= 40.0
        while(abs(abs(i.z) - result.z) > 20.0) {
            result.z += 40.0
        }
        result.z = -result.z
    }
    return(result)
}
