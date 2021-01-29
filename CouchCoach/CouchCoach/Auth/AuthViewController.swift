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
        //This runs when login button pressed. I forgot to show this way
        
        // This makes sure there are no nill values
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        // at this point username and password have  text
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          // ...
            strongSelf.performSegue(withIdentifier: strongSelf.authToHomeIdentifier, sender: nil)
        }
    }
    
    @IBAction func createUserButtonPressed(_ sender: Any) {
        //This runs when login button pressed. I forgot to show this way
        
        // This makes sure there are no nill values
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
          // ...
            guard let strongSelf = self else { return }
            
            strongSelf.performSegue(withIdentifier: strongSelf.authToHomeIdentifier, sender: nil)
        }
    }
}
