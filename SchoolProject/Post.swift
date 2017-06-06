import Foundation
import Firebase

class Post {
    private var _caption: String!
    private var _imageUrl: String!
    private var _userName:String!
    private var _likes: Int!
    private var _postKey: String!
    private var _profileImageUrl: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption:String {
        return _caption
    }
    
    var imageUrl:String {
        return _imageUrl
    }
    
    var likes:Int {
        return _likes
    }
    
    var postKey:String {
        return _postKey
    }
    
    var userName:String {
        return _userName
    }
    
    var profileImageUrl:String {
        return _profileImageUrl
    }
    
    
    init(caption:String, imageUrl:String, likes:Int, userName:String, profileImageUrl:String) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
        self._userName = userName
        self._profileImageUrl = profileImageUrl
    }
    
    init(postKey:String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["like"] as? Int {
            self._likes = likes
        }
        
        if let userName = postData["userName"] as? String {
            self._userName = userName
        }
        
        if let profileImageUrl = postData["profileImage"] as? String {
            self._profileImageUrl = profileImageUrl
        }
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    func adjustLike(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        
        _postRef.child("like").setValue(_likes)
    }
}
