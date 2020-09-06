import UIKit
import QuartzCore
import SceneKit
class InputViewController: UIViewController {
    @IBOutlet weak var inputField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        inputField.becomeFirstResponder()
    }
    @IBAction func endInput(_ sender: Any) {
        if let txt = inputField.text {
            player.name = txt
            player.needUpdateName = true
            self.dismiss(animated: true)
            lockAllInteraction = false
            write()
        }
    }
    @IBAction func inputChanged(_ sender: Any) {
        if var txt = inputField.text {
            while(txt.count > 15){
                txt = String(txt.dropLast())
                inputField.text = txt
            }
        }
    }
}
