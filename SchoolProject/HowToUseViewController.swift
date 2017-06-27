//
//  HowToUseViewController.swift
//  SchoolProject
//
//  Created by Fnu, Rohit on 6/27/17.
//  Copyright © 2017 Fnu, Rohit. All rights reserved.
//

import UIKit

class HowToUseViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
