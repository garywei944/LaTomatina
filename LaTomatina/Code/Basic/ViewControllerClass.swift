import UIKit
import QuartzCore
import SceneKit
var mainViewController:ViewControllerClass?
class ViewControllerClass: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        read()
        manager.viewController = self
        mainViewController = self
        mainView = self.view as? ViewClass
        if let view = mainView {
            view.initialize()
        }
    }
    override var shouldAutorotate: Bool {
        return(true)
    }
    override var prefersStatusBarHidden: Bool {
        return(true)
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if(UIDevice.current.userInterfaceIdiom == .phone) {
            return(.allButUpsideDown)
        }else{
            return(.all)
        }
    }
    func presentInputViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "InputViewController")
        self.present(controller, animated: true, completion: nil)
    }
    func presentMessageViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MessageViewController")
        self.present(controller, animated: true, completion: nil)
    }
}
func presentTextInput() {
    lockAllInteraction = true
    if Thread.isMainThread {
        if let VC = mainViewController {
            VC.presentInputViewController()
        }
    }else{
        DispatchQueue.main.sync {
            if let VC = mainViewController {
                VC.presentInputViewController()
            }
        }
    }
}
func presentMessage(_ content:String, _ button:String) {
    lockAllInteraction = true
    messageContent = content
    messageButton = button
    if Thread.isMainThread {
        if let VC = mainViewController {
            VC.presentMessageViewController()
        }
    }else{
        DispatchQueue.main.sync {
            if let VC = mainViewController {
                VC.presentMessageViewController()
            }
        }
    }
}
