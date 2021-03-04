import UIKit
import Foundation

class AliceThirdViewController: UIViewController {
        
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    var id = ""
    
    var detail: [SingleBusiness] = []
    override func viewDidLoad() {

            super.viewDidLoad()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
