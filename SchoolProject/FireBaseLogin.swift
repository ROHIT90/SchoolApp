import Foundation
import Firebase
import FirebaseInstanceID

class FireBaseLogin {
    
    func fireBaseAuth(_ credentials: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("FB: Unable to aunthenticate with firebase \(error)")
            } else {
                print("FB: Authenticated with firebase")
            }
        })
    }
    
    func signedIn(_ user: FIRUser?) {
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.signedIn = true
        let notificationName = Notification.Name(rawValue: Constants.NotificationKeys.SignedIn)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
    }
}