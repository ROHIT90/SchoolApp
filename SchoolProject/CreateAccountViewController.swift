import UIKit
import Firebase
import SCLAlertView

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
                SCLAlertView().showError("", subTitle: error.localizedDescription)
                return
            }
            self.setDisplayName(user!)
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let successAlert = SCLAlertView(appearance: appearance)
            successAlert.addButton("Done") {
                self.dismiss(animated: false, completion: nil)
            }
            successAlert.showSuccess("Congrats!", subTitle: "Your account has been created")
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
