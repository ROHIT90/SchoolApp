//
//  AppState.swift
//  SchoolProject
//
//  Created by Fnu, Rohit on 5/4/17.
//  Copyright © 2017 Fnu, Rohit. All rights reserved.
//

import Foundation

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
}
