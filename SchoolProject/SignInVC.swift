import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

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

