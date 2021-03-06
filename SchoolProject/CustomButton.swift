//
//  CustomButton.swift
//  SchoolProject
//
//  Created by Fnu, Rohit on 5/2/17.
//  Copyright © 2017 Fnu, Rohit. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 1).cgColor
        layer.shadowOpacity = 0.0
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width:1.0, height:1.0)
        layer.cornerRadius = 2.0
    }

}
