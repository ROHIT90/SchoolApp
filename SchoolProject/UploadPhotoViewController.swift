import UIKit
import Firebase

class UploadPhotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let photoView = UploadPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func photoButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "LogInView") 
            self.present(vc, animated: false, completion: nil)
        }
    }
}

extension UploadPhotoViewController: UITableViewDelegate {

}

extension UploadPhotoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoTableViewCell
        
        cell.photoImageView.backgroundColor = UIColor.red
        
        return cell
    }
    
}
