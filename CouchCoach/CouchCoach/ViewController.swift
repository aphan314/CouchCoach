import UIKit
import Firebase

class ViewController: UIViewController {
    
    let logoutSegueIdentifier = "logoutSegue"
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.startUpdatingLocation()
        getUserLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserLocation()
    }

    func getUserLocation() {
        guard let location = LocationManager.shared.lastLocation else { return }
        
        locationLabel.text = "Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)"
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        AuthenticationManager.shared.logout { result in
            switch result {
            case true:
                self.performSegue(withIdentifier: self.logoutSegueIdentifier, sender: nil)
            case false:
                self.displayAlert(title: "Error", message: "Try Logging out again")
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
