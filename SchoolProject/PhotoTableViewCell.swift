import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var uploadImage: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    var post: Post!
    
    func configureCell(post: Post) {
        self.post = post
        self.commentTextView.text = post.caption
        self.numberOfLikesLabel.text = String(post.likes)
    }
    
}
