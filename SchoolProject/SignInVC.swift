import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseInstanceID

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        let faceBookLoginManager = FBSDKLoginManager()
        faceBookLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("FB: Unable to aunthenticate with fb \(error)")
            } else if result?.isCancelled == true {
                print("FB: user cancelled authentication")
            } else {
                print("FB: successfully authenticated with faceBook")
                let credentials = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.fireBaseAuth(credentials)
            }
        }
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: rect) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(actInd)
        actInd.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                actInd.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                return
            }
            self.signedIn(user!)
            self.view.isUserInteractionEnabled = true
            
            actInd.stopAnimating()
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
            self.signedIn(FIRAuth.auth()?.currentUser)
        }
    }
    
    func signedIn(_ user: FIRUser?) {
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.signedIn = true
        let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
    }
    
    func fireBaseAuth(_ credentials: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("FB: Unable to aunthenticate with firebase \(error)")
            } else {
                print("FB: Authenticated with firebase")
            }
        })
    }
}

extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

