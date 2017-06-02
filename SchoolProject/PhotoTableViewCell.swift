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
    
    var likeRef:FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        likeRef =  DataService.ds.REF_USER_CURRENT.child("like").child(post.postKey)

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
        likeRef.observeSingleEvent(of: .value, with: { (snapShot) in
            if let _ =  snapShot.value as? NSNull {
                self.likeImage.image = UIImage(named:"heart_deselected_icon")
            } else {
                self.likeImage.image = UIImage(named:"heart_icon_round")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likeRef.observeSingleEvent(of: .value, with: { (snapShot) in
            if let _ =  snapShot.value as? NSNull {
                self.likeImage.image = UIImage(named:"heart_icon_round")
                self.post.adjustLike(addLike: true)
                self.likeRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named:"heart_deselected_icon")
                self.post.adjustLike(addLike: false)
                self.likeRef.removeValue()
            }
        })
    }
}
