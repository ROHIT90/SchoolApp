import UIKit
import Firebase

class ProfilePictureViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var addImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func uploadButtonTapped(_ sender: Any) {
        guard let image = addImageView.image  else {
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUID = NSUUID().uuidString
            let metData = FIRStorageMetadata()
            metData.contentType = "image/jpeg"
            
            DataService.ds.REF_STORAGE_PROFILEIMAGES.child(imageUID).put(imageData, metadata: metData) {(metData, error) in
                if error != nil {
                    print("UPLOAD: Unable to upload pic")
                } else {
                    print("UPLOAD: succesful to upload pic")
                    let downloadURL = metData?.downloadURL()?.absoluteString
                    if let url =  downloadURL {
                        self.postToFireBase(imageUrl: url)
                    }
                }
            }
        }
    }
    
    func postToFireBase(imageUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "profileImage":imageUrl as AnyObject
        ]
        
        let fireBasePost = DataService.ds.REF_POSTS.childByAutoId()
        fireBasePost.setValue(post)
    }
    
    @IBAction func imageGestureTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImageView.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
