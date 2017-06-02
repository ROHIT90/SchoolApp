import Foundation
import Firebase
import SwiftKeychainWrapper

//url
let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()



class DataService {
    
    static let ds = DataService()
    //DATABASE REFRENCE
    private var _REF_DB = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("Users")
    
    //STORAGE REFRENCE
    private var _REF_STORAGE_IMAGES =  STORAGE_BASE.child("post-pics")
    
    var REF_STORAGE_IMAGES:FIRStorageReference {
        return _REF_STORAGE_IMAGES
    }
    
    
    var REF_DB:FIRDatabaseReference {
        return _REF_DB
    }
    
    var REF_POSTS:FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USER_CURRENT:FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    
    var REF_USERS:FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
