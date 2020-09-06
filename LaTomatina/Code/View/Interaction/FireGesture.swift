import UIKit
class FireGesture: UIGestureRecognizer {
    var timeThreshold = 0.2
    var distanceThreshold = 8.0
    private var startTimes = [Int:TimeInterval]()
    var touchPosition = CGPoint()
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch in touches {
            startTimes[touch.hash] = touch.timestamp
            if let view = mainView {
                touchPosition = touch.location(in: view)
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch in touches {
            let newPos = touch.location(in: view)
            let oldPos = touch.previousLocation(in: view)
            let distanceDelta = Double(max(abs(newPos.x - oldPos.x),
                                           abs(newPos.y - oldPos.y)))
            if distanceDelta >= distanceThreshold {
                startTimes[touch.hash] = nil
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        for touch in touches {
            let startTime = startTimes[touch.hash]
            if let startTime = startTime {
                let timeDelta = touch.timestamp - startTime
                if timeDelta < timeThreshold {
                    state = .ended
                }
            }
        }
        reset()
    }
    override func touchesCancelled(_ touches: Set<UITouch>,
                                   with event: UIEvent) {
        reset()
    }
    override func reset() {
        if(state == .possible) {
            state = .failed
        }
    }
}
