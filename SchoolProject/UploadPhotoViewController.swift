import UIKit
import Firebase
import SwiftKeychainWrapper
import NVActivityIndicatorView

class UploadPhotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    let photoView = UploadPhotoView()
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var imageSelected =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func photoGestureTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImageView.image = image
            imageSelected = true
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postGestureTapped(_ sender: Any) {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let activityIndicator = NVActivityIndicatorView(frame: rect, type: .lineScale, color: UIColor(red:244/255, green:67/255, blue:54/255, alpha:1), padding: CGFloat(0))
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        self.view.endEditing(true)

        guard let caption = captionField.text, caption != ""  else {
            activityIndicator.stopAnimating()
            return
        }
        
        guard let image = addImageView.image, imageSelected == true  else {
            activityIndicator.stopAnimating()
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUID = NSUUID().uuidString
            let metData = FIRStorageMetadata()
            metData.contentType = "image/jpeg"
            
            DataService.ds.REF_STORAGE_IMAGES.child(imageUID).put(imageData, metadata: metData) {(metData, error) in
                if error != nil {
                    print("UPLOAD: Unable to upload pic")
                    activityIndicator.stopAnimating()
                } else {
                    print("UPLOAD: succesful to upload pic")
                    activityIndicator.stopAnimating()
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
            "caption":captionField.text as AnyObject,
            "imageUrl":imageUrl as AnyObject,
            "like":0 as AnyObject
        ]
        
        let fireBasePost = DataService.ds.REF_POSTS.childByAutoId()
        fireBasePost.setValue(post)
        
        captionField.text = ""
        addImageView.image = UIImage(named:"add_photo_btn")
        imageSelected = false
        tableView.reloadData()
    }
    
    @IBAction func logOutGestureTapped(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        self.dismiss(animated: false, completion: nil)
    }
}

extension UploadPhotoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400.0
    }
}

extension UploadPhotoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PhotoTableViewCell {
            if let image = UploadPhotoViewController.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, image: image)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else { return PhotoTableViewCell() }
    }
}

extension UploadPhotoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
