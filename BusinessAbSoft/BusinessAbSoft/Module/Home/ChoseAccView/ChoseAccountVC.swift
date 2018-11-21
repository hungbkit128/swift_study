//
//  ChoseAccountVC.swift
//  BusinessAbSoft
//
//  Created by Vtsoft2 on 11/21/18.
//  Copyright © 2018 hungtv. All rights reserved.
//

import UIKit

class ChoseAccountVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var accTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

}
