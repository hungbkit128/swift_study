//
//  AddViewController.swift
//  ViperDemo
//
//  Created by Vtsoft2 on 4/16/18.
//  Copyright © 2018 Viettel. All rights reserved.
//

import UIKit

protocol AddViewControllerDelegate: class {
    func didButtonPress(_ text: String)
}

class AddViewController: UIViewController {
    
    @IBOutlet weak var tfContent: UITextField!
    weak var delegate:AddViewControllerDelegate?
    
    var completionHandler: ((_ text: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func startViewBtnTaped(_ sender: Any) {
        if let action = self.completionHandler {
            action(tfContent.text!)
        }
        self.delegate?.didButtonPress(tfContent.text!)
        self.dismiss(animated: true, completion: nil)
    }
}
