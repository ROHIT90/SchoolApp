import UIKit
import Firebase
import SwiftKeychainWrapper

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
        guard let caption = captionField.text, caption != ""  else {
            return
        }
        
        guard let image = addImageView.image, imageSelected == true  else {
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            let imageUID = NSUUID().uuidString
            let metData = FIRStorageMetadata()
            metData.contentType = "image/jpeg"
            
            DataService.ds.REF_STORAGE_IMAGES.child(imageUID).put(imageData, metadata: metData) {(metData, error) in
                if error != nil {
                    print("UPLOAD: Unable to upload pic")
                } else {
                    print("UPLOAD: succesful to upload pic")
                    let downloadURL = metData?.downloadURL()?.absoluteString
                }
            }
        }
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
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
        } else { return PhotoTableViewCell() }
    }
}
