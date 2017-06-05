import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseInstanceID
import NVActivityIndicatorView
import SCLAlertView
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    let fireBaseLogin = FireBaseLogin()

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            self.performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
        }
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        
        let faceBookLoginManager = FBSDKLoginManager()
        faceBookLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
            } else if result?.isCancelled == true {
            } else {
                let credentials = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.fireBaseLogin.fireBaseAuth(credentials)
                self.performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let activityIndicator = NVActivityIndicatorView(frame: rect, type: .lineScale, color: UIColor(red:244/255, green:67/255, blue:54/255, alpha:1), padding: CGFloat(0))
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                SCLAlertView().showError("", subTitle: error.localizedDescription)
                activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                return
            }
            self.fireBaseLogin.signedIn(user!)
            self.performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
            self.view.isUserInteractionEnabled = true
            if let user = user {
            
                DataService.ds.createUser(uid: user.uid, userData: ["provider": user.providerID])
                KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
            }
            self.setDisplayName(user!)

            print("this is username\(self.emailTextField.text)")

            activityIndicator.stopAnimating()
        }
    }
    
    func setDisplayName(_ user: FIRUser?) {
        let changeRequest = user?.profileChangeRequest()
        changeRequest?.displayName = user?.email!.components(separatedBy: "@")[0]
        changeRequest?.commitChanges(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.userName(FIRAuth.auth()?.currentUser)
        }
    }
    
    func userName(_ user:FIRUser?)  {
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
    }
}

extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


