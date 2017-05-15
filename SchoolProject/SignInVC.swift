import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseInstanceID

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    let fireBaseLogin = FireBaseLogin()

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
                self.fireBaseLogin.fireBaseAuth(credentials)
            }
        }
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: rect) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.backgroundColor = UIColor.red
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
            self.fireBaseLogin.signedIn(user!)
            self.performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
            self.view.isUserInteractionEnabled = true
            
            actInd.stopAnimating()
        }
    }
    

    
}

extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


