//
//  Constatnts.swift
//  SchoolProject
//
//  Created by Fnu, Rohit on 5/2/17.
//  Copyright © 2017 Fnu, Rohit. All rights reserved.
//

import UIKit

let SHADOW_GREY: CGFloat = 120.0/255.0
let KEY_UID = "uid"
let KEY_USERNAME = "username"


struct Constants {
    
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }
    
    struct Segues {
        static let SignInToFp = "SignInToFP"
        static let FpToSignIn = "FPToSignIn"
        static let FpToUploadImage = "uploadImageScene"
    }
}
