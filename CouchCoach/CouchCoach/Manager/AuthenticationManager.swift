import Foundation
import Firebase

class AuthenticationManager {
    static let shared = AuthenticationManager()
    static var user: User?
    
    var isAuthenticated: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func createUser (email: String, password: String, completion: @escaping(Bool, String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                var errorMessage = ""
                if let error = AuthErrorCode(rawValue: error!._code) {
                    switch error {
                    case.invalidEmail:
                        errorMessage = "Invalid Email"
                    case .emailAlreadyInUse:
                        errorMessage = "Email Already In Use"
                    default:
                        errorMessage = "Registration Error: \(error)"
                    }
                }
                completion(false, errorMessage)
                return
            }
            let db = Firestore.firestore()
            
            db.collection("users").document(authResult!.user.uid).setData(["email":email])
            completion(true, "")
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping(Bool, String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            guard error == nil else {
                   var errorMessage = ""
                   if let error = AuthErrorCode(rawValue: error!._code) {
                       switch error {
                       case.invalidEmail:
                           errorMessage = "Invalid Email"
                       case .wrongPassword:
                           errorMessage = "Incorrect Password"
                       default:
                           errorMessage = "Login Error: \(error)"
                       }
                   }
                   completion(false, errorMessage)
                   return
               }
               
               completion(true, "")
        }
    }
    
    func logout(completion: @escaping(Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(false)
        }
    }
}
