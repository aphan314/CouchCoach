import UIKit
import Firebase
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    // In swift there are var and let
    // var is a variable that can be changed
    // let is a constant
    var counter = 0
    private var locationManager:CLLocationManager?
    let logoutSegueIdentifier = "logoutSegue"
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLocation()
    }

    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationLabel.text = "Lat : \(location.coordinate.latitude) \nLng : \(location.coordinate.longitude)"
        }
    }
    
    // Kinda like an IBOutlet, except this is for when buttons are pressed
    @IBAction func ExampleButton(_ sender: UIButton) {
        counter += 1
        counterLabel.text = "Counter: \(counter)"
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: logoutSegueIdentifier, sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
