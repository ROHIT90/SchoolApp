import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    let fireBaseLogin = FireBaseLogin()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signUpTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.setDisplayName(user!)
            let alert = UIAlertController(title: "", message: "Account has been created", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
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
            self.fireBaseLogin.signedIn(FIRAuth.auth()?.currentUser)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
