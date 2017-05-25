import Foundation
import Firebase

//url
let DB_BASE = FIRDatabase.database().reference()


class DataService {
    
    static let ds = DataService()
    private var _REF_DB = DB_BASE
    private var _REF_POSTS = DB_BASE.child("Posts")
    private var _REF_USERS = DB_BASE.child("Users")
    
    var REF_DB:FIRDatabaseReference {
        return _REF_DB
    }
    
    var REF_POSTS:FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS:FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
