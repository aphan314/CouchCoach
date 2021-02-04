import UIKit
import Firebase

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorText: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let authToHomeIdentifier = "authPresentHome"
    
    override func viewDidLoad() {
        errorText.text = ""
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
            if error != nil{
                if let error = AuthErrorCode(rawValue: error!._code){
                    switch error{
                    case .invalidEmail:
                        self?.errorText?.text = "Invalid Email"
                    case .wrongPassword:
                        self?.errorText?.text = "Incorrect Password"
                    default:
                        self?.errorText?.text = "Login Error: \(error)"
                        
                    }
                }
            }
            else{
                guard let strongSelf = self else { return }
          // ...
                strongSelf.performSegue(withIdentifier: strongSelf.authToHomeIdentifier, sender: nil)
            }
        }
    }
    
    @IBAction func createUserButtonPressed(_ sender: Any) {
        //This runs when login button pressed. I forgot to show this way
        
        // This makes sure there are no nill values
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        if email.isEmpty{
            errorText.text = "Email Is Missing"
            return
        }
        if password.isEmpty{
            errorText.text = "Password Is Missing"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
          // ...
            if error != nil {
                if let error = AuthErrorCode(rawValue: error!._code){
                    switch error{
                    case .invalidEmail:
                        self?.errorText?.text = "Invalid Email"
                    case .emailAlreadyInUse:
                        self?.errorText?.text = "Email Already In Use"
                    default:
                        self?.errorText?.text = "Registration Error: \(error)"
                        
                    }
                }
            }
            else{
                guard let strongSelf = self else { return }
                strongSelf.performSegue(withIdentifier: strongSelf.authToHomeIdentifier, sender: nil)
            }
            
            
            
        }
    }
}
