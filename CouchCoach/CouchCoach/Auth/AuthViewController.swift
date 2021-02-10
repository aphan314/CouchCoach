import UIKit
import Firebase

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let authToHomeIdentifier = "authPresentHome"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, !(isTextEmpty()) else {
            return
        }


        AuthenticationManager.shared.signIn(email: email, password: password) { (result, message) in
            switch result {
            case true:
                self.performSegue(withIdentifier: self.authToHomeIdentifier, sender: nil)
            case false:
                self.displayAlert(title: "Error", message: message)
            }
        }
    }
    
    @IBAction func createUserButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        AuthenticationManager.shared.createUser(email: email, password: password) { result, message  in
            switch result {
            case true:
                //segue into home
                self.performSegue(withIdentifier: self.authToHomeIdentifier, sender: nil)
            case false:
                //display alert
                self.displayAlert(title: "Error", message: message)
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

    private func isTextEmpty() -> Bool {
        if let email = emailTextField.text, email.isEmpty {
            displayAlert(title: "Error", message: "Email  is missing")
            return true
        }
        if let password = passwordTextField.text, password.isEmpty {
            displayAlert(title: "Error", message: "Password is missing")
            return true
        }
        return false
    }
}
