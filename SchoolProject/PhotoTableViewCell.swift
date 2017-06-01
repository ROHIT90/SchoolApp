import UIKit
import Firebase

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var uploadImage: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    var post: Post!
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        self.commentTextView.text = post.caption
        self.numberOfLikesLabel.text = String(post.likes)
        
        if image != nil {
            self.uploadImage.image = image
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: {(data, error) in
                if error != nil {
                    print("FStorage: Unable to download image")
                } else {
                    print("FStorage: Image downloaded")
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.uploadImage.image = image
                            UploadPhotoViewController.imageCache.setObject(image, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }
    
}
