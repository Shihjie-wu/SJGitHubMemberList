//
//  ViewController.swift
//  SJGitHubMemberList
//
//  Created by Zero on 2020/8/26.
//  Copyright © 2020 Zero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnAction(_ sender: Any) {
        performSegue(withIdentifier: "toOpenUserListSegue", sender: nil)
    }
    
}

