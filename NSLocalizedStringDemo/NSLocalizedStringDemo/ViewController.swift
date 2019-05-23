//
//  ViewController.swift
//  NSLocalizedStringDemo
//
//  Created by Hưng Trần on 5/2/19.
//  Copyright © 2019 Hưng Trần. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var lb: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btn.setTitle(NSLocalizedString("key.hello", comment: ""), for: .normal)
        lb.text = NSLocalizedString("key.hello", comment: "")
    }


}

