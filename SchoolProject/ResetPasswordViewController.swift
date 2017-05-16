import UIKit
import Firebase
import SCLAlertView

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: Any) {
        if let email = emailTextField.text {
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
                if error == nil {
                    SCLAlertView().showSuccess("Password Reset", subTitle: "An email has been sent to you with password reset instructions")
                } else {
                    SCLAlertView().showError("", subTitle: "Please enter valid email id")
                }
            })
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
