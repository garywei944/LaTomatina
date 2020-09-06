import UIKit
import QuartzCore
import SceneKit
var messageContent:String = ""
var messageButton:String = ""
class MessageViewController: UIViewController {
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var button: UIButton!
    var buttonPressed:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonPressed = false
        message.text = messageContent
        button.setTitle(messageButton,for: .normal)
    }
    @IBAction func donePressed(_ sender: Any) {
        if(buttonPressed == true) {
            return
        }
        buttonPressed = true
        delayAndRun(0.2,{
            self.dismiss(animated: true)
            lockAllInteraction = false
        })
    }
}
